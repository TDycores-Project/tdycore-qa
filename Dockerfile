#Dockerfile
FROM ubuntu:latest
RUN apt-get update -q

RUN apt-get install -y ssh
RUN apt-get install -y python3
RUN apt-get install -y python-pip
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y cmake gcc gfortran g++
RUN pip install -U sphinx
RUN apt-get install -y libxml2-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-numpy python-scipy python-matplotlib python-h5py

RUN mkdir /app
WORKDIR /app
Add . /app
