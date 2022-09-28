#!/bin/bash
. /home/dafoamuser/dafoam/loadDAFoam.sh
cd /fastdata/cop20ob/humpLES/0p05Uniform
mpirun -np 4 python runScript.py > logOpt.txt & ./autoSyncToGitHub.sh
