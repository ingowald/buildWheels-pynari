#!/bin/bash
alias ll="ls -lisa"

yum -y install gcc-toolset-13
source /opt/rh/gcc-toolset-13/enable

echo "== installing cuda toolkit"
chmod +x ./cuda_12.6.3_560.35.05_linux.run
./cuda_12.6.3_560.35.05_linux.run --toolkit --toolkitpath=/usr/local/cuda --silent
export PATH=/usr/local/cuda/bin/:$PATH
#export PATH=/usr/local/cuda-12.6/bin//:$PATH

export OLD_PATH=$PATH
cd /io
rm -f dist/*whl wheelhouse/*whl
for f in cp38 cp39 cp310 cp311 cp312 cp313 ; do
    echo "== building wheel for $f"
    export PATH=/opt/python/$f-$f/bin/:$OLD_PATH
    #export PATH=/opt/python/cp312-cp312/bin/:$OLD_PATH
    pip3 install scikit-build wheel twine
    python3 setup.py bdist_wheel
done

for f in `ls dist/*whl`; do
    auditwheel repair $f
done
python3 -m twine upload -r pypi wheelhouse/*



