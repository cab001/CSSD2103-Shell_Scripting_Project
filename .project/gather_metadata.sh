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

  # in the directory the img is found in, create .thumbs directory if it doesnt exist yet
  if [ ! -a .thumbs ] ; then
    mkdir .thumbs
  fi

  # in the dir the img is found in, create .metadata if it doesnt exist yet
  if [ ! -a .metadata ] ; then
    mkdir .metadata
  fi

  # get the width and height using identify and delimiting using spaces (cut),
  # getting the 3rd section of identify then delimiting again with the x, and storing the width and height into variables
  Side_1=$(identify "$image"  | cut -d" " -f"3" | cut -d'x' -f"1")
  Side_2=$(identify "$image"  | cut -d" " -f"3" | cut -d'x' -f"2")

  # determine which one (width or height) is longer, store it in long_side
  if [ $Side_1 -ge $Side_2 ] ; then
    long_side=$Side_1

  else
    long_side=$Side_2
  fi


  # check if long_side is greater than 128, 
  # elif greater than 256, greater than 512,
  # and make thumbnails for those sizes

  cd .thumbs

  # for this, we need to put the image file name into the $image var
  if [ $long_side -ge 128 ] ; then
    convert "$image" -resize 128x128 "$(echo $image | cut -d"." -f"1,2" --output-delimiter="-128.")"
  fi
  if [ $long_side -ge 256 ] ; then
    convert "$image" -resize 256x256 "$(echo $image | cut -d"." -f"1,2" --output-delimiter="-256.")"
  fi
  if [ $long_side -ge 512 ] ; then
    convert "$image" -resize 512x512 "$(echo $image | cut -d"." -f"1,2" --output-delimiter="-512.")"
  fi


  # going back to the directory the original img is in
  cd ..

  # creating the metadata file for the given image
  identify -verbose $image > .metadata/"$image".txt

}