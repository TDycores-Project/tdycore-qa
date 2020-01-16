QA Repository Setup
===================

Running in Cloud
----------------

To run the qa-repository in the cloud set up travis-ci with the repository and create a.travis.yml file and .sh file in .travis to the necessary simulators and run the qa-toolbox.

1. Write .sh script for travis to run

   a. Clone qa-toolbox
      
   b. Install simulators

   c. Clone qa-test directory you created previously with the configuration file, options file, and input decks

   d. Move back to the home directory and purge python2.7 and install python3

      .. code-block:: bash

	cd ../../..
	sudo apt-get update
        sudo apt purge python2.7-minimal
        sudo apt-get -y install python3 python3-h5py python3-matplotlib
        sudo apt-get -y install python3-tk python3-scipy

   e. Create file called simulators.sim within qa-toolbox that sets paths to simulator executables, for example

      .. code-block:: bash

        echo '[simulators]
	python = python3
	pflotran =' $pwd'/pflotran/src/pflotran/pflotran' >$PWD/qa-toolbox/simulators.sim


   h. Create file called config_files.txt within qa-toolbox that sets paths to the configuration file you wish to run

      .. code-block:: bash

	echo '../qa-test/test.cfg'>$PWD/qa-toolbox/config_files.txt

   i. Run the makefile created earlier in tdycore-qa

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
