
# New commands in this lecture

| <b>Command</b> | <b>Key Options</b> | <b>Description</b> |
|----------------|--------------------|--------------------|
| <code>xspectra.x</code> | | Quantum espresso code for XANES simulations |
| <code>gnuplot</code>    | | Commandline based application for plotting data | 

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

At the low energy (less than zero) part of the spectrum we see features that should not be there,
these correspond to transitions to the filled orbitals

We can remove these from the spectrum using the <code>xplot_only</code> option

    $ cat diamond.xspectra_replot.in 
    &input_xspectra
       calculation='xanes_dipole',
       prefix='diamond',
       outdir='./TMP'
       xonly_plot=.true., ! Do not perform the calculation, read results from saved file
       xniter=1000,
       xcheck_conv=50,
       xepsilon(1)=1.0,
       xepsilon(2)=0.0,
       xepsilon(3)=0.0,
       xiabs=1,
       x_save_file='diamond.xspectra.sav',
       ef_r=,
       xerror=0.001,
    /
    &plot
       xnepoint=1000,
       xgamma=0.8,
       xemin=-10.0,
       xemax=30.0,
       terminator=.true.,
       cut_occ_states=.true., ! Cut occupied states from final spectrum
    /
    &pseudos
       filecore='C.wfc',
       r_paw(1)=3.2,
    /
    &cut_occ
       cut_desmooth=0.1,
       cut_stepl=0.01,
    /
    4 4 4 1 1 1

Run <code>xspectra.x</code> again

    $ mpirun -np 1 xspectra.x -inp diamond.xspectra_replot.in
        Using the following parameters:
        energy-zero of the spectrum [eV]:   13.3353
        the occupied states are elimintate from the spectrum ***
        xemin [eV]: -10.00
        xemax [eV]:  30.00
        xnepoint: 1000
        constant broadening parameter [eV]:    0.800
        Core level energy [eV]:  -284.2    
         (from electron binding energy of neutral atoms in X-ray data booklet)

     Cross-section successfully written in xanes.dat 

     $ mv xanes.dat xanes_no_corehole_no_occ_states.dat
     $ gnuplot
     gnuplot> plot 'xanes_no_corehole.dat'; replot 'xanes_no_corehole_no_occ_states.dat'

We can also try to mimic the behaviour of the electronic structure in response to the presence of a hole in the 1s state.

For this we use a pseudopotential which has been created with the electronic configuration 1<em>s</em><sup>1</sup>

    $ cat diamondh.scf.in 
    &control
       calculation='scf',
       pseudo_dir = '../pseudopotentials'
       outdir='./TMP'
       prefix='diamondh',
    /
    &system
       ibrav = 1,
       celldm(1) = 6.740256,
       nat=8,
       ntyp=2,
       nbnd=16,
       tot_charge=+1.0,  ! Charged simulation cell due to core-hole
       ecutwfc=40.0,
    /
    &electrons
       mixing_beta = 0.3,
    /
    ATOMIC_SPECIES
    C_h 12.0 Ch_PBE_TM_2pj.UPF ! PP with core hole
    C 12.0 C_PBE_TM_2pj.UPF
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

We can run the dft calculation with the core-hole

    $ mpirun -np 1 pw.x -inp diamondh.scf.in 
    
And if we look at the <code>xspectra</code> file we see that not much changes

    $ cat diamondh.xspectra.in
    &input_xspectra
       calculation='xanes_dipole',
       prefix='diamondh',
       outdir='./TMP'
       xonly_plot=.false.,
       xniter=1000,
       xcheck_conv=10,
       xepsilon(1)=1.0,
       xepsilon(2)=0.0,
       xepsilon(3)=0.0,
       xiabs=1,
       x_save_file='diamondh.xspectra.sav',
       ef_r=,
       xerror=0.001,
    /
    &plot
       xnepoint=1000,
       xgamma=0.8,
       xemin=-10.0,
       xemax=30.0,
       terminator=.true.,
       cut_occ_states=.true.,
    /
    &pseudos
       filecore='C.wfc',
       r_paw(1)=3.2,
    /
    &cut_occ
       cut_desmooth=0.1,
       cut_stepl=0.01,
    /
    4 4 4 1 1 1

We can now plot and inspect the result of ths simulation

    $ mv xanes.dat xanes_corehole_no_occ_states.dat
    $ gnuplot
    gnuplot> plot 'xanes_corehole_no_occ_states.dat'; replot 'xanes_no_corehole_no_occ_states.dat'

# Example of polarization SiO<sub>2</sub>

    $ cat SiO2.scf.in
    &control
       calculation='scf',
       restart_mode='from_scratch',
       pseudo_dir = '../pseudopotentials'
       outdir='./TMP'
       prefix='SiO2',
       verbosity = 'high',
    /
    &system
       ibrav = 4 ,
       celldm(1)=9.28630318961333,
       celldm(3)=1.10010,
       nat = 9 ,
       ntyp = 3 ,
       nspin=1,
       ecutwfc = 20.0,
       ecutrho = 150.0,
       nbnd=30,
       smearing='mp',
       occupations='smearing',
       degauss=0.03,
    /
    &electrons
       diagonalization='david',
       conv_thr = 1.d-9,
       mixing_mode = 'plain',
       mixing_beta = 0.3,
    /
    
    ATOMIC_SPECIES
    Sih   28.086 Si_PBE_USPP.UPF
    Si   28.086 Si_PBE_USPP.UPF
    O  15.9994   O_PBE_USPP.UPF
    
    ATOMIC_POSITIONS crystal
    Sih 0.47000000000000 0.000000000000 0.00000000000000
    Si 0.00000000000000 0.47000000000000 0.6666666666666666
    Si -0.47000000000000 -0.47000000000000 0.333333333333333
    O 0.4131000000000000 0.267700000000000 0.11890000000000
    O 0.267700000000000 0.4131000000000000 .54776666666666666666
    O -0.267700000000000 0.1454000000000000 .78556666666666666666
    O -0.4131000000000000 -0.1454000000000000 .21443333333333333333
    O -0.1454000000000000 -0.4131000000000000 .45223333333333333333
    O 0.1454000000000000 -0.267700000000000 -0.11890000000000
    
    K_POINTS automatic
    2 2 2 0 0 0

    $ cat SiO2.xspectra_dip_plane.in 
    &input_xspectra
       calculation='xanes_dipole'
       prefix='SiO2',
       outdir='./TMP'
       xonly_plot=.false.,
       xniter=2000,
       xcheck_conv=50,
       xepsilon(1)=1.0,
       xepsilon(2)=1.0,
       xepsilon(3)=0.0,
       xiabs=1,
       x_save_file='SiO2.xspectra_dip_plane.sav',
       xerror=0.001,
       xe0=0.60294618180436781,
    / 

    &plot
       xnepoint=1000,
       xgamma=0.8,
       xemin=-10.0,
       xemax=100.0,
       terminator=.true.,
       cut_occ_states=.true.,
    /

    &pseudos
       filecore='Si.wfc',
       r_paw(1)=2.4,
    /

    &cut_occ
       cut_desmooth=0.1,
    /
    3 3 3 0 0 0

    $ ../tools/upf2plotcore.sh ../pseudopotentials/Si_PBE_USPP.UPF > Si.wfc 

    $ mpirun -np 1 xspectra.x -inp SiO2.xspectra_dip_plane.in
    $ mv xanes.dat xanes_inplane.dat
    $ gnuplot
    gnuplot> plot 'xanes_inplane.dat'
    
    $ cat SiO2.xspectra_dip_c.in 
    &input_xspectra
       calculation='xanes_dipole'
       prefix='SiO2',
       outdir='./TMP'
       xonly_plot=.false.,
       xniter=2000,
       xcheck_conv=50,
       xepsilon(1)=0.0,
       xepsilon(2)=0.0,
       xepsilon(3)=1.0,   ! Polarization in orthogonal direction
       xiabs=1,
       x_save_file='SiO2.xspectra_dip_c.sav',
       xerror=0.001,
       xe0=0.60294618180436781,
    /

    &plot
       xnepoint=1000,
       xgamma=0.8,
       xemin=-10.0,
       xemax=100.0,
       terminator=.true.,
       cut_occ_states=.true.,
    /

    &pseudos
       filecore='Si.wfc',
       r_paw(1)=2.4,
    /

    &cut_occ
       cut_desmooth=0.1,
    /
    3 3 3 0 0 0

    $ mv xanes.dat xanes_c.dat
    $ gnuplot
    $ gnuplot> plot 'xanes_inplane.dat' w l lw 3; replot 'xanes_c.dat' w l lw 3

# Magnetisim and NiO

    $ cat NiO.scf.in
    &control
        calculation='scf',
        pseudo_dir = '../pseudopotentials'
        outdir='./TMP'
        prefix='NiO',
     /

    &system
       ibrav = 5 ,
       celldm(1) =9.67155,
       celldm(4)=0.8333333333,
       nat = 4 ,
       ntyp = 3 ,
       nspin=2,
       ecutwfc = 70.0,
       starting_magnetization(1)=1.0,
       starting_magnetization(2)=-1.0,
       tot_magnetization = 0.0
       nbnd=24,
       lda_plus_u=.true.,
       Hubbard_U(1)=7.6,
       Hubbard_U(2)=7.6,
    /

    &electrons
       mixing_beta = 0.3,
    /

    ATOMIC_SPECIES
    Ni 58.6934   Ni_PBE_TM_2pj.UPF
    NiB  58.6934   Ni_PBE_TM_2pj.UPF
    O  15.9994   O_PBE_TM.UPF

    ATOMIC_POSITIONS crystal
    Ni  0.0000000000  0.0000000000  0.0000000000
    NiB  -.5000000000  1.5000000000  -.5000000000
    O  0.7500000000  -.2500000000  -.2500000000
    O  -.7500000000  0.2500000000  0.2500000000

    K_POINTS automatic
    1 1 1 0 0 0

    $ cat NiO.xspectra_dip.in
    &input_xspectra
       calculation='xanes_dipole',
       prefix='NiO',
       outdir='./TMP'
       xniter=1000,
       xcheck_conv=50,
       xepsilon(1)=1.0,
       xepsilon(2)=0.0,
       xepsilon(3)=0.0,
       xiabs=1,
       x_save_file='NiO.xspectra_dip.sav',
       xerror=0.001,
    /
    &plot
       xnepoint=300,
       xgamma=0.8,
       xemin=-10.0,
       xemax=20.0,
       terminator=.true.,
       cut_occ_states=.true.,
    /
    &pseudos
       filecore='Ni.wfc',
       r_paw(1)=1.5,
    /
    &cut_occ
       cut_desmooth=0.1,
    /
    2 2 2 0 0 0

    $ ../tools/upf2plotcore.sh ../pseudopotentials/Ni_PBE_TM_2pj.UPF > Ni.wfc
    $ mpirun -np 1 xspectra.x -inp NiO.xspectra_dip.in
    $ mv xanes.dat xanes_dip_gamma_1.5.dat
    $ mpirun -np 1 xspectra.x -inp NiO.xspectra_dip_replot.in
    $ mv xanes.dat xanes_dip_gamma_0.8.dat
    $ gnuplot
    gnuplot> plot 'xanes_dip_gamma_1.5.dat' w l lw 3; replot 'xanes_dip_gamma_0.8.dat' w l lw 3

    $ cat cat NiO.xspectra_qua.in 
    &input_xspectra
       calculation='xanes_quadrupole',
       prefix='NiO',
       outdir='./TMP'
       xniter=1000,
       xcheck_conv=50,
       xepsilon(1)=1.0,
       xepsilon(2)=-1.0,
       xepsilon(3)=0.0,
       xkvec(1)=1.0,
       xkvec(2)=1.0,
       xkvec(3)=-1.0,
       xiabs=1,
       x_save_file='NiO.xspectra_qua.sav',
       xerror=0.001,
    /
    &plot
       xnepoint=300,
       xgamma=0.8,
       xemin=-10.0,
       xemax=20.0,
       terminator=.true.,
       cut_occ_states=.true.,
    /
    &pseudos
       filecore='Ni.wfc',
       r_paw(2)=1.5,
    /
    &cut_occ
       cut_desmooth=0.1,
    /
    2 2 2 0 0 0

    $ mv xanes.dat xanes_quad_gamma_1.5.dat
    $ gnuplot
    gnuplot> plot 'xanes_dip_gamma_1.5.dat' w l lw 3; replot 'xanes_quad_gamma_1.5.dat' u 1:($2*15) w l lw 3


