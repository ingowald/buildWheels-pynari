#!/bin/bash
alias ll="ls -lisa"
export PATH=/opt/python/cp312-cp312/bin/:$PATH
pip3 install scikit-build wheel twine

yum -y install gcc-toolset-13
source /opt/rh/gcc-toolset-13/enable


chmod +x ./cuda_12.6.3_560.35.05_linux.run
./cuda_12.6.3_560.35.05_linux.run --toolkit --toolkitpath=/usr/local/cuda --silent
export PATH=/usr/local/cuda/bin/:$PATH
#export PATH=/usr/local/cuda-12.6/bin//:$PATH
