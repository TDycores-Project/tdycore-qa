#!/bin/sh

#clone tdycore-qa repository and qa-toolbox repository
git clone https://github.com/TDycores-Project/tdycore-qa.git
git clone https://github.com/TDycores-Project/qa-toolbox.git
cd qa-toolbox
#git checkout rosie/learning-travis
cd ..

sudo apt-get install -y cmake gcc gfortran g++

#install and make pflotran
#petsc
git clone https://gitlab.com/petsc/petsc petsc

PETSC_GIT_HASH=v3.11.3
DEBUG=1

cd petsc
git checkout ${PETSC_GIT_HASH}

export PETSC_DIR=$PWD
export PETSC_ARCH=petsc-arch
echo "start configuring"
#pyenv global 3.7.1

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
#--CFLAGS='-O3' --CXXFLAGS='-O3' --FFLAGS='-O3' --with-debugging=no --download-mpich=yes --download-hdf5=yes --download-fblaslapack=yes --download-metis=yes --download-parmetis=yes


#export PETSC_DIR=$PWD
#export PETSC_ARCH=arch-osx-dbg ##how know this??

#cd $PETSC_DIR
ls -a
make all

cd ..
git clone https://bitbucket.org/pflotran/pflotran
cd pflotran/src/pflotran
make pflotran

cd ../../..





#instal tdycore
git clone https://github.com/TDycores-Project/TDycore.git
cd TDycore
git checkout glenn/example-block
make
cd demo/steadyblock
make
ls -a

echo "tdycore folder"

cd ../../..

sudo apt-get update
sudo apt purge python2.7-minimal
sudo apt-get -y install python3 python3-h5py python3-matplotlib
sudo apt-get -y install python3-tk python3-scipy
sudo apt-get install sphinxsearch

#clone my tdycore test
git clone https://github.com/leorosie/TDycore-test.git
cd TDycore-test/2d_block
python3 make_dataset.py
cd ../..
#private repository

ls -a
echo "reg folder"



var=$(pwd)
#insert simulator paths into simulators.sim
echo '[simulators]
python = /usr/bin/python3
tdycore =' $var'/TDycore/demo/steadyblock/steadyblock
pflotran =' $var'/pflotran/src/pflotran/pflotran' >$PWD/qa-toolbox/simulators.sim

##map tdycore test within config_files.txt
echo '../TDycore-test/2d_block/2d_block.cfg'>$PWD/qa-toolbox/config_files.txt


cd tdycore-qa
git checkout rosie/learning-travis
ls -a

make all

cd ../tdycore-qa/docs
make clean
make html
ls
