#Dockerfile
FROM ubuntu:latest
RUN apt-get update -q

RUN apt-get install -y ssh
RUN apt-get install -y python3
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y cmake gcc gfortran g++
RUN apt-get install -y libxml2-dev
RUN apt-get install python3-sphinx

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-numpy python3-scipy python3-matplotlib python3-h5py

RUN mkdir /app
WORKDIR /app
Add . /app
