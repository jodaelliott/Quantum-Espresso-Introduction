# Parsing Files
<em>How to quickly get at what you want in the terminal</em>

## Displaying the contents of a file

The <code>cat</code> command will print the entire contents of any file to the terminal window. This provides a quick way to view the entire contents of a file
and lets you scroll back through to find the information you're looking for.  

<code>cat</code> can be particularly useful when trying to find information in small text files, but less effective for larger files.

### Example

<em>Find the size of the basis set requested in the calculation (hint: basis set is defined by keyword <code>ecutwfc</code> in the <code>.pwi</code> file)</em>

    >>> cat pw.pwi
    &CONTROL
      calculation = 'relax'
      prefix      = 'NiFe(CN)6Na2'
      outdir      = './TMP'
      pseudo_dir  = '/home/vol07/scarf1097/ESPRESSO/pslibrary/pbesol/GIPAW_RECON'
      verbosity   = 'high'
    /
    
    &SYSTEM
      ntyp      = 5
      nat       = 16
      ibrav     = 2
      celldm(1) = 19.100
      ecutwfc   = 50
      ecutrho   = 500
      nspin     = 2
      ! nbnd      = 200
      tot_magnetization = 2.
      starting_magnetization(2) = 2.
      nr1 = 100, nr2 = 100, nr3 = 100
      nr1s = 100, nr2s = 100, nr3s = 100
    /

    &ELECTRONS
      startingwfc = 'atomic'
      electron_maxstep = 1000
    /

    &IONS
    /

    ATOMIC_SPECIES
      Fe 56.000 Fe.pbesol-spn-rrkjus_gipaw.1.0.0.UPF
      Ni 22.900 Ni.pbesol-spn-rrkjus_gipaw.1.0.0.UPF
      N 12.000  N.pbesol-n-rrkjus_gipaw.1.0.0.UPF
      C  8.000  C.pbesol-n-rrkjus_gipaw.1.0.0.UPF
      Na 22.900 Na.pbesol-spn-rrkjus_gipaw.1.0.0.UPF

    K_POINTS automatic
      2 2 2 1 1 1 

    ATOMIC_POSITIONS crystal
      Ni 0.00000000 0.00000000 0.00000000
      Fe 0.50000000 0.50000000 0.50000000
       C 0.69239882 0.30760118 0.30760118
       C 0.30760118 0.69239882 0.30760118
       C 0.30760118 0.30760118 0.69239882
       C 0.69239882 0.69239882 0.30760118 
       C 0.69239882 0.30760118 0.69239882
       C 0.30760118 0.69239882 0.69239882
       N 0.80760118 0.19239882 0.19239882
       N 0.19239882 0.80760118 0.19239882
       N 0.19239882 0.19239882 0.80760118
       N 0.19239882 0.80760118 0.80760118
       N 0.80760118 0.19239882 0.80760118
       N 0.80760118 0.80760118 0.19239882
      Na 0.2500000 0.25000000 0.25000000
      Na 0.7500000 0.75000000 0.75000000
      
<em>Try to locate the number of G-vectors used in the dense grid for the calculation (hint: this is reported in the <code>.pwo</code> 
  file as <code>Dense  grid:</code></em>
  
    >>> cat pw.pwo
    ...
 
 
 A better way to search through longer files is to use the <code>more</code> command, which displays the file in the terminal one page at a time.  
 
 The <code>more</code> command is way of quickly scrolling through a file in the terminal, you can scroll down using <code>ctrl+f</code>
 there is no option to scroll up. This makes <code>more</code> more useful when you are searching for something in a large file.  
 
 Additionally, the <code>less</code> command can be used to look at large files with greater flexibility. <code>less</code> works in the same
 way as <code>more</code>, but allows you to use the arrow keys to scroll up and down one line per at a time and <code>ctrl+f</code> and 
 <code>ctrl+b</code> to scroll up and down one page at a time.
 
 ### Example
 
 <em>Is it easier to use <code>more</code> and <code>less</code> to search for the dense grid information in the calculation</em>
  
     >>>more pw.pwo
     
     >>>less pw.pwo
     
 ___
  
## Peeking the contents of a file

Sometimes we know that the information we're interested in is contained at the top or bottom of the file, or we interested to check on the status of a file that is being updated. For these instances there are the commands <code>head</code>, which prints the first ten lines of a file, and <code>tail</code> which prints the final ten lines of a file.
    
 ### Example
 
     >>>tail pw.pwo
     
     Parallel routines
 
     PWSCF        :   7m31.32s CPU   3m55.45s WALL

 
     This run was terminated on:  15:27:43   9Mar2022            

     =------------------------------------------------------------------------------=
        JOB DONE.
     =------------------------------------------------------------------------------=
    
Both <code>head</code> and <code>tail</code> allow you to manually set the number of lines that are printed using the <code>-n</code> option. For the <code>head</code> command this lets you to print the top N lines

### Example

    >>>head -n 20 pw.pwi
    &CONTROL
      calculation = 'relax'
      prefix      = 'NiFe(CN)6Na2'
      outdir      = './TMP'
      pseudo_dir  = '/home/vol07/scarf1097/ESPRESSO/pslibrary/pbesol/GIPAW_RECON'
      verbosity   = 'high'
    /

    &SYSTEM
       ntyp      = 5
       nat       = 16
       ibrav     = 2
       celldm(1) = 19.100
       ecutwfc   = 50
       
Finally, using pipes <code>|</code> it is possible to stack <code>head</code> and <code>tail</code> (as well as other) commands. A pipe is a way of funnelling the output of one command into the input of another command.

### Example

In the following example we use the <code>cat</code> command to print the entire file, we use a <code>|</code> to pipe the output to the <code>tail</code> command. With <code>tail</code> we choose to print the final 100 lines and use a <code>|</code> to pipe the output to <code>head</code>. Finally the <code>head</code> command prints one line to the terminal.

    >>>cat pw.pwo | tail -n 100 | head -n 1     
    Final energy             =    -976.2374274231 Ry
    
___
    
## Getting to exactly what you want

Everything so far has been about displaying the contents of files in a quick way in the terminal, and we saw in the last example how we could target specific information if we know where they are in the file.  

But, there is a better way to get to the heart of what we are looking for, the <code>grep</code> command. Using <code>grep</code> we can search a file for a specific character pattern and print the line(s) where it appears

### Example

    >>> grep 'Final energy' pw.pwo
    Final energy             =    -976.2374274231 Ry
    
Like before it is possible to use <code>|</code> to direct the output from other commands into the grep and <em>visa versa</em>

    >>>grep 'scf' pw.pwo | tail -n 16
    number of scf cycles    =   6
    estimated scf accuracy    <       0.00001146 Ry
    estimated scf accuracy    <       0.00041130 Ry
    estimated scf accuracy    <       0.00017477 Ry
    estimated scf accuracy    <       0.00054332 Ry
    estimated scf accuracy    <       0.00012149 Ry
    estimated scf accuracy    <       0.00001362 Ry
    estimated scf accuracy    <       0.00000621 Ry
    estimated scf accuracy    <       0.00000496 Ry
    estimated scf accuracy    <       0.00000107 Ry
    estimated scf accuracy    <       0.00000018 Ry
    estimated scf accuracy    <       0.00000006 Ry
    estimated scf accuracy    <       0.00000002 Ry
    estimated scf accuracy    <       0.00000004 Ry
    estimated scf accuracy    <          5.0E-09 Ry
    bfgs converged in   7 scf cycles and   5 bfgs steps
    
The <code>grep</code> command can also be used to print information in the lines preceeding or following a character match using the <code>-B</code> option (before) and the <code>-A</code> option (after). These options are particularly useful in situations where a line we're searching for only has numbers.

### Example

In the input file for Quantum ESPRESSO the k-point grid is denoted across two lines in the file (<em>hint: we can check this with a <code>cat pw.pwo</code></em>). So to quickly obtain the k-point grid if we can <code>grep</code> and print one additinal line:
    
    >>>grep -A 1 'K_POINTS' pw.pwo
    K_POINTS automatic
    2 2 2 1 1 1
    
Finally, it is also possible to search for more than one character expression using the <code>-e</code> option.
    
### Example

In this example we are tracking the number of cycles for the electronic optimization (scf) and geometry optimization (bfgs). However, just a simple grep will print too much data, so we can pipe the output of the first <code>grep</code> to a second, which matches against a common string (in this case number).
    
    >>>grep -e 'bfgs' -e 'scf' pw.pwo | grep 'number'
    number of scf cycles    =   1
    number of bfgs steps    =   0
    number of scf cycles    =   2
    number of bfgs steps    =   1
    number of scf cycles    =   3
    number of bfgs steps    =   1
    number of scf cycles    =   4
    number of bfgs steps    =   2
    number of scf cycles    =   5
    number of bfgs steps    =   3
    number of scf cycles    =   6
    number of bfgs steps    =   4
    
In this case, the order to the <code>grep</code> commands does not make a difference to the output:

    >>>grep 'number' pw.pwo | grep -e 'bfgs' -e 'scf'
    number of scf cycles    =   1
    number of bfgs steps    =   0
    number of scf cycles    =   2
    number of bfgs steps    =   1
    number of scf cycles    =   3
    number of bfgs steps    =   1
    number of scf cycles    =   4
    number of bfgs steps    =   2
    number of scf cycles    =   5
    number of bfgs steps    =   3
    number of scf cycles    =   6
    number of bfgs steps    =   4
