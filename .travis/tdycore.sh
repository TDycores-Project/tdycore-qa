#!/bin/sh

#clone tdycore-qa repository and qa-toolbox repository
#git clone https://github.com/TDycores-Project/tdycore-qa.git
git clone https://github.com/TDycores-Project/qa-toolbox.git

#install and make pflotran
#petsc
git clone https://gitlab.com/petsc/petsc petsc
cd petsc
git checkout v3.11.3
./configure --CFLAGS='-O3' --CXXFLAGS='-O3' --FFLAGS='-O3' --with-debugging=no --download-mpich=yes --download-hdf5=yes --download-fblaslapack=yes --download-metis=yes --download-parmetis=yes

export PETSC_DIR=$PWD
export PETSC_ARCH=arch-osx-dbg ##how know this??

cd $PETSC_DIR
make all

cd ..
git clone https://bitbucket.org/pflotran/pflotran
cd pflotran/src/pflotran
make pflotran

cd ../../..

#instal tdycore
git clone https://github.com/TDycores-Project/TDycore.git


#insert simulator paths into simulators.sim
echo 'tdycore = $PWD/TDycore
pflotran = $PWD/pflotran/src/pflotran/pflotran' >$PWD/qa-toolbox/simulators.sim

##map tdycore test within config_files.txt
echo '../TDycore/steady/ateady.cfg'>$PWD/qa-toolbox/config_files.txt

cd tdycore-qa
make all
