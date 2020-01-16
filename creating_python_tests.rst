=====================
Creating Python Files
=====================

If running a Python simulator certain commands and steps should be added and followed in order for the test suite to run correctly. A time slice (looking at the entire grid at certain times) and/or observation point (looking at one point over the entire time) can be implemented. If only running a time slice, the observation additions may be ignored and vice versa. Error metrics are implemented the same way as for other simulators, by setting `plot_error` and/or `print_error` to True in the options file.

1. Import sys, traceback, qa_common, and simulator_modules. Make sure paths are set correctly to simulator modules.

   .. code-block:: python

      import sys
      import traceback

      sys.path.insert(0,'..')
      sys.path.insert(0, '../simulator_module')

      from qa_common import *

      from simulator_modules.solution import SolutionWriter
      from simulator_modules.python import *


2. Define filename variable which will be used to get the solution filename.

   .. code-block:: python

      filename = __file__

      
3. Set up your file by using a main function and then execute using a try and except block.

   .. code-block:: python

      def main(options):


   .. code-block:: python
		   
      if __name__ == "__main__":
        cmdl_options=[]
        try:
            suite_status = main(cmdl_options)
	    sys.exit(suite_status)
        except:
	    print(str(error))
	    traceback.print_exc()
	    print("failure")
	    sys.exit(1)

4. In the main function make sure the folloinwg are set:

   a. If the time unit is different than years than a time unit variable must be set.

      .. code-block:: python

         time_unit = 'd'

      Acceptable values include:

      * 'y','yr','yrs','year','years' = years
      * 'mo','month' = month
      * 'd','day' = day
      * 'h','hr','hour' = hour
      * 'm','min','minute' = minute
      * 's','sec','second' = second
	

   b. Make a SolutionWriter object which the test suite will use to convert the solution to h5 format.

      .. code-block:: python

	 solution_filename = get_python_solution_filename(filename)
	 solution = SolutionWriter(solution_filename, time_unit)

      The time_unit variable is an optional input paramater into SolutionWriter, as mentioned above if time units are in years this is not needed.
      

   c. Define x, y, and z numpy arrays even when working in less than 3D. For an observation point this will represent a point matching what is in the options file under `locations`.  

      Time Slice Example:     

      .. code-block:: python

	 x_time_slice = np.linspace(0. + (dx/2.),Lx-(dx/2.),nx)
	 y_time_slice =  np.array([0.5])
	 z_time_slice = np.array([0.5])


      Observation Point Example:

      .. code-block:: python

	 x_observation = np.array([15])
	 y_observation = np.array([0.5])
	 z_observation = np.array([0.5])


   d. If creating a solution for an observation point write the time and solution to the SolutionWriter object.

      .. code-block:: python

	solution.write_time(t_soln)

      Where `t_soln` is an array of times the function will run over.

  
      .. code-block:: python

	#solution.write_dataset(coordinates,solution,variable_string,'Observation')	      
	solution.write_dataset(np.concatenate((x_observation,y_observation,z_observation)),p_soln,'Liquid_Pressure','Observation')

      Coordinates must be in 3D (x,y,z), solution can be in 1D, 2D, or 3D, and variable_string matches what was inputted into the `variables` key in the options file.

      
   e. If creating a solution for a time slice output write the coordinates and solution to the SolutionWriter object.

      .. code-block:: python

	 solution.write_coordinates(x_time_slice,y_time_slice,z_time_slice)

      .. code-block:: python

	 #solution.write_dataset(time,solution,variable_string)	      
	 solution.write_dataset(t_soln[time],p_soln[time,:],'Liquid_Pressure')


      Time is the time the solution is for and is 1D, the solution is a numpy array that can be 1D, 2D, or 3D, and variable_string matches what was inputted into the `variables` key in the options file.

   f. Destroy the solution object.

      .. code-block:: python

         solution.destroy()

  
5. Putting it all together an example python file is below with added commands highlighted.

   .. code-block:: python
      :emphasize-lines: 1,2, 4, 5, 10, 12, 13, 15, 42, 43, 47, 63, 74, 91, 94

      import sys
      import traceback

      sys.path.insert(0,'..')
      sys.path.insert(0,'../simulator_module')

      import numpy as np
      import math

      from qa_common import *

      from simulator_modules.solution import SolutionWriter
      from simulator_modules.python import *

      filename = __file__
      epsilon_value = 1.e-30

      def main(options):

	print('Beginning {}.'.format(filename))

	nx = swap{nx,10}
	tx = 10
	time_unit = 'd' ####Unit for time
	Lx = 100
	dx = Lx/nx

	k = 1.0e-14
	mu = 1.728e-3
	por = 0.20
	kappa = 1.0e-9
	chi = k/(por*kappa*mu)
	p_offset = .101325

	t_soln = np.linspace(0,0.50,tx) ##array of times
	x_observation = np.array([15.0])
	y_observation = np.array([0.5])
	z_observation = np.array([0.5])
	p_soln = np.zeros((t_soln.size))#,tx))
    

	solution_filename = get_python_solution_filename(filename)
	solution = SolutionWriter(solution_filename,time_unit)

	#THIS IS AN OBSERVATION POINT EXAMPLE#
        ###########################################################
	solution.write_time(t_soln)
	for time in range(t_soln.size):
	    t = t_soln[time]*24.0*3600.0  # [sec]
	    sum_term_old = 0 # np.zeros(nx)
	    sum_term = 0 #np.zeros(nx)
	    n = 1
	    epsilon = 1.0
      
	    while epsilon > epsilon_value:
		sum_term_old = sum_term
		sum_term = sum_term_old + (np.cos(n*math.pi*x_observation/Lx)*np.exp(-chi*pow(n,2)*pow(math.pi,2)*t/pow(Lx,2))*(80./(3.*pow((n*math.pi),2)))*np.cos(n*math.pi/2.)*np.sin(n*math.pi/4.)*np.sin(3.*n*math.pi/20.))
		epsilon = np.max(np.abs(sum_term_old-sum_term))
		n = n + 1
	    p_soln[time] = ((0.50 + sum_term) + p_offset)*1.0e6

	#solution.write_dataset((x,y,z),solution,variable_string,'Observation')
	solution.write_dataset(np.concatenate((x_observation,y_observation,z_observation)),p_soln,'Liquid_Pressure','Observation')
        #######################################################

        #TIME SLICE EXAMPLE#
	######################################################
	t_soln = np.array([0.05,0.10,0.25,0.50]) 
	p_soln = np.zeros((t_soln.size,nx))
	x_time_slice = np.linspace(0.+(dx/2.),Lx-(dx/2.),nx)
	y_time_slice = np.array([0.5])
	z_time_slice = np.array([0.5])
    
	solution.write_coordinates(x_time_slice,y_time_slice,z_time_slice)

	for time in range(4):
	    t = t_soln[time]*24.0*3600.0  # [sec]
	    sum_term_old = np.zeros(nx)
	    sum_term = np.zeros(nx)
	    n = 1
	    epsilon = 1.0
      
	    while epsilon > epsilon_value:
		sum_term_old = sum_term
		sum_term = sum_term_old + (np.cos(n*math.pi*x_time_slice/Lx)*np.exp(-chi*pow(n,2)*pow(math.pi,2)*t/pow(Lx,2))*(80./(3.*pow((n*math.pi),2)))*np.cos(n*math.pi/2.)*np.sin(n*math.pi/4.)*np.sin(3.*n*math.pi/20.))
		epsilon = np.max(np.abs(sum_term_old-sum_term))
		n = n + 1
	    p_soln[time,:] = ((0.50 + sum_term) + p_offset)*1.0e6
	    
            #solution.write_dataset(time,solution,variable_string)
	    solution.write_dataset(t_soln[time],p_soln[time,:],'Liquid_Pressure')
	    ######################################################

	solution.destroy()
	print('Finished with {}.'.format(filename))

      if __name__ == "__main__":
	cmdl_options=[]
        try:
            suite_status=main(cmdl_options)
            sys.exit(suite_status)
        except Exception as error:
            print(str(error))
            traceback.print_exc()
            print("failure")
            sys.exit(1)
