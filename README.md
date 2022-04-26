# EZ Staking Utilities

### [run_script.sh](run_script.sh)
````shell
The easiest and fastest way to run a script directly from Github.

Syntax: bash <(curl -Ls https://raw.githubusercontent.com/EZStaking/ez_utilities/main/run_script.sh) [OPTIONS] [FILE]
Syntax: ./run_script.sh [OPTIONS] [FILE]

options:
  -h                Print this help and exit
  -u EZStaking      Github User
                      EZStaking (default)
  -r ez_utilities   Github Repository
                      ez_utilities (default)
  -b main           Github branch
                      main (default)
````

### [setup_cosmovisor.sh](setup_cosmovisor.sh)
````shell
The easiest and fastest way to configure and install Cosmovisor automatically.

Syntax: bash <(curl -Lfs https://raw.githubusercontent.com/EZStaking/ez_utilities/main/setup_cosmovisor.sh) [OPTIONS] [DAEMON_NAME] [DAEMON_HOME]
Syntax: ./setup_cosmovisor.sh [OPTIONS] [DAEMON_NAME] [DAEMON_HOME]

options:
  -h     Print this help and exit
````
