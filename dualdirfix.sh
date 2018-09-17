#!/bin/bash

# NOTE: This is for getting rid of copying issues when you have dir structure like /dir/dir/ with the second level having the same stuff or more than the first level.
# Rework: only proceed if ls of subdir is equal to ls of dir

for i in $(seq 1 100) ; do
  echo
  echo "Round [$i]"
  for path in $(find . -maxdepth "${i}" \
                 | grep '/\([^/][^/]*/\)\1[^/]*$' \
                 | sort -u) ; do
  #for dir in $(find . -maxdepth "${i}" -type d \
  #               | grep '/\([a-zA-Z_0-9\.-][a-zA-Z_0-9\.-]*/\)\1/*' \
  #               | sort -u) ; do
    subdir=$(echo $path | rev | cut -d/ -f2- | rev)
    echo
    echo "Subdir: $subdir"
    subdir_name=$(echo $subdir | rev | cut -d/ -f1 | rev)

    dir=$(echo $path | rev | cut -d/ -f3- | rev)
    echo
    echo "Dir: $dir"

    subdir_ls=$(ls $subdir)
    dir_ls=$(ls $dir | grep -v '^'"$subdir_name"'$')

    if [ "$subdir_ls" != "$dir_ls" ] ; then
      continue
    fi

    for file in $subdir_ls ; do
      # Check file type, so we know whether to add slash in rsync
      if [ -d $subdir/$file ] ; then
        file="$file/"
      fi

      echo rsync -va $subdir/$file $dir/$file
      echo 'Yes? [y/n]'
      read ans
      if [ "$ans" = 'y' ] ; then
        echo "Copying $subdir/$file to $dir/$file..."
        rsync -va $subdir/$file $dir/$file
      fi
     
    done

    echo rm -Rf $subdir
    echo 'Yes? [y/n]'
    read ans
    if [ "$ans" = 'y' ] ; then
      echo "Removing $subdir..."
      rm -Rf $subdir
    fi

  done


done
