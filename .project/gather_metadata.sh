#! /usr/bin/env bash

set_directory() {
  # if no arguements given, current working directory is selected
  if [ $# -eq 0 ] ; then
    searchDir=./

  # else if 1 is given, that will be the current working directory
  elif [ $# -eq 1 ] ; then
    searchDir="$1"
  fi
}


is_directory() {
  if [[ ! -d "$1" ]]; then
    echo "$1 is not a directory.">&2
    exit 1
  fi
}

permission_check() {
  if [[ ! -r "$1" || ! -x "$1" ]]; then
    echo "$1 is not readable or executable.">&2
    exit 1
  fi
}

find_image() {
  find "$1" \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.tif" -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.gif" \)
}

create_thumbnails() {
  # get the width and height using identify and delimiting using spaces (cut),
  # getting the 3rd section of identify then delimiting again with the x, and storing the width and height into variables
  Side_1=$(identify "$1"  | cut -d" " -f"3" | cut -d'x' -f"1")
  Side_2=$(identify "$1"  | cut -d" " -f"3" | cut -d'x' -f"2")

  # determine which one (width or height) is longer, store it in long_side
  if [ $Side_1 -ge $Side_2 ] ; then
    long_side=$Side_1

  else
    long_side=$Side_2
  fi


  # check if long_side is smaller than 128, 
  # elif smaller than 256, smaller than 512, or larger,
  # and make thumbnails for those sizes

  
}