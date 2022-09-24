#!/bin/bash
. /home/dafoamuser/dafoam/loadDAFoam.sh
cd /fastdata/cop20ob/humpLES/uniform33
mpirun -np 4 python runScript.py > logOpt.txt & ./autoSyncToGitHub.sh
