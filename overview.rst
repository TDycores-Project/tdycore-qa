Overview of QA ToolBox
======================

The qa-toolbox compares outputs from two or more simulators and can calculate error metrics and creates documentation for each test. Each test consists of an input deck for each simulator, a configuration file which lists the input decks to be ran, and an options file.

Tests can be run to produce a time slice (comparing all locations at one time) and/or an observation point (comparing one location at all times).

The documentation produced consists of a table of the absolute and relative error between the simulations and figures comparing the results and error metrics.

Running and Documenting Tests
-----------------------------

1. Clone the qa-toolbox from Github. This is the repository with the python code used to run the tests.

   .. code-block:: bash

     $ git clone  https://github.com/TDycores-Project/qa-toolbox.git

2. Clone The Tdycore-qa-tests repository from Github. This repository contains input decks, the configuration file, and options file which will be used by the qa-toolbox.

   .. code-block:: bash

     $ git clone https://github.com/TDycores-Project/tdycore-qa-tests.git

3. Clone the Tdycore-qa repository from Github. This repository runs the verification and validation tests for TDycore. The documentation will be stored in this repository.

   .. code-block:: bash

     $ git clone https://github.com/TDycores-Project/tdycore-qa.git
   
4. Set up problem description in the tdycore-qa-tests repository. This provides a general overview on the problem being tested and will be displayed in the documentation.

5. Run the test suite via the makefile from the tdycore-qa repository.

   .. code-block:: bash

     $ cd tdycore-qa
     $ make

6. Generate html files for documentation which will be stored in the tdycore-qa repository.

   .. code-block:: bash

     $ cd docs
     $ make clean
     $ make html
