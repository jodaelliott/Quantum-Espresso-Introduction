
# Getting Started with <code>pw.x</code>

## New commands

| Command | Key Options | Description |
| ------- | ----------- | ----------- |
| <b>QE</b> |  |  |
<code>pw.x</code> | <code>-inp</code> <code>-npools</code> | Main executable for DFT in Quantum ESPRESSO |

## Introduction to X-Ray Spectroscopy in Quantum ESPRESSO

## The <code>pw.x</code> Input File

The first Namelist is <code>&CONTROL</code>, which deals with <em>administrative</em>
variables

    &CONTROL
       calculation = '' ! The type of job requested
       prefix      = '' ! The name of the files created
       outdir      = '' ! Where metadata is stored
       psuedodir   = '' ! The location of the pseudopotentials
       verbosity   = '' ! How detailed is the output from the code
    /

The second Namelist is the <code>&SYSTEM</code>, which describes the material being
calculated.

    &SYSTEM
       ibrav = ! index of the bravais lattice
    /

## The <code>pw.x</code> Output File

## Pseudopotentials

## Basis set optimization

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
