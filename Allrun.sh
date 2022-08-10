#!/bin/bash
decomposePar
mpirun -np 4 simpleFoam -parallel 2>&1 | tee simplefoam.log
