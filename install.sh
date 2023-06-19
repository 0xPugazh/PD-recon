#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installation started.${NC}"
echo "Installing pdtm..."
go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
source ~/.bashrc

echo "Installing tools..."
pdtm -i alterx,chaos-client,dnsx,httpx,katana,mapcidr,naabu,nuclei,shuffledns,subfinder
echo -e "${GREEN}Installation finished.${NC}"
