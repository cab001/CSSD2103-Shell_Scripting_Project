#! /usr/bin/env bash

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
  find "$1" \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.tif" -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.gif" \)
}