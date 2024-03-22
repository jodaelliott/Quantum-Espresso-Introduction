#!/bin/bash

mkdir script_folder
cd script_folder
ls

sed s/Red/Blue/g ../littleRedRidingHood.txt > ./littleBlueRidingHood.txt

ls -ltrh
grep -e Red -e Blue ./littleBlueRidingHood.txt

cd ..
