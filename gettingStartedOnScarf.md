
# New Commands in this lecture

| Command | Key Options | Description |
| ------- | ----------- | ----------- |
| <code>ssh</code>     | <code>-X</code> <code>-Y</code>                          | Access a remote machine |
| <code>exit</code>    |                                                          | Quit the current session |
| <code>scp</code>     |                                                          | Copy from a remote machine |
| <code>module</code>  | <code>avail</code> <code>spider</code>                   | Search for availavble software |
|                      | <code>load</code> <code>unload</code> <code>purge</code> | load or unload software |
| <code>sbatch</code>  |                                                          | Submit a job script to the scheduler |
| <code>squeue</code>  | <code>-u</code>                                          | Print the queue status |
| <code>scancel</code> |                                                          | Cancel a queued/running job |
|                      |                                                          |                        |
| <code>mpirun</code>  | <code>-np</code>                                         | Execute a command in parallel |
|                      |                                                          |                        |
| <code>chmod</code>   | <code>uga</code> <code>rwx<code> <code>+-</code>         | Alter file permissions |
| <code>ln</code>      | <code>-s</code>                                          | Create a link to a file or directory |
| <code>tar</code>     | <code>-c</code> <code>-x</code> <code>-z</code>          | (Un)archive a folder |
| <code>gzip</code>    |                                                          | Compress a file |
| <code>gunzip</code>  |                                                          | Decompress a compressed file |

# The HPC Facility

![Cluster Image](./Figures/clusterStructure/clusterStructure.001.png)

# Getting set up on SCARF

You should apply for access to SCARF [here](https://www.scarf.rl.ac.uk/registration.html).

### Connecting to scarf

| Command | Description |
| ------- | ----------- |
| <code>ssh</code>     | Access a remote machine |
| <code>exit</code>    | Quit the current session |
| <code>chmod</code>   | Alter file permissions |
| <code>ln</code>      | Create a link to a file or directory |

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

We should now be connected to scarf, we can check where we are and the contents of the current folder

    $ pwd
    /home/vol07/scarf1097
    $ ls
    drwxr-xr-x  2 scarf1097 diag 4.0K Jan  7  2022 example_scripts
    lrwxrwxrwx  1 scarf1097 diag   19 Jan  7  2022 nab23632 -> /work4/dls/nab23632
    drwxr-xr-x  4 scarf1097 diag 4.0K Jan  9  2022 ELPA
    -rw-r--r--  1 scarf1097 diag  181 Jan  9  2022 espresso.sh
    drwxr-xr-x 10 scarf1097 diag 4.0K Jan 13  2022 SPACK
    drwxr-xr-x  3 scarf1097 diag 4.0K Mar 18  2022 EXCITING
    drwxr-xr-x  3 scarf1097 diag 4.0K Mar 28  2022 FEFF
    drwxr-xr-x  4 scarf1097 diag 4.0K Apr  5 14:35 tmp
    -rw-r--r--  1 scarf1097 diag   99 Apr  6 11:01 load_espresso.sh
    -rw-r--r--  1 scarf1097 diag 4.7K Apr 13 11:26 CuBTC_activated.cif
    drwxr-xr-x  2 scarf1097 diag 4.0K Apr 21 14:28 bash_example
    drwxr-xr-x  4 scarf1097 diag 4.0K Apr 22 14:33 LIBXC
    drwxr-xr-x  7 scarf1097 diag 4.0K Apr 22 15:10 ESPRESSO
    -rw-r--r--  1 scarf1097 diag 1.3K May  6 11:11 test.pwi
    drwxr-xr-x  4 scarf1097 diag 4.0K Jun 22 11:35 CP2K
    drwxr-xr-x  2 scarf1097 diag 4.0K Aug  8 16:57 scarf_usage

We see on login we arrive at our home folder, which is on the <code>/home</code> partition of the cluster.

To exit the cluster you can type

    $ exit

If you exited, then log back into scarf

    $ ssh fedid@ui1.scarf.rl.ac.uk

Before we get started running some jobs, we need to create a space for our input files, output files and data.
There are three main partitions on SCARF <code>/home</code> which we have seen, <code>/work4</code> and <code>/scratch</code>.

 - The <code>/home</code> directory has limited space and should be used for storing important files, and software.
 - The <code>/scratch</code> directory has much more space and can be used for calculations. However, files not used are removed automatically after 30-days
 - The <code>/work4</code> directory also has a lot of space for storage, as well as a special area reserved for Diamond users

We can go to the DLS directory within the work directory

    $ cd /work4/dls/
    $ ls -ltrh

Each of the current Diamond Light Source users has a directory for their work.

We can now make our own directory

    $ mkdir myfedid
    $ ls -ltrh

By default we can see that the created directory has the permissions for personal (<b>r</b>)ead, (<b>w</b>)rite and e(<b>x</b>)ecute, group read and execute and all read and execute.

    drwxr-xr-x 16 scarf1097 diag 4.0K Sep  6 09:56 myfedid

If we plan to work on private materials, we might want to remove these permissions:

    $ chmod o-rx myfedid

This removes read and execute access to (<b>o</b>)ther user (in different groups), i.e. those outside of Diamond Light Source.

    $ ls
    drwxr-x--- 16 scarf1097 diag 4.0K Sep  6 09:56 myfedid

    $ chmod g-rx myfedid
    $ ls
    drwx------ 16 scarf1097 diag 4.0K Sep  6 09:56 myfedid

The second command shows how to remove access of other (<b>g</b>)roup members, i.e. other people accessing SCARF through their affiliation with Diamond Light Source.

Now that we have a directory to work in, we can create a soft link (shortcut) to our working directory. Lets go to our home directory

    $ cd
    $ ln -s /work4/dls/myfedid .
    $ ls
    lrwxrwxrwx  1 scarf1097 diag   19 Jan  7  2022 myfedid -> /work4/dls/myfedid

    $ cd myfedid

The final thing that we will do at this point is copy the material we will use to practice submitting jobs to the cluster.
This will follow the same principles as in the last lecture

    $ cp -r /work4/dls/shared/introToScarf01 .
    $ ls -ltrh
    drwxr-xr-x 3 scarf1097 diag 4.0K Oct  4 10:00 introToScarf01
    $ cd introToScarf01
    $ ls -ltrh
    -rw-r--r-- 1 scarf1097 diag  29K Oct  3 22:03 C.wfc
    -rw-r--r-- 1 scarf1097 diag 798K Oct  4 09:54 C.pbesol-n-rrkjus_gipaw.UPF
    -rw-r--r-- 1 scarf1097 diag 3.6K Oct  4 09:55 c60_scf.pwi
    -rw-r--r-- 1 scarf1097 diag  305 Oct  4 09:57 job.sh

Inside the folder you will find four text files.
Like last time, the <code>.pwi</code> is an input file for quantum Espresso, we will look at this in more detail next time.
The <code>C.wfc</code> and <code>C.pbesol-n-rrkjus_gipaw.UPF</code> are also read by quantum espresso.
The file <code>job.sh</code> is the script we will use to submit the job to the scheduler for queuing.

# Submitting Batch Jobs

| Command | Description |
| ------- | ----------- |
| <code>sbatch</code> | Submit a job to the queue |
| <code>squeue</code> | Check the status of the queue |
| <code>scancel</code> | Cancel a job that has been submitted |

## What is job submission

Typically , there are a lot more jobs requested of the cluster than there are available resources, consequently the cluster uses a schduler to create a queue.
As a result, every user of the clusterwill get a fair share of the compute time based on the jobs that they have submitted.

Key principles ([from SCARF help page](https://www.scarf.rl.ac.uk/jobs.html#hints-and-tips))

- Do not try to second guess the scheduler! Submit all of your jobs when you want to run them and let it figure it out for you. You will get a fair share, and if you don’t then we need to adjust the scheduler.
- Give the scheduler as much information as possible. There are a number of optional parameters (see later) such as job length, and if you put these in then you have an even better chance of getting your jobs run.
- It is very difficult for one user to monopolise the cluster, even if they submit thousands of jobs. The scheduler will still aim to give everyone else a fair share, so long as there are other jobs waiting to be run.

It is possible to submit a job from the commandline directly using the <code>sbatch</code> command, however it can be in the long term to write a script to (i) keep track of all of the job options (ii) more easily build in complexity to the job.

To submit the job, we do not execute the script, rather we provide the script as an argument to the <code>sbatch</code> command.

    $ sbatch job.sh
    Submitted batch job 714312

To check the status of our job in the queue we can use the command <code>squeue</code>

    $ squeue

From the output of <code>squeue</code> you can get an idea of how over subscribed the resources are.
The output is organised into columns:

    JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    714215     scarf CaCl2_di scarf100 PD       0:00      2 (Priority)
    714269      ibis jobscrip scarf261  R   12:47:05      1 cn244

The <code>JOBID</code> is the unique code assigned to identify the job.
The <code>PARTITION</code> tells us which part of the cluster the job will be run on.
The <code>NAME</code> is a user defined identification for the job.
The <code>USER</code> specifies the user who lauched the JOB.
<code>ST</code> is short for status. Jobs which are running have the status <code>R</code>, jobs which are queued have the status <code>PD</code>.
Once the job is running <code>TIME</code> reports the time elapsed since the start of the job.
Finally <code>NODELIST</code> reports exactly which nodes in the cluster are running the job.

Clearly, there is a lot of information printed when we type the <code>squeue</code> command, it can be more instructive to use the option <code>-u</code>

    $ squeue -u scarf1097
    JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    714313     scarf   job.sh scarf109 PD       0:00      1 (Priority)

This tells me that the job belonging to me is currently queued. 
If I have multiple jobs, all of them would be reported to me.

If there is a mistake in a job, or if I want to change something, at any point while the job is queued or running I can use <code>scancel</code>

    $ scancel 714313

This will delete the job from the queue.

# The Job Script (Line by Line)

    #!/bin/bash
    #SBATCH -p scarf
    #SBATCH -C amd
    #SBATCH --nodes=2 --ntasks-per-node=32 
    #SBATCH -t 560
    #SBATCH -o job_%J.log
    #SBATCH -e job_%J.err
    
    export OMP_NUM_THREADS=1
    module load contrib/dls-spectroscopy/quantum-espresso/6.5-intel-18.0.3

    mpirun -np ${SLURM_NTASKS} pw.x -inp 'diamond.pwi' > 'diamond.pwo'

We have already seen the first line of the job file in the previous lecture.

    #!/bin/bash


This is the [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) and tells the computer how to exectue the script.
In this case we are asking for <code>/bin/bash</code>

In the next few lines we will see the commands that provide instructions to the SLURM job scheduler. These lines all start with the command <code>#SBATCH</code>

    #SBATCH -p scarf

The <code>-p</code> option instructs the scheduler on the queue/partitiono we should submit to. 
There is a [list of available partitions](https://www.scarf.rl.ac.uk/jobs.html#choosing-a-sub-section-of-the-cluster) on the SCARF help pages. 
For our work at Diamond we will mostly be performing small tests in the the <code>devel</code> partition and running calculations in the <code>scarf</code> partition. 

    #SBATCH -C amd

SCARF is a heterogenous cluster, which means that it is built from many different types of compute nodes.
The <code>-C</code> option allows us to pick which type of node we run our simulations on.
This can be helpful in trying to configure our job size, for example in the above example we have requested to use the [SCARFs AMD nodes](https://www.scarf.rl.ac.uk/user-guides/amd.html#running-jobs-on-amd-nodes).
The AMD nodes come with 32-core-per-node, so we know that we must configure our job to run in mutiples of 32 processes. 

    #SBATCH --nodes=2 --ntasks-per-node=32 

Here we are requesting resources. 
The option <code>--nodes</code> specifies how many nodes we would like.
The option <code>--ntasks-per-node</code> specifies how many tasks/processes we would like on each node.
In the example, we are asking for 2 AMD nodes, and 32 tasks/processes for each node.
This means in total our job will split work across 64 cores, and each core will have an associated task.

    #SBATCH -t 560

The <code>-t</code> is the total amount of time we are requesting for the job.
We should set this time making sure that our calculation will finish and adhering to the maximum queue lengths (<code>devel</code> = 12 Hours; <code>scarf</code>7 days).  
The job total time can be set with different formats, generally is easiest to stick to one. 
Acceptable time formats include  "minutes",  "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
In this example <code>560</code> minutes are requested, which is equivalently:

    #SBATCH -t 560
    #SBATCH -t 560:00
    #SBATCH -t 9:20:00
    #SBATCH -t 0-9:20
    #SBATCH -t 0-9:20:00

The next two lines specify the names of two files created to handle text output from the job.
This is not necessarily output from the code we use to perform the simulation.

    #SBATCH -o job_%J.log
    #SBATCH -e job_%J.err

The <code>-o</code> option denotes the name given to the file created for standard output.
The <code>-e</code> option denotes the name given to the file created for any error messages.
The <code>%J</code> is an environment variable that stores the job indentification number. 
Using this option helps to match these output files to a specific job.

There are several further options that can be added to this section of the job submission script.
These are all options associated with the <code>sbatch</code> command, you can look them up using the manual: <code>man sbatch</code>
    
The last part of this input file deals with the actual execution of the software we would like to run. 

First we use the export command to set the number of threads for each task. 
Threading is another way of performing parallel calculations, for now we will not worry about threading.

    export OMP_NUM_THREADS=1

Setting <code>OMP_NUM_THREADS=1</code> will lead to the job only having parallel tasks

    module load contrib/dls-spectroscopy/quantum-espresso/6.5-intel-18.0.3

We have seen the <code>module load</code> command, if we include this in the job script we will make sure that we keep a record of the version of the software we used to perform the calculation.
    
    mpirun -np ${SLURM_NTASKS} pw.x -inp 'diamond.pwi' > 'diamond.pwo'

Finally the <code>mpirun</code> command is used to execute the parallel job.
Here <code>pw.x</code> is the part of the Quantum Espresso software suite that performs the DFT calculation. 
It also has the associated option <code>-inp</code> which specifies where to read input from.
Moreover, we use a <code>></code> to redirect the output into a new file <code>'diamond.pwo'</code>
The variable <code>${SLURM_NTASKS}</code> is an environment variable that automatically contains the correct number of tasks we want to run with.

# Sending and Receiving Data from the Cluster

| Command | Description |
| ------- | ----------- |
| <code>scp</code>     | Copy from a remote machine |
| <code>tar</code>     | (Un)archive a folder |
| <code>gzip</code>    | Compress a file |
| <code>gunzip</code>  | Decompress a compressed file |

Copying files to and from the cluster is very similar to the <code>cp</code> we saw in the last lecture.
Instead of <code>cp</code> we must use a secure copy

Lets disconnect from SCARF and copy the job file to our local machine

    $ exit
    $ scp myfedid@ui1.scarf.rl.ac.uk:/work4/dls/shared/introToScarf01/job.sh .
    myfedid@ui1.scarf.rl.ac.uks password: 
    job.sh                                      100%  305    31.1KB/s   00:00
    $ ls -ltrh
    -rw-r--r--.  1 nab23632 nab23632  305 Oct  4 10:51 job.sh

Notice the syntax for the <code>scp</code> command, we must provide the address of the cluster followed by <code>:</code> and then the path to the file we would like to copy.
Finally I use a <code>.</code> to put the file in the current working directory.

Copying in the opposite direction is the same:

    $ scp ./job.sh myfedid@ui1.scarf.rl.ac.uk:

Here since I didnt specify a path, the job.sh will be copied to my home directory on SCARF.

Moving folders between systems is slightly different, first we must create a 'tarball', this is an archived (and possibly compressed) version of the folder that one prepared can be sent between systems.

    $ ssh myfedid@ui1.scarf.rl.ac.uk
    $ cd /work4/dls/myfedid/
    $ tar -cvf introToScarf01.tar ./introToScarf01
    $ ls -ltrh
    -rw-r--r-- 1 scarf1097 diag  14M Oct  4 11:00 introToScarf01.tar
    $ gzip introToScarf01.tar
    $ ls -ltrh
    -rw-r--r-- 1 scarf1097 diag  12M Oct  4 11:00 introToScarf01.tar.gz

Here we have first created the archive with the command <code>tar</code>. 
We first provided the name of the <code>.tar</code> file that we wanted to create, then the folder that we wanted to build the archive from.
Next we used the <code>gzip</code> command to zip (compress) the archive we had created.
By compressing the file we make it smaller and therefore it is faster to transfer it between networks.

Now we can log out of scarf and secure copy the archive we just created

    $ exit
    $ scp myfedid@ui1.scarf.rl.ac.uk:/work4/dls/myfedid/introToScarf01.tar.gz .
    $ ls -ltrh
    -rw-r--r--.  1 nab23632 nab23632  12M Oct  4 11:05 introToScarf01.tar.gz

Finally, we can use the <code>tar</code> command to simultaneously decompress and unarchive the tarball we created.

    $ tar -zxvf introToScarf01.tar.gz
    $ ls -ltrh
    drwxr-xr-x.  3 nab23632 nab23632 4.0K Oct  4 10:59 introToScarf01
    -rw-r--r--.  1 nab23632 nab23632  12M Oct  4 11:05 introToScarf01.tar.gz

Another way to do this in two steps would have been

    $ gunzip introToScarf01.tar.gz
    $ ls -ltrh
    -rw-r--r--.  1 nab23632 nab23632  12M Oct  4 11:05 introToScarf01.tar 
    $ tar -zxvf introToScarf01.tar


