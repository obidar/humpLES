#! /bin/bash
#$ -l rmem=4G
#$ -pe smp 4
#$ -l h_rt=40:00:00
#$ -cwd
#$ -V
singularity exec --bind $PE_HOSTFILE:$PE_HOSTFILE:ro /home/cop20ob/dafoam-main/singularity/DAFoam-fieldinversion-clean.simg /fastdata/cop20ob/humpLES/gaInitRandl1e4/Allrun.sh