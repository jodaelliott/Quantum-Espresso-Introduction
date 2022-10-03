
# New Commands in this lecture

| Command | Key Options | Description |
| ------- | ----------- | ----------- |
| <code>ssh</code>    | <code>-X</code> <code>-Y</code>                          | Access a remote machine |
| <code>scp</code>    |                                                          | Copy from a remote machine |
| <code>module</code> | <code>avail</code> <code>spider</code>                   | Search for availavble software |
|                     | <code>load</code> <code>unload</code> <code>purge</code> | load or unload software |
| sbatch              |                                                          | Submit a job script to the scheduler |
| squeue              | <code>-u</code>                                          | Print the queue status |
| scancel             |                                                          | Cancel a queued/running job |


# Getting set up on SCARF

You should apply for access to SCARF [here](https://www.scarf.rl.ac.uk/registration.html).

### Connecting to scarf

Open up a terminal window and use the new command <code>ssh</code> to initiate the connection

    $ ssh fedid@ui1.scarf.rl.ac.uk
    fedid@ui1.scarf.rl.ac.uks password:

Enter your password (note that the cursor does not move as you type) and you should be logged in.
If this is the first time you have logged into scarf, you may also be asked something like:

    The authenticity of host 'ui1.scarf.rl.ac.uk (130.246.142.130)' cant be established.
    ECDSA key fingerprint is 
    ECDSA key fingerprint is 
    Are you sure you want to continue connecting (yes/no)?

You can type <code>yes</code> to add scarf to your list of known_hosts which are stored at <code>~/.ssh/known_hosts</code>

# The Job Script (Line by Line)

We have already seen the first line of the job file in the previous lecture.

    #!/bin/bash

This is the [shebang] (https://en.wikipedia.org/wiki/Shebang_(Unix)) and tells the computer how to exectue the script.
In this case we are asking for <code>/bin/bash</code>

In the next few lines we will see the commands that provide instructions to the SLURM job scheduler. These lines all start with the command <code>#SBATCH</code>

    #SBATCH -p scarf

The <code>-p</code> option instructs the scheduler on the queue/partitiono we should submit to. There is a [list of available partitions] (https://www.scarf.rl.ac.uk/jobs.html#choosing-a-sub-section-of-the-cluster) on the SCARF help pages. For Diamond we will mostly be performing small tests in the the <code>devel</code> partition and running calculations in the <code>scarf</code> partition. 

    #SBATCH -C amd

    #SBATCH --nodes=2 --ntasks-per-node=32 

    #SBATCH -t 560

    #SBATCH -o qe_job_%J.log

    #SBATCH -e qe_job_%J.err
    
    espressodir=/home/vol07/scarf1097/ESPRESSO/q-e-7.0/q-e_intel_19.0_opt/bin/
    
    pw=$espressodir'pw.x'

    pp=$espressodir'pp.x'

    xs=$espressodir'xspectra.x'
    
    export OMP_NUM_THREADS=1
    
    #input=c60_scf-star1s

    input=xspec
    
    echo ${SLURM_NTASKS}
    
    export KMP_AFFINITY=compact

    export I_MPI_PIN_DOMAIN=auto
    
    mpirun -np ${SLURM_NTASKS} $xs -inp $input'.pwi' > $input'.pwo'

