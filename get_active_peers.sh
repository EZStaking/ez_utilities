#!/bin/bash

help()
{
   echo "The easiest and fastest way to get the active peers list."
   echo
   echo "Syntax: bash <(curl -Lfs https://raw.githubusercontent.com/EZStaking/ez_utilities/main/get_active_peers.sh) [OPTIONS] [RPC_NODE]"
   echo "Syntax: ./get_active_peers.sh [OPTIONS] [RPC_NODE]"
   echo
   echo "options:"
   echo -e "  -h\t Print this help and exit"
}

while getopts ":h" option; do
   case $option in
      h)
         help
         exit;;
     \?)
         echo "Error: Invalid option"
         exit;;
   esac
done

if [[ -z $1 ]]; then
  help
  exit
fi

RPC_NODE=$1

curl -s $RPC_NODE/net_info |
  jq -r '.result.peers[] |
    "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr | (split(":")[2]) |select(. != null))" |
    select(. |  match("([0-9]{1,3}[\\.]){3}[0-9]{1,3}"))' |
  paste -sd,
