#!/bin/bash
. /home/dafoamuser/dafoam/loadDAFoam.sh
cd /fastdata/cop20ob/humpLES/gaSparse0p05l1em5
mpirun -np 4 python runScript.py > logOpt.txt & ./autoSyncToGitHub.sh
