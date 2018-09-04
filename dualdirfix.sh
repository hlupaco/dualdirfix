#!/bin/bash

# NOTE: This is for getting rid of copying issues when you have dir structure like /dir/dir/ with the second level having the same stuff or more than the first level.
# It copies everything from the subdir to the upper one and then removes the subdir. Caution.

for i in $(seq 1 100) ; do
  echo
  echo "Round [$i]"
  for dir in $(find . -maxdepth "${i}" -type d | grep /([a-zA-Z_0-9.-][a-zA-Z_0-9.-]*/)1/* \
                 | sort -u) ; do
    dir=$(echo $dir | rev | cut -d/ -f2- | rev)
    echo
    echo "Dir: $dir"

    for fp in $(ls $dir) ; do
      cp -R $dir/$fp $dir/../$fp
     
    done

    rm -Rf $dir

  done


done
