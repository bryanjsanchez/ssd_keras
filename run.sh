#!/usr/bin/env bash

# This script sets up a conda environment to run TensorFlow on the GZK nodes.

# Created by Sam Gelman (sgelman2@wisc.edu) with help from Jay Wang (zwang688@wisc.edu) and Shengchao Liu (shengchao.liu@wisc.edu)

# echo some HTCondor job information
echo _CONDOR_JOB_IWD $_CONDOR_JOB_IWD
echo Cluster $cluster
echo Process $process
echo RunningOn $runningon

# this makes it easier to set up the environments, since the PWD we are running in is not $HOME
export HOME=$PWD

# set up miniconda and add it to path
bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3 > /dev/null
export PATH=$PATH:~/miniconda3/bin
export PATH=$PATH:/usr/local/cuda-9.2/bin
export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64:$LD_LIBRARY_PATH
# set up a conda environment
conda create --yes --name my-conda-environment python=3.5
source activate my-conda-environment

# install cudatoolkit and cudnn
conda install -c anaconda cudatoolkit==9.2 --yes
conda install -c anaconda cudnn>=7.0.5 --yes

# install tensorflow and other libraries for machine learning
pip install tensorflow-gpu==1.8
pip install numpy scipy scikit-learn pandas matplotlib seaborn
pip install keras==2.2.0
pip install scikit-image
pip install mrcnn
pip install h5py
pip install imgaug
pip install scipy
pip install Pillow
pip install cython
pip install opencv-python
pip install imgaug
pip install IPython
conda install opencv
pip install tqdm
# hello-chtc.sub

# set up custom libc environment (see http://goo.gl/6iVTDZ)
mkdir my_libc_env
tar -xzf libc.tar.gz -C my_libc_env
cd my_libc_env
ar p libc6_2.17-0ubuntu5_amd64.deb data.tar.gz | tar zx
ar p libc6-dev_2.17-0ubuntu5_amd64.deb data.tar.gz | tar zx
rpm2cpio libstdc++6-4.8.2-3.2.mga4.x86_64.rpm | cpio -idmv
cd ~
unzip SingleType111Loops.zip
unzip models.zip
unzip keras_layers.zip
unzip data_generator.zip
unzip ssd_encoder_decoder.zip
unzip bounding_box_utils.zip
unzip keras_loss_function.zip
# this command is required to run python + tensorflow with our custom libc environment
# https://stackoverflow.com/questions/8657908/deploying-yesod-to-heroku-cant-build-statically/8658468#8658468
export CUDA_VISIBLE_DEVICES=''
$HOME/my_libc_env/lib/x86_64-linux-gnu/ld-2.17.so --library-path $LD_LIBRARY_PATH:$HOME/my_libc_env/lib/x86_64-linux-gnu/:$HOME/my_libc_env/usr/lib64/ `which python` train.py
