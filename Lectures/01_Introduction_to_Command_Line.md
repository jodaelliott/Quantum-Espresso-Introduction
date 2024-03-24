# How to interact with your computer using the commandline

![Overview of part 1](./Figures/mapBasicCommandLine/mapBasicCommandLine.001.png?raw=true)

## What is the Terminal?

 - A way to interface with a computer using the command line
 - A place to execute text based commands

## Why should we use the terminal?

 - Much faster than graphical applications
 - Many more functions
 - Standard remote high performance compute facilties

## How can I access the terminal?

 - No machine session
 - Activities
 - Search terminal

## How to exectute commands

 - Just type them

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
| mv      | Move a file or directory from one plance to another |
| touch   | Create a new blank file |
| cd      | Change the directory |

Lets make a new directory for todays tutorial:

    $ mkdir CommandLineTutorial
    $ ls

The <code>mkdir</code> command will make a new directory within the current one, it will be called <code>CommandLineTutorial</code>.
It is worth noting that you can give many arguments to the <code>mkdir</code> command, it will create a new directory for each one.
It is also worth noting that the directory name has no whitespaces, by default whitespace is interpretted as introducing a new argument.
The <code>ls</code> should help you confirm that the new directory has been created.

    # This is wrong!
    $ mkdir Command Line Tutorial
    $ ls
    Command  Line  Tutorial

We can now enter the new directory

    $ cd CommandLineTutorial
    $ pwd
    /home/nab23632/CommandLineTutorial
    $ ls
      
You should see from the <code>pwd</code> command that our location has changed from the home directory. There are several different ways we can use the <code>cd</code> command, including a lot of ways to do the same thing.
Lets take a few minutes to get familiar with them.

| Command | Desctiption |
| ------- | ----------- |
| <code>cd</code> | Go to home directory |
| <code>cd ~</code> | Go to home directory |
| <code>cd $HOME</code> | Go to home directory |
| <code>cd CommandLineTutorial</code> | Go to the directory CommandLineTutorial (which is in the current directory) |
| <code>cd ./CommandLineTutorial</code> | Go to the directory CommandLineTutorial (which is in the current directory) |
| <code>cd /home/nab23632/CommandLineTutorial</code> | Go to the directory CommandLineTutorial (which is in /home/nab23632/) |
| <code>cd .</code> | Go to current directory |
| <code>cd ..</code> | Go up one directory |
| <code>cd ../../</code> | Go up two directories |
| <code>cd -</code> | Go to last directory |

Now we can make our way back to the CommandLineTutorial directory (from where ever we are)

    $ cd /home/nab23632/CommandLineTutorial
    $ ls

Currently there are no files/folders inside this directory. Lets make a text file called firstFile.txt

    $ touch firstFile.txt
    $ ls

As stated in the table above, the <code>touch</code> command will create a new file object (or objects) in the current directory.

Now, we can create a copy of the firstFile.txt using the <code>cp</code> command

    $ cp ./firstFile.txt ./firstFileCopy.txt
    $ ls

The first argument of the <code>cp</code> command is the source and the second argument is the destination, both are mandatory.
We can use the <code>mv</code> command to move the file from one location to another

    $ mv firstFile.txt secondFile.txt
    $ ls

Lets use the <code>cp</code> command to get a folder we can use to perform some commands on.

    $ cp -r /home/myfedid/Quantum-Espresso-Introduction/Examples/01_Introduction_to_Command_Line .
    $ ls 
    $ ls ./01_Introduction_to_Command_Line

The option <code>-r</code> stands for recursive copy and works for copying entire directories in one go.
The files <code>relax.pwi</code> and <code>relax.pwo</code> are examples of a Quantum ESPRESSO input and output file, they are simple
ASCII text files.

### Destroy

Before we move on, lets take a quick look at how to delete things with the command line. Remove the two blank text documents from before

    $ rm ./*txt
    $ ls

The <code>*</code> is a wildcard; any files with text matching the pattern 'txt' at the
end of the word have been removed.

Lets try to remove the directory in the same way

    $ rm ./materialLecture1
    rm: cannot remove ‘materialLecture1/’: Is a directory

We cannot simply remove a directory as easily as a file, instead we can use one of the two commands <code>rm -r</code> or <code>rmdir</code>.
(If you do this, dont forget to copy the directory again, we will need it!)

### Search

We are going to see alot more of the following commands in the next section, when we dive into analysing files, but we can introduce the commands that help us search for content now

| Command | Description |
| ------- | ----------- |
| <code>grep</code> | Match a keyword in a file and print all lines containing that keyword |
| <code>sed</code> | A find and replace function for files |
| <code>awk</code> | A scripting language we can use to manipulate output |
| <code>cat</code> | Print a file to the terminal |
| <code>paste</code> | A way to print text files side-by-side |

The contents of a file can be displayed with the <code>cat</code> commamnd. Lets look at the story of Little Red Riding Hood

    $ cd materialLecture1
    $ cat littleRedRidingHood.txt

The text is printed directly to the terminal, we will see how to control this better soon.

We might be interested to see all the times the word 'Red' is used in the story, for this we can use the <code>grep</code> command

    $ grep Red littleRedRidingHood.txt
    $ grep 'Little Red Riding Hood' littleRedRidingHood.txt

Grep searches for and highlights all the times a keyword or phrase is used. To search a phrase, we must use speech marks

Using the <code>sed</code> command we can find and replace a matching string, more over we can use a pipe to catch the substituted text

    $ sed s/Red/Blue/g littleRedRidingHood.txt
    $ sed s/Red/Blue/g littleRedRidingHood.txt > littleBlueRidingHood.txt
    $ ls
    $ grep Red littleBlueRidingHood.txt

## Advanced Options and keyboard shortcuts

A lot of the commands we have already seen have a set of options that alter the way that they perform. For most cases, you can view all of the
possible options for a command by looking at its manual. We have already seen the <code>-r</code> option for <code>cp</code> and <code>rm</code>.

    $ man ls

A good way to list the files in the directory is using the compound options

    $ ls -ltrh

Look again at the manual to see what each of these options is doing. You can change them one-by-one to visualize their effect.

Up to now we have been typing everything in full, each time we wanted to execute a command. There are some keyboard short-cuts that offer us some serious time saves

| Shortcut | Function |
| -------- | -------- |
| tab      | Autocompletes text |
| Up/Down Arrow keys | Cycle through previous commands |
| Ctrl + a | Go to the beginning of the line |
| Ctrl + e | Go to the end of the line |
| Ctrl + k | Delete to the end of the line |
| Ctrl + r | Search through command history |
| Ctrl + c | Kill current command |

## Scripts

In the final part of this section, we will look at what it means to create a script.
A script is like a recipe, in that it is a collection of commands that are executed in sequence to perform a task

An example script has been prepared for you to look at and use

    $ cat example_script.sh
    #!/bin/bash
    
    mkdir script_folder
    cd script_folder
    ls
    
    sed s/Red/Blue/g ../littleRedRidingHood.txt > ./littleBlueRidingHood.txt
    
    ls -ltrh
    grep -e Red -e Blue ./littleBlueRidingHood.txt
    
    cd ..

You should be able to recognise all of the commands in the script, and predict what it will do. The first line is called a shebang, if it were executable, this would tell the computer how to run the commands. You can use <code>man grep</code> to see how the <code>-e</code> options works.

We can run this script like

    $ sh ./example_script.sh

To run the script as an executeable file you have to change its mode

    $chmod +x example_script.sh
    ./example_script.sh

