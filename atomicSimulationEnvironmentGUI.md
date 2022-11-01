
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

