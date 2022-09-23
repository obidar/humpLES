#!/bin/bash
. /home/dafoamuser/dafoam/loadDAFoam.sh
cd /data/cop20ob/humpLES/uniform48
mpirun -np 4 python runScript.py > logOpt.txt & ./autoSyncToGitHub.sh
