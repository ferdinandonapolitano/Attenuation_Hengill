#!/bin/bash

for dep in `cat Pollino3D.txt | awk '{print $1}' | uniq`
do
echo "print $dep" 
done
