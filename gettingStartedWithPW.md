
# Getting Started with <code>pw.x</code>

## New commands

| Command | Key Options | Description |
| ------- | ----------- | ----------- |
| <b>QE</b> |  |  |
<code>pw.x</code> | <code>-inp</code> <code>-npools</code> | Main executable for DFT in Quantum ESPRESSO |
| <b>Other</b> |  |
| <code>module</code> | <code>load</code> | load a particular module to the current environment |
| <code>export</code> | | export an environment variable
| <code>mpirun</code> | <code>-np</code> | Run a job with parallel processes |
| <code>tee</code>    |   | Simultaneously print output to terminal and capture to file |

## Introduction to X-Ray Spectroscopy in Quantum ESPRESSO

![ESPRESSO](Figures/espressoWorkFlows/espressoWorkFlows.001.png)

![WORKFLOW](Figures/espressoWorkFlows/espressoWorkFlows.002.png)

## The <code>pw.x</code> Input File

Now we can look at the input file, which will be read by the <code>pw.x</code>.
The input file is separated into a set of <code>Namelists</code> that must be presented in
order, followed by a series of <code>Cards</code>, which can be presented in any order.

Essentially the <code>Namelists</code> define the calculation and <code>Cards</code>
define the system we want to calculate.

There are potentially hundreds of individuals key words we might want to use to run our
calculations.
There is a complete overview of the input keywords and possible arguments available
[here](https://www.quantum-espresso.org/Doc/INPUT_PW.html). It is not required to provide
every keyword in the input file. First we will look at the most important ones:

The first <code>Namelist</code> is <code>&CONTROL</code>, which deals with <em>administrative</em>
variables. Quantum ESPRESSO is programmed in FORTRAN, so <code>!</code> can be used to
insert a comment.

    &CONTROL
       calculation = '' ! The type of job requested
       prefix      = '' ! The name of the files created
       outdir      = '' ! Where metadata is stored
       psuedodir   = '' ! The location of the pseudopotentials
       verbosity   = '' ! How detailed is the output from the code
    /

The second <code>Namelist</code> is the <code>&SYSTEM</code>, which describes the material being
calculated.

    &SYSTEM
       ibrav     = ! index of the bravais lattice
       celldm(1) = ! Lattice parameter in (Bohr Radius)
       nat       = ! Number of atoms
       ntyp      = ! Number of different Atomic types
       ecutwfc   = ! Energy cutoff applied to basis set
       nspin     = ! Spin polarization or non-collinear magnetism
    /

The third <code>Namelist</code> is <code>&ELECTRONS</code> which introduces keywords that control the
self consistency cycle.
Luckily in the first instance, we do not have to specify anything here, just declare the
<code>Namelist</code>

    &ELECTRONS
    /

For geometry optimisation, there is one further <code>Namelist</code> which controls the
optimisation of the ionic (nuclear) coordinates. Similar to the <code>&ELECTRONS</code>
<code>Namelist</code>, we don't have to provide any parameters at first.

    &IONS
    / 

After these <code>Namelists</code> in this order, we have to provide a set of
<code>Cards</code> that provides details on the system.
These <code>Cards</code> can be given in any order.

The first we will require is the <code>ATOMIC_SPECIES</code> Card.
This is a list of all of the different atom types used in the calculation.
Note that the same Atom can be given two different labels to distinguish between different
sites in a crystal. This is useful for instance in defining magnetically coupled elements
in anti-ferromagnetic materials.

The number of specicies listed in the <code>ATOMIC_SPECIES</code> <code>Card</code> should
be equal to <code>ntyp</code> set in the <code>&SYSTEM</code> <code>Namelist</code>

    ATOMIC_SPECIES
    label1 atomic_mass pseudopotential
    label2 atomic_mass pseudopotential

We also have to provide the coordinates of the atoms in the system.
These can be given to <code>pw.x</code> in xyz format in units of Angstrom, Bohr radius
and as a fraction of the lattice parameter.

    ATOMIC_POSITIONS {Unit}
    label1 x1 y1 z1
    label1 x2 y2 z2
    label1 x3 y3 z3
    label2 x4 y4 z4

If we do not use a prescribed Bravais lattice through the <code>ibrav</code> keyword in
the <code>&SYSTEM</code> <code>Namelist</code>, then we must provide details on the unit
cell. Similar to the atomic coordinates, the cell can be specified with units Angstrom,
Bohr radius and as a fraction of the lattice constant.

    CELL_PARAMETERS {Unit}
    a1 a2 a3
    b1 b2 b3
    c1 c2 c3

Lastly, we must describe the sampling of the reciprocal lattice. 
This is done using the <code>K_POINTS</code> <code>Card</code>.
For the standard DFT calculations we will do, it is best to use an automatically generated
Gamma centered grid

    K_POINTS {Automatic}
    k1 k2 k3 0 0 0

## Running <code>pw.x</code>

Lets put together an input file from scratch and run <code>pw.x</code> live.

First we can login to SCARF and navigate to the directory we created for our work last time

    $ ssh myfedidi@ui1.scarf.rl.ac.uk
    $ cd myfedid

Next we can create a directory for the first example we will run

    $ mkdir espresso_example
    $ espresso_example

Now we can begin to write the input file, I will use <code>nano</code>, which is a basic commandline text editor

    $ nano silicon.pwi

    &CONTROL
       calculation = 'scf' ! The type of job requested
       prefix      = 'si' ! The name of the files created
       outdir      = './OUT' ! Where metadata is stored
       pseudo_dir   = '/work4/dls/shared/pslibrary_pbe' ! The location of the pseudopotentials
       verbosity   = 'high' ! How detailed is the output from the code
    /
    
    &SYSTEM
       ibrav     =  0    ! index of the bravais lattice
       celldm(1) = 10.40 ! Lattice parameter in (Bohr Radius)
       nat       =  2    ! Number of atoms
       ntyp      =  1    ! Number of different Atomic types
       ecutwfc   = 40    ! Energy cutoff applied to basis set
       nspin     =  1    ! Spin polarization or non-collinear magnetism
    /
    
    &ELECTRONS
    /
    
    ATOMIC_SPECIES
    Si 28.086 Si.pbe-nl-rrkjus_gipaw.UPF
    
    ATOMIC_POSITIONS {alat}
    Si 0.00 0.00 0.00
    Si 0.25 0.25 0.25
    
    K_POINTS {automatic}
    3 3 3 0 0 0
    
    CELL_PARAMETERS {alat}
     -0.50 0.00 0.50
      0.00 0.50 0.50
     -0.50 0.50 0.00

To exit you can use the key combination <code>CTRL+X</code>

Some thing to note before we move on with running the calculation: There are pseudopotential files for most elements in the directory <code>/work4/shared/</code>, so this can be set for the keyword <code>pseudo_dir</code>. To find the name of the pseudopotential for the element you require you can use <code>ls</code> on this directory.

As this is a very small, and very short calculation we are going to run it live (I do not recommend doing this under any other circumstances).

    $ module load contrib/dls-spectroscopy/quantum-espresso/6.5-intel-18.0.3
    $ export OMP_NUM_THREADS=4
    $ mpirun -np 4 pw.x -inp silicon.pwi | tee silicon.pwo
    ....
    =------------------------------------------------------------------------------=
       JOB DONE.
    =------------------------------------------------------------------------------=

First we load the relevant module to have the quantum ESPRESSO executable files in our PATH.
Next to make sure that we localise the small job we set the environment variable <code>OMP_NUM_THREADS</code> to 1
Finally, we launch the <code>pw.x</code> code using the <code>mpirun</code> command. We ask for 4 processes using the option <code>-np</code>.

The <code>pw.x</code> requires and input file for execution, we use the flag <code>-inp</code> to provide one.
Finally we use the <code>tee</code> command to capture the output in the new file <code>silicon.pwo</code>.  <code>tee</code> is particularly useful in this case because it also prints the output to the terminal, unlike a regular redirect.

These commands should be at least a little bit familiar from the job script last week, even if we didnt go over them explicitly.

## The <code>pw.x</code> Output File

The Output File header

     Program PWSCF v.6.5 starts on 10Oct2022 at 16: 2:44 

     This program is part of the open-source Quantum ESPRESSO suite
     for quantum simulation of materials; please cite
         P. Giannozzi et al., J. Phys.:Condens. Matter 21 395502 (2009);
         P. Giannozzi et al., J. Phys.:Condens. Matter 29 465901 (2017);
          URL http://www.quantum-espresso.org, 
     in publications or presentations arising from this work. More details at
     http://www.quantum-espresso.org/quote

The compute settings and input file

     Parallel version (MPI), running on     4 processors

     MPI processes distributed on     1 nodes
     R & G space division:  proc/nbgrp/npool/nimage =       4
     Reading input from silicon.pwi

The self-consistency iterations

     iteration #  1     ecut=    40.00 Ry     beta= 0.70
     Davidson diagonalization with overlap
     ethr =  1.00E-02,  avg # of iterations =  2.0

     Threshold (ethr) on eigenvalues was too large:
     Diagonalizing with lowered threshold

     Davidson diagonalization with overlap
     ethr =  8.51E-04,  avg # of iterations =  1.2

     total cpu time spent up to now is        0.5 secs

     total energy              =     -20.39192174 Ry
     Harris-Foulkes estimate   =     -20.40782868 Ry
     estimated scf accuracy    <       0.06702974 Ry

     iteration #  2     ecut=    40.00 Ry     beta= 0.70
     Davidson diagonalization with overlap
     ethr =  8.38E-04,  avg # of iterations =  1.0

     total cpu time spent up to now is        0.5 secs

     total energy              =     -20.39429182 Ry
     Harris-Foulkes estimate   =     -20.39448746 Ry
     estimated scf accuracy    <       0.00338013 Ry

     iteration #  3     ecut=    40.00 Ry     beta= 0.70
     Davidson diagonalization with overlap
     ethr =  4.23E-05,  avg # of iterations =  2.5

     total cpu time spent up to now is        0.5 secs

     total energy              =     -20.39488490 Ry
     Harris-Foulkes estimate   =     -20.39492567 Ry
     estimated scf accuracy    <       0.00012018 Ry

The band information

          k = 0.0000 0.0000 0.0000 (  1243 PWs)   bands (ev):

    -5.8129   5.8974   5.8974   5.8974

     occupation numbers 
     1.0000   1.0000   1.0000   1.0000

          k =-0.3333 0.3333-0.3333 (  1194 PWs)   bands (ev):

    -4.4843   0.6600   4.9176   4.9176

     occupation numbers 
     1.0000   1.0000   1.0000   1.0000

          k = 0.0000 0.6667 0.0000 (  1218 PWs)   bands (ev):

    -3.9713   0.9127   3.5484   3.5484

     occupation numbers 
     1.0000   1.0000   1.0000   1.0000

          k = 0.6667-0.0000 0.6667 (  1196 PWs)   bands (ev):

    -2.6689  -0.7841   1.6391   3.8425

     occupation numbers 
     1.0000   1.0000   1.0000   1.0000

     highest occupied level (ev):     5.8974

The total energy 

     !    total energy              =     -20.39492696 Ry

## Pseudopotentials

# Optimization with <code>pw.x</code>

![OPTIMIZATION](Figures/espressoWorkFlows/espressoWorkFlows.003.png)

## Basis set optimization

First lets look at the first part of the optimization, which is the optimization of the
basis set.

To understand why we should do this optimisation we can look at what the basis set is

$$ \psi_i(\mathbf{r}) = \sum^\infty C_{i} \phi_{i}(\mathbf{r}) $$

a representation of the wavefunction $\psi_i$ as an infinite expansion of known functions
$\phi_i$, in our case those known functions are plane waves.
Practically, we cannot achieve an infinite expansion, so we have to truncate the basis
set, we do this by imposing a cutoff on the kinetic energy of the plane waves.

To make sure that we find an accurate solution, in optimal time we must perform a series 

## <b>k</b>-point Optimization 

## Conceptual Gotchas

### Systems that work out of the box

 - Bulk crystalline materials

### Systems that require care

 - Unpaired spins
 - Molecules
 - Surfaces
 - Neutral defects

### Systems that are challenging

 - Mott-Insulators
 - Molecules on surfaces
 - Solid-Liquid interfaces
 - Charged defects
 - Charged Molecules

### Systems that are really nasty

 - Charged surfaces
