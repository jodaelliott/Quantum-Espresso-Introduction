
| <b>Command</b>         | <b>Key Options</b>      | <b>Description</b>                                                                                                                                               |
| ---------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <code>dos.x</code>     |                         | Quantum Espresso package to compute the density of states                                                                                                        |
| <code>projwfc.x</code> |                         | Quantum Espresso package to project electronic density on atomic orbitals and compute projected density of states and atomic populations                         |
| <code>bands.x</code>   |                         | Quantum Espresso package to extract plottable band structure from `bands` calculation                                                                            |
| <code>pw.x</code>      | `calculation = 'nscf'`  | Initialise a non-self consistent calculation (Compute wavefunctions and energies from static density)                                                            |
| <code>pw.x</code>      | `calculation = 'bands'` | Initialise a non-self-consistent calculation along a specific k-point path (Compute wavefunctions and energies from static density) to obtain the band structure |

# Density of States

We can login to the cluster an navigate to the example folders for post-processing:

```bash
$ ssh myfedid@ui1.scarf.rl.ac.uk
$ /home/vol07/scarf1097/JoshuaElliott/Quantum-Espresso-Introduction-main/Examples/06_Post_Processing
$ ls -ltrh
total 176K
-rw-r--r-- 1 scarf1097 diag   86 Mar 27 06:05 06_ZnO_bandspp.pwi
-rw-r--r-- 1 scarf1097 diag  862 Mar 27 06:05 05_ZnO_bands.pwi
-rw-r--r-- 1 scarf1097 diag  154 Mar 27 06:05 03_ZnO_dos.pwi
-rw-r--r-- 1 scarf1097 diag  802 Mar 27 06:05 02_ZnO_nscf.pwi
-rw-r--r-- 1 scarf1097 diag  131 Mar 27 06:05 04_ZnO_pdos.pwi
-rw-r--r-- 1 scarf1097 diag  782 Mar 27 06:05 01_ZnO_scf.pwi
drwxr-xr-x 5 scarf1097 diag 4.0K Mar 27 06:06 reference
```

In order to compute is the density of states the first thing we must do is obtain the converged electronic density for the ZnO crystal structure. This is done by following the procedure we outlined in the previous sections.

We can check the input file, request some allocation of cores and run the calculation:

```bash
$ cat 01_ZnO_scf.pwi
&CONTROL
   calculation = 'scf'
   prefix      = 'zno'
   outdir      = './TMP'
   pseudo_dir  = '/work4/dls/shared/pslibrary_pbesol/'
   verbosity   = 'high'
/

&SYSTEM
   ibrav   =   4
   A       =   3.23735102000000
   C       =   5.22206130000000
   nat     =   4
   ntyp    =   2
   ecutwfc =  60.
   ecutrho = 600.
   nspin   =   1
/

&ELECTRONS
   startingwfc     = 'atomic'
   diagonalization = 'cg'
   conv_thr        = 1.D-9
/

ATOMIC_SPECIES
Zn  65.38  Zn.pbesol-spn-rrkjus_gipaw.1.0.0.UPF 
 O  15.999  O.pbesol-n-rrkjus_gipaw.1.0.0.UPF

ATOMIC_POSITIONS {crystal}
Zn 0.3333333300 0.6666666700 0.0005917000 
Zn 0.6666666600 0.3333333300 0.5005917000 
 O 0.3333333300 0.6666666700 0.3797183000 
 O 0.6666666600 0.3333333300 0.8797183000 

K_POINTS {automatic}
5 5 3 1 1 1
```

We have added some additional keywords inside the `&ELECTRONS` namelist:
`startingwfc = 'atomic` tells the code to use atomic wavefunctions in the initial step, rather than random numbers
`diagonalization = 'cg'` uses a conjugate gradient scheme to perform the SCF iterations

```
$ salloc -n 4 -c amd
salloc: Granted job allocation 2248526
salloc: Waiting for resource configuration
salloc: Nodes cn059 are ready for job
$ module load contrib/dls-spectroscopy/quantum-espresso/7.3.1-GCC-12.2.0
$ export OMP_NUM_THREADS=1
$ mpirun -np 4 pw.x -inp 01_ZnO_scf.pwi | tee 01_ZnO_scf.pwo
```
## Non Self Consistent Calculation (More Bands, More k-points)

Once we have computed the electron density, in order to see some of the empty bands (above the Fermi level) in the density of states, we have to compute their single particle wavefunctions.

We can do this non-self-consistently by solving the Kohn-Sham equations a single time using the optimised electron density to construct the Hamiltonian.

We can also use the same non-self-consistent procedure to add additional k-points in the sampling of the Brillouin zone

```
$ cat 02_ZnO_nscf.pwi
&CONTROL
   calculation = 'nscf'
   prefix      = 'zno'
   outdir      = './TMP'
   pseudo_dir  = '/work4/dls/shared/pslibrary_pbesol/'
   verbosity   = 'high'
/

&SYSTEM
   ibrav   =   4
   A       =   3.23735102000000
   C       =   5.22206130000000
   nat     =   4
   ntyp    =   2
   ecutwfc =  60.
   ecutrho = 600.
   nspin   =   1
   nbnd    =  50
/

&ELECTRONS
   startingwfc     = 'atomic'
   diagonalization = 'cg'
   conv_thr        = 1.D-9
/

ATOMIC_SPECIES
Zn  65.38  Zn.pbesol-spn-rrkjus_gipaw.1.0.0.UPF 
 O  15.999  O.pbesol-n-rrkjus_gipaw.1.0.0.UPF

ATOMIC_POSITIONS {crystal}
Zn 0.3333333300 0.6666666700 0.0005917000 
Zn 0.6666666600 0.3333333300 0.5005917000 
 O 0.3333333300 0.6666666700 0.3797183000 
 O 0.6666666600 0.3333333300 0.8797183000 

K_POINTS {automatic}
15 15 6 1 1 1
```

Here we have changed
`calculation = 'nscf'` which switches off the self-consistency loop
`nbnd = 50` which sets the total number of bands to compute, this must be equal to or greater than the number of electrons (or number of electons/2 in case of `nspin = 1`)
`K_POINTS` is set to `15 15 6` so that we have a lot of sampling of the Brillouin zone for the density of states

Due to the high number of k points this could take longer (several minutes) to compute

```bash
mpirun -np 4 pw.x -inp 02_ZnO_nscf.pwi | tee 02_ZnO_nscf.pwo
```

From here we can go to the input page for `dos.x` to understand how to build the input file to compute the DOS
https://www.quantum-espresso.org/Doc/INPUT_DOS.html

```bash
$ cat 03_ZnO_dos.pwi
&DOS
   prefix      = 'zno'
   outdir      = './TMP'
   bz_sum      = 'smearing'
   ngauss      = -1
   degauss     = 0.0075
   fildos      = 'ZnO.dos'
/
```

The input prefix and outdir must match the `pw.x` calculations, we should select `smearing` and a smearing scheme (feel free to try the different options) and a value of the smearing applied.

As a general rule of thumb I start with a small smearing (0.005 Ry) and slowly increase until the plot looks acceptable (not spikey, but not overly smooth).

We can execute `dos.x` the same as `pw.x`

```bash
$ mpirun -np 4 dos.x -inp 03_ZnO_dos.pwi | tee 03_ZnO_dos.pwo
$ ls -ltrh
total 896K
-rw-r--r-- 1 scarf1097 diag   86 Mar 27 06:05 06_ZnO_bandspp.pwi
-rw-r--r-- 1 scarf1097 diag  862 Mar 27 06:05 05_ZnO_bands.pwi
-rw-r--r-- 1 scarf1097 diag  154 Mar 27 06:05 03_ZnO_dos.pwi
-rw-r--r-- 1 scarf1097 diag  802 Mar 27 06:05 02_ZnO_nscf.pwi
-rw-r--r-- 1 scarf1097 diag  131 Mar 27 06:05 04_ZnO_pdos.pwi
-rw-r--r-- 1 scarf1097 diag  782 Mar 27 06:05 01_ZnO_scf.pwi
drwxr-xr-x 5 scarf1097 diag 4.0K Mar 27 06:06 reference
drwxr-xr-x 3 scarf1097 diag 4.0K Mar 27 06:47 TMP
-rw-r--r-- 1 scarf1097 diag 515K Mar 27 06:52 ZnO.dos
```

To normalise the plot we can extract the Fermi level from the `nscf` calculation:

```bash 
$ grep highest 02_ZnO_nscf.pwo
     highest occupied, lowest unoccupied level (ev):     8.7961    9.8606
```

And plot the dos with gnuplot

```gnuplot
gnuplot> set xrange [-8:4]
gnuplot> set yrange [0:25]
gnuplot> p 'ZnO.dos_0.0075' u ($1-8.7961):2 w l lw 3
```

## Projected Density of States and Charge Partitioning

It can be instructive to understand which states contribute to a particular energy in the density of states, this can allow us to characterise the valence and conduction band edges for instance. One way to do this is to project the electronic density onto a set of atomic orbitals on each atom in the system and use the overlap as an indication of the contribution of those states to that energy level.

This is handled by the `projwfc.x` code in quantum espresso, which has input parameters found here:
https://www.quantum-espresso.org/Doc/INPUT_PROJWFC.html

Let's look at the input file

```bash
$ cat 04_ZnO_pdos.pwi
&PROJWFC
   prefix      = 'zno'
   outdir      = './TMP'
   ngauss      = -1
   degauss     = 0.0075
   filpdos     = 'ZnO.pdos'
/
```

Similar to the density of states example, we need to be consistent with the `pw.x` calculation and select an smearing scheme and broadening

We can run in the same way, substituting the executable name:

```bash
mpirun -np 4 projwfc.x -inp 04_ZnO_pdos.pwi | tee 04_ZnO_pdos.pwo
```

In the output we get an estimation of the atomic populations based on the projection:

```
Lowdin Charges: 
  
     Atom #   1: total charge =  18.5954, s =  2.6207, 
     Atom #   1: total charge =  18.5954, p =  5.9996, pz=  1.9999, px=  1.9999, py=  1.9999, 
     Atom #   1: total charge =  18.5954, d =  9.9750, dz2=  1.9927, dxz=  1.9965, dyz=  1.9965, dx2-y2=  1.9947, dxy=  1.9947, 
     Atom #   2: total charge =  18.5954, s =  2.6207, 
     Atom #   2: total charge =  18.5954, p =  5.9996, pz=  1.9999, px=  1.9999, py=  1.9999, 
     Atom #   2: total charge =  18.5954, d =  9.9750, dz2=  1.9927, dxz=  1.9965, dyz=  1.9965, dx2-y2=  1.9947, dxy=  1.9947, 
     Atom #   3: total charge =   7.2105, s =  1.8691, 
     Atom #   3: total charge =   7.2105, p =  5.3414, pz=  1.7807, px=  1.7804, py=  1.7804, 
     Atom #   3: total charge =   7.2105, d =  0.0000, dz2=  0.0000, dxz=  0.0000, dyz=  0.0000, dx2-y2=  0.0000, dxy=  0.0000, 
     Atom #   4: total charge =   7.2105, s =  1.8691, 
     Atom #   4: total charge =   7.2105, p =  5.3414, pz=  1.7807, px=  1.7804, py=  1.7804, 
     Atom #   4: total charge =   7.2105, d =  0.0000, dz2=  0.0000, dxz=  0.0000, dyz=  0.0000, dx2-y2=  0.0000, dxy=  0.0000, 
     Spilling Parameter:   0.0075
```

We now also have the projected density of states files, on for each atom and orbital angular momentum channel:

```bash
$ ls -ltrh
total 13M
-rw-r--r-- 1 scarf1097 diag   86 Mar 27 06:05 06_ZnO_bandspp.pwi
-rw-r--r-- 1 scarf1097 diag  862 Mar 27 06:05 05_ZnO_bands.pwi
-rw-r--r-- 1 scarf1097 diag  154 Mar 27 06:05 03_ZnO_dos.pwi
-rw-r--r-- 1 scarf1097 diag  802 Mar 27 06:05 02_ZnO_nscf.pwi
-rw-r--r-- 1 scarf1097 diag  131 Mar 27 06:05 04_ZnO_pdos.pwi
-rw-r--r-- 1 scarf1097 diag  782 Mar 27 06:05 01_ZnO_scf.pwi
drwxr-xr-x 5 scarf1097 diag 4.0K Mar 27 06:06 reference
drwxr-xr-x 3 scarf1097 diag 4.0K Mar 27 06:47 TMP
-rw-r--r-- 1 scarf1097 diag 515K Mar 27 06:52 ZnO.dos
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_atm#1(Zn)_wfc#1(s)
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_atm#1(Zn)_wfc#2(s)
-rw-r--r-- 1 scarf1097 diag 826K Mar 27 07:03 ZnO.pdos.pdos_atm#1(Zn)_wfc#3(p)
-rw-r--r-- 1 scarf1097 diag 1.2M Mar 27 07:03 ZnO.pdos.pdos_atm#1(Zn)_wfc#4(d)
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_atm#2(Zn)_wfc#1(s)
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_atm#2(Zn)_wfc#2(s)
-rw-r--r-- 1 scarf1097 diag 826K Mar 27 07:03 ZnO.pdos.pdos_atm#2(Zn)_wfc#3(p)
-rw-r--r-- 1 scarf1097 diag 1.2M Mar 27 07:03 ZnO.pdos.pdos_atm#2(Zn)_wfc#4(d)
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_atm#3(O)_wfc#1(s)
-rw-r--r-- 1 scarf1097 diag 826K Mar 27 07:03 ZnO.pdos.pdos_atm#3(O)_wfc#2(p)
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_atm#4(O)_wfc#1(s)
-rw-r--r-- 1 scarf1097 diag 826K Mar 27 07:03 ZnO.pdos.pdos_atm#4(O)_wfc#2(p)
-rw-r--r-- 1 scarf1097 diag 483K Mar 27 07:03 ZnO.pdos.pdos_tot
```

To look at the contribution of the Zn d and O p states to the DOS we have to combine the contributions from both Zn atoms and both O atoms

```bash
$ paste 'ZnO.pdos.pdos_atm#2(Zn)_wfc#4(d)' 'ZnO.pdos.pdos_atm#1(Zn)_wfc#4(d)' | awk '{print $1, $2+$9}' > ZnO.Znd.pdos
$ paste 'ZnO.pdos.pdos_atm#3(O)_wfc#2(p)' 'ZnO.pdos.pdos_atm#4(O)_wfc#2(p)' | awk '{print $1, $2+$7}' > ZnO.Op.pdos
```

And now we can plot with gnuplot

```gnuplot
gnuplot> set xrange [-8:4]
gnuplot> set yrange [0:25]
gnuplot> p 'ZnO.dos_0.0075' u ($1-8.796):2 w l lw 3, 'ZnO.Znd.pdos' u ($1-8.796):2 w l lw 3, 'ZnO.Op.pdos'  u ($1-8.796):2 w l lw 3
```

If we repeat the process for the Zn s we should see a contribution to the conduction band in the energy range of the Fermi level + 8 eV characteristic of hexagonal ZnO
# Band Structure

The calculation of the band structure works similarly to the calculation of the density of states: we have to perform a special type of non-self-consistent calculation with special K points and a number of empty states, and then perform post processing on what we have created.

A band structure calculation is initialized by setting `calculation = 'bands'` and setting a k-point path through the Brillouin zone along the high symmetry lines:

Since hexagonal ZnO has the hexagonal bravais lattice we can use the following input file:

```bash
cat 05_ZnO_bands.pwi
&CONTROL
   calculation = 'bands'
   prefix      = 'zno'
   outdir      = './TMP'
   pseudo_dir  = '/work4/dls/shared/pslibrary_pbesol/'
   verbosity   = 'high'
/

&SYSTEM
   ibrav   =   4
   A       =   3.23735102000000
   C       =   5.22206130000000
   nat     =   4
   ntyp    =   2
   ecutwfc =  60.
   ecutrho = 600.
   nspin   =   1
   nbnd    =  50
/

&ELECTRONS
   startingwfc     = 'atomic'
   diagonalization = 'cg'
   conv_thr        = 1.D-9
/

ATOMIC_SPECIES
Zn  65.38  Zn.pbesol-spn-rrkjus_gipaw.1.0.0.UPF 
 O  15.999  O.pbesol-n-rrkjus_gipaw.1.0.0.UPF

ATOMIC_POSITIONS {crystal}
Zn 0.3333333300 0.6666666700 0.0005917000 
Zn 0.6666666600 0.3333333300 0.5005917000 
 O 0.3333333300 0.6666666700 0.3797183000 
 O 0.6666666600 0.3333333300 0.8797183000 

K_POINTS {tpiba_b}
12
gG 20
 M 20
 K 20
gG 20
 A 20
 L 20
 H 20
 A  0
 L 20
 M  0
 H 20
 K  0
```

Then we can run the bands calculation:

```bash
mpirun -np 4 pw.x -inp 05_ZnO_bands.pwi | tee 05_ZnO_bands.pwo
```

As with the case of the DOS, this calculation may take a few minutes due to the high number of kpoints being simulated.

Once the calculation at each k-point is completed the energies of each band at each k-point is printed to the output file. We can use the `bands.x` software to construct a plottable band structure file:
https://www.quantum-espresso.org/Doc/INPUT_BANDS.html#idm41

```bash
$ cat 06_ZnO_bandspp.pwi 
&BANDS
   prefix      = 'zno'
   outdir      = './TMP'
   filband     = 'ZnO.bands'
/
```

We can run the executable on this input file

```bash
$ mpirun -np 4 bands.x -inp 06_ZnO_bandspp.pwi | tee 06_ZnO_bandspp.pwo
```

In the output the coordinates of the High symmetry points are projected onto a single axis (that will be the x-axis of the band structure plot):

```
     Reading collected, re-writing distributed wavefunctions
     high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   0.0000
     high-symmetry point:  0.5000 0.2887 0.0000   x coordinate   0.5774
     high-symmetry point:  0.6667 0.0000 0.0000   x coordinate   0.9107
     high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   1.5774
     high-symmetry point:  0.0000 0.0000 0.3100   x coordinate   1.8873
     high-symmetry point:  0.5000 0.2887 0.3100   x coordinate   2.4647
     high-symmetry point:  0.6667 0.0000 0.3100   x coordinate   2.7980
     high-symmetry point:  0.0000 0.0000 0.3100   x coordinate   3.4647
     high-symmetry point:  0.5000 0.2887 0.3100   x coordinate   3.4647
     high-symmetry point:  0.5000 0.2887 0.0000   x coordinate   3.7746
     high-symmetry point:  0.6667-0.0000 0.3100   x coordinate   3.7746
     high-symmetry point:  0.6667 0.0000 0.0000   x coordinate   4.0846
```

The code also the provides the symmetry group of each state at each k-point

```
     Band symmetry, C_6v (6mm)  point group:

     e(  1 -  1) =   -114.31739  eV     1   --> A_1            
     e(  2 -  2) =   -114.31689  eV     1   --> B_1            
     e(  3 -  3) =    -68.65571  eV     1   --> B_1            
     e(  4 -  4) =    -68.65320  eV     1   --> A_1            
     e(  5 -  6) =    -68.64739  eV     2   --> E_2            
     e(  7 -  8) =    -68.64663  eV     2   --> E_1            
     e(  9 -  9) =     -9.23315  eV     1   --> A_1            
     e( 10 - 10) =     -8.48490  eV     1   --> B_1            
     e( 11 - 12) =      3.06418  eV     2   --> E_1            
     e( 13 - 13) =      3.09285  eV     1   --> B_1            
     e( 14 - 14) =      3.10865  eV     1   --> A_1            
     e( 15 - 16) =      3.25810  eV     2   --> E_2            
     e( 17 - 18) =      4.25997  eV     2   --> E_1            
     e( 19 - 20) =      4.47396  eV     2   --> E_2            
     e( 21 - 21) =      4.75284  eV     1   --> B_1            
     e( 22 - 23) =      8.01657  eV     2   --> E_2            
     e( 24 - 24) =      8.72607  eV     1   --> A_1            
     e( 25 - 26) =      8.81753  eV     2   --> E_1            
     e( 27 - 27) =      9.53478  eV     1   --> A_1            
     e( 28 - 28) =     14.00312  eV     1   --> B_1            
     e( 29 - 29) =     16.92275  eV     1   --> B_1            
     e( 30 - 31) =     21.69158  eV     2   --> E_1            
     e( 32 - 32) =     22.75418  eV     1   --> A_1            
     e( 33 - 34) =     22.96345  eV     2   --> E_2            
     e( 35 - 35) =     25.20545  eV     1   --> A_1            
     e( 36 - 37) =     26.91421  eV     2   --> E_1            
     e( 38 - 39) =     28.56120  eV     2   --> E_2            
     e( 40 - 40) =     28.61514  eV     1   --> B_1            
     e( 41 - 41) =     29.95152  eV     1   --> A_1            
     e( 42 - 42) =     31.84882  eV     1   --> B_1            
     e( 43 - 44) =     33.62068  eV     2   --> E_2            
     e( 45 - 45) =     36.23043  eV     1   --> B_1            
     e( 46 - 47) =     37.19386  eV     2   --> E_1            
     e( 48 - 48) =     37.50436  eV     1   --> A_1            
     e( 49 - 50) =     39.89841  eV     2   --> E_2 
```

Finally, if we check out output folder we can see that a gnuplot format bands file have been produced:

```bash
$ ls -ltrh
```

We can plot this file with gnuplot to check the band structure:

```gnuplot
gnuplot> set yrange [-8:4]
gnuplot> set xrange [0:4.0846]
gnuplot> p 'ZnO.bands.gnu' u 1:($2-8.796) w l lw 3
```

