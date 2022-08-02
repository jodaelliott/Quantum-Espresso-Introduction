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
 
 ___
 
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
  
