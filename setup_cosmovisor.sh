#!/bin/bash

help()
{
   echo "The easiest and fastest way to configure and install Cosmovisor automatically."
   echo
   echo "Syntax: bash <(curl -Lfs https://raw.githubusercontent.com/EZStaking/ez_utilities/main/setup_cosmovisor.sh) [OPTIONS] [DAEMON_NAME] [DAEMON_HOME]"
   echo "Syntax: ./setup_cosmovisor.sh [OPTIONS] [DAEMON_NAME] [DAEMON_HOME]"
   echo
   echo "options:"
   echo -e "  -h\t Print this help and exit"
   echo -e "  -v latest\t Cosmovisor version"
}

while getopts ":h:v" option; do
   case $option in
      h)
         help
         exit;;
      v)
        VERSION=$OPTARG
        ;;
     \?)
         echo "Error: Invalid option"
         exit;;
   esac
done
shift $((OPTIND-1))

if [[ -z $1 || -z $2 ]]; then
  help
  exit
fi


if [[ -z $VERSION ]]; then
  VERSION="latest"
fi

DAEMON_NAME=$1
DAEMON_HOME=$2

installCosmovisor() {
  go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@${VERSION}
}

setupCosmovisor() {
  echo "export DAEMON_NAME=$DAEMON_NAME" >> $HOME/.profile
  echo "export DAEMON_HOME=$DAEMON_HOME" >> $HOME/.profile
  echo "Cosmovisor configuration added in the .profile file."

  source $HOME/.profile

  mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
  mkdir -p $DAEMON_HOME/cosmovisor/upgrades
  echo "Cosmovisor directories created."

  cp $HOME/go/bin/$DAEMON_NAME $DAEMON_HOME/cosmovisor/genesis/bin
  echo "Cosmovisor binary copied."
  echo ""
}

# @todo: update AND/OR create the service automatically
updateCosmovisorService() {
  echo "Cosmovisor service to update:"

  cat <<EndOfMessage
Environment="DAEMON_NAME=$DAEMON_NAME"
Environment="DAEMON_HOME=$DAEMON_HOME"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
EndOfMessage
}

### MAIN
installCosmovisor
setupCosmovisor
updateCosmovisorService
