#!/bin/bash

help()
{
   echo "The easiest and fastest way to run a script directly from Github."
   echo
   echo "Syntax: bash <(curl -Lfs https://raw.githubusercontent.com/EZStaking/ez_utilities/main/run_script.sh) [OPTIONS] [FILE]"
   echo "Syntax: ./run_script.sh [OPTIONS] [FILE]"
   echo
   echo "options:"
   echo -e "  -h\t\t Print this help and exit"

   echo -e "  -u EZStaking\t Github User"
   echo -e "  \t\t   EZStaking (default)"

   echo -e "  -r ez_utilities\t Github Repository"
   echo -e "  \t\t   ez_utilities (default)"

   echo -e "  -b main\t Github branch"
   echo -e "  \t\t   main (default)"
}

while getopts ":h:u:r:b:" option; do
   case $option in
      h)
         help
         exit;;
      u)
        USER_REPOSITORY=$OPTARG
        ;;
      r)
        REPOSITORY=$OPTARG
        ;;
      b)
        BRANCH=$OPTARG
        ;;
     \?)
       echo "Error: Invalid option"
       exit;;
   esac
done
shift $((OPTIND-1))

if [[ -z $1 ]]; then
  help
  exit
fi

FILE=$1

if [[ -z $USER_REPOSITORY ]]; then
  USER_REPOSITORY=EZStaking
fi

if [[ -z $REPOSITORY ]]; then
  REPOSITORY=ez_utilities
fi

if [[ -z $BRANCH ]]; then
  BRANCH=main
fi

bash <(curl -Lfs https://raw.githubusercontent.com/$USER_REPOSITORY/$REPOSITORY/$BRANCH/$FILE)
