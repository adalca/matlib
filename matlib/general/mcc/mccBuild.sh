#!/bin/bash
#
# a shell script to help build some mcc files. The particular setup of this
# file is a frequent usecase for me.
#
# usage: mccBuild.sh mccRunDir mainMfile mccOutputDir path1 path2 ...
# usually, path1 is the project path, path2 and later are toolbox path(s)
# mccBuild \
#   /path/to/bin/mcc \
#   /path/to/coolCode.m \
#   /path/to/MCC/MCC_coolCode \
#   /addpath1 \
#   /addpath2

# settings
execdir=`pwd -P`

# matlab arguments
mccRunDir=$1
mainMFile=$2
mccDir=$3

# prepare mcc directory.
mkdir -p $mccDir
cd $mccDir

# initiate command to run
cmd="${mccRunDir} -C -m ${mainMFile}"

# add extra paths
for i in `seq 4 $#`
do
  cmd="${cmd} -a ${!i}"
done

# print and run command
echo $cmd
$cmd

# in this folder, make this executable and runnable
chmod +x *
chmod +r *

# go back to the executing folder
cd $execdir
