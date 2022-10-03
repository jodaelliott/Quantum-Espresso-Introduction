
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


