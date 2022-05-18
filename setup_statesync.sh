#!/bin/bash

help()
{
   echo "The easiest and fastest way to configure state-sync."
   echo
   echo "Syntax: bash <(curl -Lfs https://raw.githubusercontent.com/EZStaking/ez_utilities/main/setup_statesync.sh) [OPTIONS] [RPC_NODE] [DAEMON_HOME]"
   echo "Syntax: ./setup_statesync.sh [OPTIONS] [RPC_NODE] [DAEMON_HOME]"
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

if [[ -z $1 || -z $2 ]]; then
  help
  exit
fi

if ! [ -x "$(command -v bc)" ]; then
  echo 'Error: bc is not installed.' >&2
  exit 1
fi

RPC_NODE=$1
DAEMON_HOME=$2
CURRENT_BLOCK_HEIGHT=$(curl -s ${RPC_NODE}/commit | jq -r '.result.signed_header.header.height')

if [[ -z $CURRENT_BLOCK_HEIGHT ]]; then
  echo "Error fetching current block height (node=${RPC_NODE})." >&2
  exit 1
fi

BLOCK_HEIGHT=$(bc <<< "${CURRENT_BLOCK_HEIGHT} - 1000")
TRUST_HASH=$(curl -s $RPC_NODE/commit?height=${BLOCK_HEIGHT} | jq -r '.result.signed_header.commit.block_id.hash')

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$RPC_NODE,$RPC_NODE\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $DAEMON_HOME/config/config.toml
