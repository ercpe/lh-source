#!/bin/bash
# extract - extract common file formats
# Author: Gen2ly
# Author: jlec

# Text color variables
TXTBLD=$(tput bold)     # Bold
TXTUND=$(tput sgr 0 1)  # Underline
TXTRED=$(tput setaf 1)  # Red
TXTGRN=$(tput setaf 2)  # Green
TXTYLW=$(tput setaf 3)  # Yellow
TXTBLU=$(tput setaf 4)  # Blue
TXTPUR=$(tput setaf 5)  # Purple
TXTCYN=$(tput setaf 6)  # Cyan
TXTWHT=$(tput setaf 7)  # White
TXTRST=$(tput sgr0)     # Reset

# Usage - display full argument if isn't given.
if [[ -z "$@" ]]; then
  echo " extract <compressed-file.ext> <*location> - extracts common file formats"
  exit; else
  if [ -f $1 ]; then
    echo " Extracting ${TXTBLD}${TXTRED}$1${TXTRST}"
    case $1 in
      *.7z)       7z x $1              ;;
      *.tar)      if [ -z $2 ]; then
                    tar xvf $1; else
                    tar xvf $1 -C $2
                  fi                   ;;
      *.tar.bz2)  if [ -z $2 ]; then
                    tar xvjf $1; else
                    tar xvjf $1 -C $2
                  fi                   ;;
      *.tbz2)     if [ -z $2 ]; then
                    tar xvjf $1; else
                    tar xvjf $1 -C $2
                  fi                   ;;
      *.tar.gz)   if [ -z $2 ]; then
                    tar xvzf $1; else
                    tar xvzf $1 -C $2  
                  fi                   ;;
      *.tgz)      if [ -z $2 ]; then
                    tar xvzf $1; else
                    tar xvzf $1 -C $2    
                  fi   ;;
      *.tar.xz)   if [ -z $2 ]; then
                    tar xvJf $1; else
                    tar xvJf $1 -C $2  
                  fi                   ;;
      *.txz)      if [ -z $2 ]; then
                    tar xvJf $1; else
                    tar xvJf $1 -C $2    
                  fi   ;;
      *.rar)      7z x $1              ;;
      *.zip)      unzip $1             ;;
      *.Z)        uncompress $1        ;;
      *.bz2)      bunzip2 $1           ;;
      *.gz)       gunzip $1            ;;
      *)          echo "${TXTBLD}${TXTGRN} * ${TXTRST}Not a supported file format." ;;
    esac
  fi
fi
