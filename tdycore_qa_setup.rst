QA Repository Setup
===================

Each test for the qa-toolbox consists of input decks for simulators, a configuration file, and an options file.

Tests can be run to produce a time slice (all locations at one time) and/or an observation point (one location at all times).

Install Software
----------------
The following software needs to be installed in order to run tdycore-qa:

* PETSc
* PFLOTRAN
* TDycore
* Sphinx

1. Install PETSc

   a. Clone PETSc and check out supoorted version

      .. code-block:: bash

	$ git clone https://gitlab.com/petsc/petsc petsc
	$ cd petsc
	$ git checkout v3.11.3

   b. Configure PETSc

      .. code-block:: bash

	$ ./configure --CFLAGS='-O3' --CXXFLAGS='-O3' --FFLAGS='-O3' --with-debugging=no --download-mpich=yes --download-hdf5=yes --download-fblaslapack=yes --download-metis=yes --download-parmetis=yes

   c. Set PETSC_DIR and PETSC_ARCH enviornment variables in ~/.bashrc file.

      .. code-block:: bash

	$ export PETSC_DIR=/home/username/path_to_top_level_petsc
	$ export PETSC_ARCH=gnu-c-debug

   d. Compile PETSc

      .. code-block:: bash

	$ cd $PETSC_DIR
	$ make all

2. Install PFLOTRAN

   a. Clone PFLOTRAN

      .. code-block:: bash

	$ git clone https://bitbucket.org/pflotran/pflotran

   b. Compile PFLOTRAN

      .. code-block:: bash

        $ cd pflotran/src/pflotran
	$ make pflotran

3. Install TDycore

   a. Clone TDycore

      .. code-block:: bash

	$ git clone https://github.com/TDycores-Project/TDycore.git

   b. Checkout appropriate branch and make TDycore

      .. code-block:: bash

	$ cd TDycore
	$ git checkout rosie/test-prefix-error
	$ make

   c. Cd into appropriate folder and make TDycore

      .. code-block:: bash

	$ cd demo/steadyblock
	$ make

   		   
4. Clone qa-toolbox

   .. code-block:: bash

     $ git clone  https://github.com/TDycores-Project/qa-toolbox.git

Adding Tests to Suite
---------------------

1. To create a new tdycore-qa test, create a new folder and cd into the folder.

   .. code-block:: bash

     $ mkdir my_test
     $ cd my_test

2. Create two or more input files for the desired simulators you wish to test. The input file has a file extension based on the simulator you wish to run, such as ``filename.pflotran, filename.python``. The filename will be specified in the configuration file and must be the same for all simulators. For example, you can browse the input decks within the qa-toolbox tests. Note: If working in 2D, 3D, or calculating error only two simulators may be run at a time. 

3. The QA toolbox reads in an options file specified by the user in a standard ``.opt`` extension. The options file consists of a series of sections with key-value pairs.

   ::

    [section-name]
    key = value

   Section names are all lower case with an underscore between words. Required section names are:

   * ouput_options

   Optional section names include:

   * swap_options
   * mapping_options
   * solution_convergence

   An example output_options section is as follows:

   ::

    [output_options]
    times = 10.0 y, 50.0 y, 100.0 y
    locations = 1.0 1.0 1.0, 5.0 1.0 1.0
    plot_time_units = years
    plot_dimension = 1D
    plot_x_label = Time [yr], Distance X [m]
    plot_y_label = Liquid Pressure, Liquid Pressure
    plot_title = Pflotran Test
    variables = liquid_pressure
    plot_type = observation, time slice
    plot_to_screen = True
    plot_error = True
    print_error = True


   * times: (Required for time slice) List of times to plot and compare solutions at. Must match the times of outputs created by simulators. Unit must come after time.
   * locations: (Required for observation point) List of locations (x y z) where specified observation point(s) is indicated in simulator file. Units in [m].
   * plot_time_units: (Required) Units of time to be displayed on plot.
   * plot_dimension: (Required) Dimension of simulation. Options include: 1D, 2D, 3D. If plotting in 2D or 3D only two simulators may be tested at a time.
   * plot_x_label: (Required) Label to be put on x axis of plot. If plotting both a time slice and an observation file, two values must be specified here separted by a comma and order must match order of plot_type.
   * plot_y_label: (Required) Label to be put on y axis of plot. If plotting both a time slice and an observation file, two values must be specified here separted by a comma and order must match order of plot_type.
   * plot_title: (Required) Title to be displayed on plot.
   * variables: (Required) Variable to be plotted from the output files. Must match the simulator output format. Custom mapping of variables can be specified in optional section ``mapping_options``.
   * plot_type: (Optional, default: time slice) Observation if plotting observation point, time slice if plotting time slice. If plotting both order must match plot_x_label and plot_y_label.
   * plot_error: (Optional, default: False) True if plotting relative and absolute error, False if not. If True only two simulatos may be run at a time.
   * print_error: (Optional, default: False) When set to True a .stat file will be created with list of error metrics.
   * plot_to_screen: (Optional, default: False) When set to True images will pop up as python script is being run.

   Optional section ``swap_options`` defines values of variables in input decks to be tested. Each value will correspond to a different run number when outputting figures.

   ::

    [swap_options]
    method = list
    nx = 20, 40
    ny = 30, 50


   * method: (default: list) Options: list, iterative.
      * List: Specifies list of values for different variables. All variables must have the same number of values. The length for each variable should be equal.
      * Iterative: Variables will be increased incrementally for an amount specified by max_attempts. A starting value and an increment should be specified sepearted by a comma. (For example: nx = 12,2 will start nx with a value of 12 and will multiple the value by 2 until max_attempts is reached.)
   * max_attemps: (Required if iterative) Maximum number of iterations to take with iterative method.

   Variables names are listed based on what is defined in the input simulator files. When defining the variable within the input deck the following format must be used `swap{nx,10}`.

   An example is shown in pflotran:

   ::

    GRID
      TYPE structured
      NXYZ swap{nx,10} 1 1
      BOUNDS
        0.d0 0.d0 0.d0
        100.d0 1.d0 1.d0
      END
    END


   
   The optional section ``mapping_options`` can be used when trying to plot unconvential variables and when simulator output names do not match.

   ::
    
    [mapping_options]
    Free X1 [M] = X1
    Free_X1 [M] = X1

   where ``Free X1 [M]`` is the variable name outputted by the simulator and ``X1`` is the variable listed under the variables key in ``output_options``. As many key and value pairs can be listed as needed.

4. Create the configuration file as a standard ``.cfg`` and specify the option file, input deck filenames, and simulators. The title variable is optional and will be displayed as the title for the test in the documentaiton.

   ::

    [OPTIONSFILENAME]
    template = filename
    simulators = pflotran, tdycore

   For example:

   ::

    [tpf_vs_pft]
    title = Tdycore Test
    template = tpf_vs_pft
    simulators = tdycore, pflotran


   Where ``tpf_vs_pft.opt`` is the options file and input decks are named ``kolditz_2_2_10.pflotran`` and ``kolditz_2_2_10.python``.

   Available simulators the toolbox can run include:

   * pflotran
   * tdycore
   * python
   * crunchflow
   * tough3


      
Setup Qa-Toolbox
----------------

1. Cd in qa-toolbox and set up simulator and config_files.

   a. Create a file called simulators.sim and set local paths to executables of the simulators. See `default_simulators.sim` as an example.

   b. Create a file called `config_files.txt` and set the local path to the configuration file for the desired tests. See default_simulators.sim.


Setup Directory
---------------

1. Make a new folder for the QA repository

   .. code-block:: bash

     $ mkdir tdycore-qa

2. Cd into the qa repository and create a documentation directory

   .. code-block:: bash

     $ cd tdycore-qa
     $ mkdir docs

3. Setup sphinx in documentation directory and follow setup instructions.

   .. code-block:: bash

     $ sphinx-quickstart

4. Setup makefile

   a. Cd out of documentation folder and open up new makefile in main directory

      .. code-block:: bash

        $ cd ..
	$ emacs makefile

   b. In makefile set python, and directory to qa_toolbox

      .. code-block:: bash

	PYTHON = python3
	QA_TOOLBOX_DIR = ../qa-toolbox

   c. Run the qa_tests in the makefile by setting the directory and document directory.

      .. code-block:: bash

	$(MAKE) --directory=$(QA_TOOLBOX_DIR) DOC_DIR=${PWD}


Running tdycore-qa in Cloud
---------------------------

To run tdycore_qa in the cloud set up travis-ci with the repository and create a.travis.yml file and .sh file in .travis to install petsc, pflotran, and tdycore and run the qa-toolbox.

1. Write .sh script for travis to run

   a. Clone qa-toolbox
      
   b. Install PETSc and export PETSc variables

      .. code-block:: bash

        git clone https://gitlab.com/petsc/petsc petsc
        PETSC_GIT_HASH=v3.11.3
        DEBUG=1
        cd petsc
        git checkout ${PETSC_GIT_HASH}
        export PETSC_DIR=$PWD
        expot PETSC_ARCH=petsc-arch


        ./configure PETSC_ARCH=petsc-arch \
        --with-cc=gcc \
        --with-cxx=g++ \
        --with-fc=gfortran \
        --CFLAGS='-g -O0' --CXXFLAGS='-g -O0' --FFLAGS='-g -O0 -Wno-unused-function' \
        --with-clanguage=c \
        --with-debug=$DEBUG  \
        --with-shared-libraries=0 \
        --download-hdf5 \
        --download-metis \
        --download-parmetis \
        --download-fblaslapack \
        --download-mpich=http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz


        make all

   c. Install Tdycore

   d. Install PFLOTRAN   

   e. Move back to the home directory and purge python2.7 and install python3


      .. code-block:: bash

	cd ../../..
	sudo apt-get update
        sudo apt purge python2.7-minimal
        sudo apt-get -y install python3 python3-h5py python3-matplotlib
        sudo apt-get -y install python3-tk python3-scipy

   f. Create file called simulators.sim within qa-toolbox that sets paths to simulators

      .. code-block:: bash

        echo '[simulators]
	tdycore =' $var'/TDycore/demo/steadyblock/steadyblock
	pflotran =' $pwd'/pflotran/src/pflotran/pflotran' >$PWD/qa-toolbox/simulators.sim


   g. Create file called config_files.txt within qa-toolbox that sets paths to simulators

      .. code-block:: bash

	echo '../TDycore-test/2d_block/2d_block.cfg'>$PWD/qa-toolbox/config_files.txt

   h. Run the makefile in tdycore-qa

      .. code-block:: bash

	make all


2. Create a .travis.yml document

   a. Set ubuntu version to Bionic

      .. code-block::

	 dist: Bionic

   b. Set compiler to gcc

      .. code-block::

	 compiler:
	   - gcc

   c. Addon package cmake

      .. code-block::

	 addons:
	   apt:
	     packages:
	       - cmake

   d. Set script to run .sh file in /.travis
