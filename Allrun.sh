#!/bin/bash
. /home/dafoamuser/dafoam/loadDAFoam.sh
cd /data/cop20ob/humpLES/fullUxLES
mpirun -np 4 python runScript.py > logOpt.txt & ./autoSyncToGitHub.sh