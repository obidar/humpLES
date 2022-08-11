#! /bin/bash
#$ -l rmem=4G
#$ -pe smp 4
#$ -l h_rt=60:00:00
#$ -cwd
#$ -V
singularity exec --bind $PE_HOSTFILE:$PE_HOSTFILE:ro /home/cop20ob/dafoam-main/singularity/DAFoam-fieldinversion-latest.simg /data/cop20ob/humpLES/sparsehl0p035/Allrun.sh