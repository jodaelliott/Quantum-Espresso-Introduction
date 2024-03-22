
# Atomic Simulation Environment

Atomic simulation environment (ASE) is a collection of Python modules that can be used to set up, manipulate, simulate and visualise simulations of atoms.
It is paired with many different codes for solid state DFT, Molecular Dynamics and Quantum Chemistry.

All details about ASE can be found at the main [website](https://wiki.fysik.dtu.dk/ase/)

Here we will look at the [Graphical User Interface](https://wiki.fysik.dtu.dk/ase/ase/gui/gui.html) for helping understand if we have input our strucutral information into the quantum espresso input file correctly.

To access atomic simulation environment, from a no machine session, first load the appropriate python module:

    $ module load python/3.9

Now we should be able to access the gui by typing:

    $ ase gui

The interface is very crude, and each of the options in the menu do pretty much exactly what they say. Lets load up the Silicon example we prepared already...

    scp myfedid@ui1.scarf.rl.ac.uk:/work4/dls/myfedid/example_silicon/silicon.pwi .

    ase gui

To open the Quantum Espresso input file we should navigate to the <code>File</code> menu and select <code>Open</code>. 
This will bring up a new window where we can see the contents of the current folder. 
Highlight <code>silicon.pwi</code> and from the <code>Choose parser</code> drop down menu select <code>Quantum espresso in</code>

## Some useful things to try:

| Menu | Option | Description |
|------|--------|-------------|
| Window | <code>=</code> | Reset view |
|        | <code>left mouse</code> | Highlight atoms, get bind distance, angles, formula |
|        | <code>right mouse</code> | Rotate structure |
| <code>View</code> | <code>Repeat</code> | Repeat in x, y and z directions |
|                   | <code>Rotate</code> | Rotate around x, y and z axis (also possible to freely rotate with right mouse button)|
|                   | <code>Show Bonds</code> | Shows <em>bonds</em> within a certain cutoff | 
|<code>Edit</code>  | <code>Edit Cell</code>  | Displays and allows manipulation of the simulation cell (box) |

# In the python environment

Another useful thing we can do with ASE is setup a quantum espresso input file directly from a structure file (such as a <code>.cif</code>)

To do this we must either prepare a python script, or use an interactive python shell.

    $ python

A list of all of the different modules available with ASE can be found within the [documentation](https://wiki.fysik.dtu.dk/ase/ase/ase.html)

To convert between one format and another we will need access to he (I)nput/(O)uput [IO modules](https://wiki.fysik.dtu.dk/ase/ase/io/io.html). 
ASE comes with a function for reading and a function for writing files.
So we can directly import those modules ready for us to use.

    >>> from ase.io import read, write

Next we can directly read the structure from the <code>.cif</code> file using the read function.
In its most basic use, the read function takes as argument the filename, then we can also specify the format of the file with the <code>format</code> argument.
You will notice, this is analogous to the way that we opened the Quantum Espresso file with the <code>ase gui</code>

    >>> a = read('silicon.cif', format='cif')

Now we can use the <code>write</code> function to immediately write a new file, which contains the structure in Quantum Espresso format.
The <code>write</code> function takes as argument (in this order) the name of the file we will write, the structure (which is currently stored in <code>a</code> and the output format of the file written:

    >>> b = write('silicon_new.pwi', a, format='espresso-in')

Open a new terminal and cat the new file <code>silicon_new.pwi</code>

    $ cat silicon_new.pwi 
    &CONTROL
    /
    &SYSTEM
       ntyp             = 1
       nat              = 2
       ibrav            = 0
    /
    &ELECTRONS
    /
    &IONS
    /
    &CELL
    /
    
    ATOMIC_SPECIES
    Si 28.085 None
    
    K_POINTS gamma
    
    CELL_PARAMETERS angstrom
    3.89152000000000 0.00000000000000 0.00000000000000
    1.94576000000000 3.37015517933522 0.00000000000000
    1.94576000000000 1.12338505977841 3.17741277461186
    
    ATOMIC_POSITIONS angstrom
    Si 0.0000000000 0.0000000000 0.0000000000 
    Si 5.8372800000 3.3701551793 2.3830595810 

By default, the structure is printed using Angstrom, and with the three cell vectors.

We can also include some of the simulation paramaters at this point, by creating a dictionary. 
Note that we cannot include the pseudopotential directory in the dictionary, nor can we manipulate the CARDS.
To do this you will hve to look further into the documentation.

It is trivial to add paramaters to the namelists:

    >>> espresso_params = espresso_params = {'calculation':'scf', 'outdir':'./TMP', 'pseudodir':'/work4/dls/shared/pslibrary_pbe', 'prefix':'Si', 'verbosity':'high', 'ecutwfc':40.}
    >>> b = write('silicon_new.pwi', a, format='espresso-in', input_data=espresso_params)

Now look at the input file again

    $ cat silicon_new.pwi 
    &CONTROL
       calculation      = 'scf'
       verbosity        = 'high'
       outdir           = './TMP'
       prefix           = 'Si'
    /
    &SYSTEM
       ecutwfc          = 40.0
       ntyp             = 1
       nat              = 2
       ibrav            = 0
    /
    &ELECTRONS
    /
    &IONS
    /
    &CELL
    /
    
    ATOMIC_SPECIES
    Si 28.085 None
    
    K_POINTS gamma
    
    CELL_PARAMETERS angstrom
    3.89152000000000 0.00000000000000 0.00000000000000
    1.94576000000000 3.37015517933522 0.00000000000000
    1.94576000000000 1.12338505977841 3.17741277461186
    
    ATOMIC_POSITIONS angstrom
    Si 0.0000000000 0.0000000000 0.0000000000 
    Si 5.8372800000 3.3701551793 2.3830595810 
