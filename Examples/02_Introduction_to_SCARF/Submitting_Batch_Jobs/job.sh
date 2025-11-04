#!/bin/bash
#SBATCH -p scarf
#SBATCH --nodes 1 --ntasks=16 --ntasks-per-node=16 --cpus-per-task=2
#SBATCH -t 10:00
#SBATCH -o job_%J.log
#SBATCH -e job_%J.err

export OMP_NUM_THREADS=1
module load contrib/dls-spectroscopy/quantum-espresso/7.4.1-GCC-14.2.0

srun pw.x -inp c60_scf.pwi > c60_scf.pwo
