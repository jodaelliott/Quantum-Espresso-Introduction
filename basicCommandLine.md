# How to interact with your computer using the commandline

![Overview of part 1](./Figures/mapBasicCommandLine/mapBasicCommandLine.001.png?raw=true)

## What is the Terminal?

## What should I use the terminal?

## How should I access the terminal then?

## How to exectute commands

### Status

Now that the terminal is open, we can start to type some commands. The easiest to get
started with are those those that report back something about the current status.

As an example lets try typing <code>pwd</code> after the $ symbol:

    $ pwd

The result should be something like this:

    $pwd
    /home/nab23632

<em>Can some one say what this command has done?</em>

Another command we can try is <code>ls</code>. Type <code>ls</code> after the $

    ls

The result should be something like this:

    [nab23632@ws476 ~]$ ls
    3.dot.pdf  Downloads	    git_pat	      logfile	  NiFeCNNa1_exp_dft.pdf  perl5		 Public     texmf   workspace
    Desktop    espresso.tar.gz  hematene_001.pwi  Music	  NiFeCNNa2_exp_dft.pdf  Pictures	 stuff	    tmp     Zotero
    Documents  FEFF		    july.png	      mylocal_db  notebook		 privatemodules  Templates  Videos

The command has returned a list of files and folders, specifically, the files and folders which are in the current directory (or folder).
We should all still be in the home directory and so we see the Documents, Downloads, Desktop directories.

### Make

Now we can get started on learning to operate using the command line, 
the way we will do this is by making new files and folders and moving around the file structure.

For this we will need some new commands:

| Command | Description |
| --------|-------------|
| mkdir   | Make a new directory |
| cp      | Copy a file or folder from one location to another |
| touch   | Create a new black file |
| cd      | Change the directory |

Lets make a new directory for todays tutorial:

    $ mkdir CommandLineTutorial
    $ ls

The <code>mkdir</code> command will make a new directory within the current one, it will be called <code>CommandLineTutorial</code>.
It is worth noting that you can give many arguments to the <code>mkdir</code> command, it will create a new directory for each one.
It is also worth noting that the directory name has no whitespaces, by default whitespace is interpretted as introducing a new argument.
The <code>ls>/code> should help you confirm that the new directory has been created.

    # This is wrong!
    $ mkdir Command Line Tutorial
    $ ls
    Command  Line  Tutorial

We can now enter the new directory

    $ cd CommandLineTutorial
    $ pwd
    /home/nab23632/CommandLineTutorial
    $ ls
      

### Destroy

rm
rmdir

### Search

grep
sed
awk
paste

## Advanced Options and keyboard shortcuts

man command
command --help
<code>ls -ltrh</code>
<code>grep -e</code>

## Scripts

sh script
make executable
