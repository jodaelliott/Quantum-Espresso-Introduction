
# New commands in this lecture

| <b>Command</b> | <b>Key Options</b> | <b>Description</b> |
|----------------|--------------------|--------------------|
|

# Examples in this session:
- Diamond
- SiO<sub>2</sub>
- NiO

# Diamond and the XSpectra input file

## Workflow for Xspectra calculation revisited


    $ cat diamond.scf.in
    &control
        calculation='scf',
        pseudo_dir = '../pseudopotentials'
        outdir='./TMP'
        prefix='diamond',
     /
     &system
        ibrav = 1,
        celldm(1) = 6.740256,
        nat=8,
        ntyp=2,
        nbnd=16,
        ecutwfc=40.0,
     /
     &electrons
        mixing_beta = 0.3,
     /
    ATOMIC_SPECIES
    C_h 12.0 C_PBE_TM_2pj.UPF
    C   12.0 C_PBE_TM_2pj.UPF

    ATOMIC_POSITIONS crystal
    C_h 0.0 0.0 0.0
    C 0.0 0.5 0.5
    C 0.5 0.0 0.5
    C 0.5 0.5 0.0
    C 0.75 0.75 0.25
    C 0.75 0.25 0.75
    C 0.25 0.75 0.75
    C 0.25 0.25 0.25

    K_POINTS automatic
    4 4 4 0 0 0

Load modules, request resources, and run pw.x

    $ module load contrib/dls-spectroscopy/quantum-espresso/6.5-intel-18.0.3
    $ salloc -p scarf -C amd
    $ mpirun -np 1 pw.x -inp diamond.scf.in

Now that the SCF calculation is finished, lets look at the xspectra input file

    cat diamond.xspectra.in
    &input_xspectra
       calculation='xanes_dipole',
       prefix='diamond',
       outdir='./TMP'
       xniter=1000,
       xcheck_conv=50,
       xepsilon(1)=1.0,
       xepsilon(2)=0.0,
       xepsilon(3)=0.0,
       xiabs=1,
       x_save_file='diamond.xspectra.sav',
       xerror=0.001,
    /
    &plot
       xnepoint=300,
       xgamma=0.8,
       xemin=-10.0,
       xemax=30.0,
       terminator=.true.,
       cut_occ_states=.false.,
    /
    &pseudos
       filecore='C.wfc',
       r_paw(1)=3.2,
    /
    &cut_occ
    /
    4 4 4 1 1 1

## XSpectra Namelists

<code>&INPUT_XSPECTRA</code>

    &input_xspectra
       calculation  = ! like pw.x, the type of calculation to be run (xanes_dipole, xanes_quadrupole)
       prefix       = ! like pw.x, the name of all the metadata files to be created
       outdir       = ! like pw.x, the location of all of the simulation files
       xniter       = ! the maximum number of iterations to reach convergence
       xcheck_conv  = ! how often to check whether spectrum is converged
       xepsilon(1)  = ! projection of the polarization vector
       xepsilon(2)  = !
       xepsilon(3)  = !
       xiabs        = ! index corresponding to the absorbing atom in pw.x simulation
       x_save_file  = ! name of file where xspectra metadata is written
       xerror       = ! convergence threshold
    /

The second namelist is <code>&PLOT</code>

    &plot
       xnepoint        = ! number of points in plot (energy resolution)
       xgamma          = ! spectral broadening related to core-hole lifetime
       xemin           = ! minimum energy of the spectrum
       xemax           = ! maximum energy of the spectrum
       terminator      = ! use a function to improve convergence
       cut_occ_states  = ! include/ remove occupied states from the spectrum
    /

The third namelist is <code>&PSEUDOS</code>

    &pseudos
       filecore   = ! File that contains the atomic core wavefunction (initial state)
       r_paw(1)   = ! radius of the wavefunction reconstructed from projector augmented wavein l=1
       r_paw(2)   = ! as above for l=2
    /

Finally, there is the <code>&CUT_OCC</code> Namelist which helps to smoothly remove coccupied states from the spectrum.

Typically, before we run the xspectra calculation we will have to extract the core wavefunction <code>filecore</code> from the pseudopotential.

    $ ../tools/upf2plotcore.sh ../pseudopotentials/C_PBE_TM_2pj.UPF > C.wfc
 
We can plot the wavefunction file to make sure it makes sense

    $ gnuplot
    gnuplot> plot 'C.wfc'
    gnuplot> set xrange [0:5]
    gnuplot> replot

We can use the <code>xspectra</code> code to run the example

    $ mpirun -np 1 xspectra.x -inp diamond.xspectra.in

        The spectrum is calculated using the following parameters:
        energy-zero of the spectrum [eV]:   13.3353
        the occupied states are NOT eliminated from the spectrum
        xemin [eV]: -10.00
        xemax [eV]:  30.00
        xnepoint:  300
        constant broadening parameter [eV]:    0.800
        Core level energy [eV]:  -284.2    
         (from electron binding energy of neutral atoms in X-ray data booklet)

     $ ls -ltrh
     -rw-r--r-- 1 scarf1097 diag 8.7K Nov 14 11:28 xanes.dat

We can rename and plot the xanes spectrum

     $ mv xanes.dat xanes_no_corehole.dat
     $ gnuplot
     gnuplot> plot 'xanes_no_corehole.dat'


