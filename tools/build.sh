#!/bin/sh

git clone https://github.com/TDycores-Project/qa-toolbox.git

#install and make pflotran
#petsc
git clone https://gitlab.com/petsc/petsc petsc

PETSC_GIT_HASH=v3.11.3
DEBUG=1

cd petsc
git checkout ${PETSC_GIT_HASH}

export PETSC_DIR=$PWD
echo "start configuring"
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


echo "end configuring"

make all

cd ..
git clone https://bitbucket.org/pflotran/pflotran
cd pflotran/src/pflotran
make -j4 pflotran

cd ../../..

#instal tdycore
git clone https://github.com/TDycores-Project/TDycore.git
cd TDycore
git checkout rosie/test-prefix-error
make
cd demo/steadyblock
make


cd ../../..

#sudo apt-get update
#sudo apt purge python2.7-minimal
#sudo apt-get -y install python3 python3-h5py python3-matplotlib
#sudo apt-get -y install python3-tk python3-scipy
#sudo apt-get install python3-sphinx

#install repository
git clone https://github.com/leorosie/TDycore-test.git
cd TDycore-test/2d_block/
python3 make_dataset.py
cd ../..

var=$(pwd)
#insert simulator paths into simulators.sim
echo '[simulators]
python = /usr/bin/python3
tdycore =' $var'/TDycore/demo/steadyblock/steadyblock
pflotran =' $var'/pflotran/src/pflotran/pflotran' >$PWD/qa-toolbox/simulators.sim

##map tdycore test within config_files.txt
echo '../TDycore-test/2d_block/2d_block.cfg'>$PWD/qa-toolbox/config_files.txt

make all

cd docs
make clean
make html

cd _build/html
tar -czvf /tmp/tdycore.tar.gz *
