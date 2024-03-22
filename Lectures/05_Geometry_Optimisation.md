# New pw.x keywords in this Lecture

| <b>Command</b>           | <b>Key Options</b>      | <b>Description</b>                                                                                                       |
| ------------------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| <code>calculation</code> | <code>"relax"           | Start a geometry optimisation calculation in quantum espresso                                                            |
|                          | <code>"vc-relax"</code> | Start a variable cell optimisation calculation in quantum espresso                                                       |
| <code>mixing_beta</code> | <code>0.7</code>        | Alter the fraction of the previous density mixed into the current step, can help with convergence.                       |
| <code>&IONS</code>       |                         | Input card required when performing geometry optimisation                                                                |
| <code>&KPOINTS</code>    | <code>{gamma}</code>    | Special $\Gamma$-point only k-point sampling, which can massively speed up calculations since all wavefunctions are real |

# Forces and Stress in (Periodic) DFT Calculations


# Examples in this session

This session aims to build upon our working knowledge of the <code>pw.x</code> package by introducing the concepts and keywords associated with structural optimisation.

Specifically, we will consider three different cases
- <b>CO Molecule</b>
	- Changes that we must make to the <code>pw.x</code> input file to perform geometry optimisation.
	- Where to check for convergence in the output file
- <b>Al(001) surface slab</b>
	- The difference between molecular (aperiodic) and crystal (periodic) relaxation
- <b>As Crystal</b>
	- Changes that we must make to optimise the lattice vectors
	- Crystal optimisation subject to external pressure

As in the previous sessions we will make use of three different terminal windows. Two logged into the SCARF cluster and one that we will leave on the diamond linux environment to visualise the structures and results

Start by logging into SCARF and copying the example to your personal work directory:

```bash
$ ssh myfedid@ui1.scarf.ac.uk
$ cd myfedid
$ cp -r /work4/dls/shared/pwgeometryoptimisation .
```
# Example 1: CO Molecule Relaxation

## Input File

```
&CONTROL
  calculation  = "relax"
  prefix       = "CO",
  pseudo_dir   = "./pseudopotentials"
  outdir       = "./TMP"
/
  
&SYSTEM
  ibrav     = 0,
  nat       = 2,
  ntyp      = 2,
  ecutwfc   = 40.D0,
  ecutrho   = 400.D0,
/
  
&ELECTRONS
  conv_thr    = 1.D-7,
  mixing_beta = 0.7D0,
/
  
&IONS
/
  
CELL_PARAMETERS bohr
12.0  0.0  0.0
 0.0 12.0  0.0
 0.0  0.0 12.0
  
ATOMIC_SPECIES
O  1.00  O.pz-rrkjus.UPF
C  1.00  C.pz-rrkjus.UPF
  
ATOMIC_POSITIONS {bohr}
C  2.256  0.0  0.0
O  0.000  0.0  0.0  0 0 0
  
K_POINTS {Gamma}
```

## How is the output modified, what should we look for

# Example 2 Al(001) Surface Relaxation Example

## Visualise Input

```
&CONTROL
  calculation = "relax",
  pseudo_dir  = "./pseudopotentials"
  prefix      = "Al"
  outdir      = "./TMP"
/
  
&SYSTEM
  ibrav       = 6,
  celldm(1)   = 5.3033D0,
  celldm(3)   = 8.D0,
  nat         = 7,
  ntyp        = 1,
  ecutwfc     = 60.D0,
  occupations = "smearing",
  smearing    = "marzari-vanderbilt",
  degauss     = 0.05D0,
/
  
&ELECTRONS
  conv_thr    = 1.D-6,
  mixing_beta = 0.3D0,
/
  
&IONS
!  bfgs_ndim         = 3,
/
  
ATOMIC_SPECIES
Al  1.0  Al.pz-vbc.UPF
  
ATOMIC_POSITIONS alat
Al   0.5000000      0.5000000     -2.121320
Al   0.0000000      0.0000000     -1.414213
Al   0.5000000      0.5000000     -0.707107
Al   0.0000000      0.0000000      0.000000
Al   0.5000000      0.5000000      0.707107
Al   0.0000000      0.0000000      1.414213
Al   0.5000000      0.5000000      2.121320
  
K_POINTS automatic
 3 3 1 0 0 0
```

## Visualise output

# Example 3 Relaxing the lattice parameter manually

```
 &CONTROL
   calculation   =   "relax",
   restart_mode  = 'from_scratch',
   outdir        = './TMP',
   pseudo_dir    = './pseudopotentials',
   etot_conv_thr = 1.0E-5,
   forc_conv_thr = 1.0D-4,
 /
  
 &SYSTEM
   ibrav        = 0
   A            = 3.70971016
   nat          =  2
   ntyp         =  1
   ecutwfc      =  60.0
   ecutrho      =  600.0
   nbnd         =  9
   occupations  =  'smearing'
   smearing     =  'mv'
   degauss      =  0.005
 /
  
 &ELECTRONS
   conv_thr     =  1.0d-7  ,
 /
  
 &IONS
 /
  
 &CELL
   cell_dynamics = 'bfgs' ,
   press         = 0.00 ,
 /
  
CELL_PARAMETERS alat
 0.58012956  0.00000000  0.81452422
-0.29006459  0.50240689  0.81452422
-0.29006459 -0.50240689  0.81452422
  
ATOMIC_SPECIES
As   74.90000  As.pz-bhs.UPF
  
ATOMIC_POSITIONS crystal
As    0.290010       0.290010       0.290010
As   -0.290010      -0.290010      -0.290010
  
K_POINTS automatic
  4 4 4   1 1 1
```

We have to find out the size of the dense grid used during the calculation. By default, this depends on the kinetic energy cutoff on the plane waves basis set

```
     Dense  grid:     4159 G-vectors     FFT dimensions: (  60,  60,  60)
```

To compute the energy as a function of the lattice parameter on a consistent grid me must expand the cell in multiples of the grid spacing, and manually set the number of grid points within the input file:

In this example, $$\Delta S = \frac{3.70971016}{60}=0.06182850267\ \mathrm{Å}$$ We can create input files with the following parameters

```
   A            = 3.70971016

   nr1  = 60, nr2  = 60, nr3  = 60
   nr1s = 60, nr2s = 60, nr3s = 60

   A            = 3.771538662666667

   nr1  = 61, nr2  = 61, nr3  = 61
   nr1s = 61, nr2s = 61, nr3s = 61
   
   A            = 3.8333671653333337
   
   nr1  = 62, nr2  = 62, nr3  = 62
   nr1s = 62, nr2s = 62, nr3s = 62

   A            = 3.8951956680000004
   
   nr1  = 63, nr2  = 63, nr3  = 63
   nr1s = 63, nr2s = 63, nr3s = 63

   A            = 3.9570241706666667
   
   nr1  = 64, nr2  = 64, nr3  = 64
   nr1s = 64, nr2s = 64, nr3s = 64

   A            = 4.018852673333334
   
   nr1  = 65, nr2  = 65, nr3  = 65
   nr1s = 65, nr2s = 65, nr3s = 65

   A            = 4.080681176000001
   
   nr1  = 66, nr2  = 66, nr3  = 66
   nr1s = 66, nr2s = 66, nr3s = 66
  
```

We can run each of these examples and collect the total energies:

```bash
$ for a in As.*.pwo; do grep ! $a /dev/null | tail -n 1; done
As.3.710.pwo:!    total energy              =     -25.50213841 Ry
As.3.772.pwo:!    total energy              =     -25.50711430 Ry
As.3.833.pwo:!    total energy              =     -25.51108581 Ry
As.3.895.pwo:!    total energy              =     -25.51057633 Ry
As.3.957.pwo:!    total energy              =     -25.50726375 Ry
As.4.019.pwo:!    total energy              =     -25.50149003 Ry
As.4.081.pwo:!    total energy              =     -25.49358205 Ry
As.scf.pwo:!    total energy              =     -25.45147653 Ry
```

We will now fit a quadratic function to the data to determine the location of the minima. 

```bash
$ cat energy_data.dat
3.710     -25.50213841 Ry
3.772     -25.50711430 Ry
3.833     -25.51108581 Ry
3.895     -25.51057633 Ry
3.957     -25.50726375 Ry
```

Fit this data however you like, in this example we will continue to use gnuplot:

```gnuplot
gnuplot> f(x) = a*x**2 + b*x + c
gnuplot> fit f(x) 'energy_data.dat' u 1:2 via a,b,c
...
...
...
Final set of parameters            Asymptotic Standard Error
=======================            ==========================
a               = 0.36945          +/- 0.01474      (3.99%)
b               = -2.85482         +/- 0.1149       (4.023%)
c               = -19.9958         +/- 0.2235       (1.118%)
  
correlation matrix of the fit parameters:
                a      b      c      
a               1.000 
b              -1.000  1.000 
c               1.000 -1.000  1.000
gnuplot>
gnuplot>
gnuplot>p f(x) w l lw 3, 'new_energy.dat' w l lw 3
```

Let us compute the location of the minima, $$ a = \frac{2.85482}{2\times0.36945} = 3.864\ \mathrm{Å} $$

# Example 4 Relaxing the lattice with variable-cell optimisation

```
 &CONTROL
   calculation   =   "vc-relax",
   restart_mode  = 'from_scratch',
   outdir        = './TMP',
   pseudo_dir    = './pseudopotentials',
   etot_conv_thr = 1.0E-5,
   forc_conv_thr = 1.0D-4,
 /
  
 &SYSTEM
   ibrav        = 0
   A            = 3.70971016
   nat          =  2
   ntyp         =  1
   ecutwfc      =  60.0
   ecutrho      =  600.0
   nbnd         =  9
   occupations  =  'smearing'
   smearing     =  'mv'
   degauss      =  0.005
 /
  
 &ELECTRONS
   conv_thr     =  1.0d-7  ,
 /
  
 &IONS
 /
  
 &CELL
   cell_dynamics = 'bfgs' ,
   press         = 0.00 ,
 /
  
CELL_PARAMETERS alat
 0.58012956  0.00000000  0.81452422
-0.29006459  0.50240689  0.81452422
-0.29006459 -0.50240689  0.81452422
  
ATOMIC_SPECIES
As   74.90000  As.pz-bhs.UPF
  
ATOMIC_POSITIONS crystal
As    0.290010       0.290010       0.290010
As   -0.290010      -0.290010      -0.290010
  
K_POINTS automatic
  4 4 4   1 1 1
```

## Same example with external pressure

```
 &CONTROL
   calculation   =   "vc-relax"   ,
   restart_mode  = 'from_scratch' ,
   outdir        = './TMP',
   pseudo_dir    = './pseudopotentials',
   etot_conv_thr = 1.0E-5  ,
   forc_conv_thr = 1.0D-4 ,
   nstep         = 300
 /
 
 &SYSTEM
   ibrav        =   0
   A            =   3.70971016
   nat          =   2
   ntyp         =   1
   ecutwfc      =  60.0
   ecutrho      = 600.0
   nbnd         =   9
   occupations  =  'smearing'
   smearing     =  'mv'
   degauss      =   0.005 
 /
  
 &ELECTRONS
   conv_thr  =  1.0d-7
 /
  
 &IONS
 /
  
 &CELL
   cell_dynamics = 'bfgs'
   press = 500.00
 /
  
CELL_PARAMETERS alat
 0.58012956  0.00000000  0.81452422
-0.29006459  0.50240689  0.81452422
-0.29006459 -0.50240689  0.81452422
  
ATOMIC_SPECIES
As   74.90000  As.pz-bhs.UPF
  
ATOMIC_POSITIONS crystal
As    0.290010       0.290010       0.290010
As   -0.290010      -0.290010      -0.290010
  
K_POINTS automatic
4 4 4   1 1 1
```