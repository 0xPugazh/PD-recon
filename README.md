# PD-recon
PDrecon is a bash tool that uses [Project Discovery](https://github.com/projectdiscovery) tools for bug bounty reconnaissance.
```
    ____  ____                                
   / __ \/ __ \     ________  _________  ____ 
  / /_/ / / / /    / ___/ _ \/ ___/ __ \/ __ \
 / ____/ /_/ /    / /  /  __/ /__/ /_/ / / / /
/_/   /_____/    /_/   \___/\___/\____/_/ /_/ 
                                  @0xPugazh
```

## Installation
```
git clone https://github.com/0xPugazh/PD-recon
cd PD-recon
chmod +x install.sh PD-recon.sh
./install.sh
```

## Help
```
Usage:
  ./PD-recon.sh [options]

Options:
  -i, --input    Specify the input (domain or CIDR range)
  -h, --help     Display this help menu
```
## Usage 
+ ``./PD-recon.sh --input target.com`` for domain
+ ``./PD-recon.sh --input 192.168.0.0/16`` for cidr ranges

## Acknowledgements
This project utilizes various tools provided by [Project Discovery](https://github.com/projectdiscovery). I would like to express our gratitude to the entire Project Discovery team for their dedication in developing and maintaining these powerful tools.
