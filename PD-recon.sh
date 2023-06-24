#!/bin/bash

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD="\e[1m"
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define paths to tools
SUBFINDER_PATH="$HOME/.pdtm/go/bin/subfinder"
SHUFFLEDNS_PATH="$HOME/.pdtm/go/bin/shuffledns"
CHAOS_PATH="$HOME/.pdtm/go/bin/chaos"
ALTERX_PATH="$HOME/.pdtm/go/bin/alterx"
DNSX_PATH="$HOME/.pdtm/go/bin/dnsx"
NAABU_PATH="$HOME/.pdtm/go/bin/naabu"
HTTPX_PATH="$HOME/.pdtm/go/bin/httpx"
KATANA_PATH="$HOME/.pdtm/go/bin/katana"
NUCLEI_PATH="$HOME/.pdtm/go/bin/nuclei"
MAPCIDR_PATH="$HOME/.pdtm/go/bin/mapcidr"

print_banner() {
  echo -e "${CYAN}${BOLD}"
  echo -e "    ____  ____                                "
  echo -e "   / __ \/ __ \     ________  _________  ____ "
  echo -e "  / /_/ / / / /    / ___/ _ \/ ___/ __ \/ __ \\"
  echo -e " / ____/ /_/ /    / /  /  __/ /__/ /_/ / / / /"
  echo -e "/_/   /_____/    /_/   \___/\___/\____/_/ /_/ "
  echo -e "						                                    "                                  
  echo -e "					                              @0xPugazh"
  echo -e "${NC}"
}

# Spinner function
spinner() {
  local pid=$1
  local delay=0.15
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

show_help() {
  print_banner
  echo -e "${GREEN}Usage:${NC}"
  echo -e "  $0 [options]"
  echo
  echo -e "${GREEN}Options:${NC}"
  echo -e "  -i, --input    Specify the input (domain or CIDR range)"
  echo -e "  -h, --help     Display this help menu"
  echo
}

create_directory() {
  dir_name="$1"
  mkdir -p "$dir_name"
}


run_subfinder() {
  domain="$1"
  output_dir="$2"
  echo -e "${YELLOW}Running Subfinder${NC}"
  $SUBFINDER_PATH -d "$domain" -all -silent -o "$output_dir/subfinder" &
  spinner $!
  echo -e "${GREEN}Subfinder completed.${NC}"
}

run_shuffledns() {
  domain="$1"
  wordlist="$2"
  resolvers="$3"
  output_dir="$4"
  echo -e "${YELLOW}Running Shuffledns${NC}"
  $SHUFFLEDNS_PATH -d "$domain" -w "$wordlist" -r "$resolvers" -silent -o "$output_dir/shuffledns" &
  spinner $!
  echo -e "${GREEN}Shuffledns completed.${NC}"
}

run_chaos() {
  domain="$1"
  api_key="$2"
  output_dir="$3"
  echo -e "${YELLOW}Running Chaos${NC}"
  $CHAOS_PATH -d "$domain" -key "$api_key" -silent -o "$output_dir/chaos" &
  spinner $!
  echo -e "${GREEN}Chaos completed.${NC}"
}

run_dnsx() {
  domain="$1"
  wordlist="$2"
  output_dir="$3"
  echo -e "${YELLOW}Running Dnsx${NC}"
  $DNSX_PATH -l "$domain" -w "$wordlist" -silent -o "$output_dir/dnsx" &
  spinner $!
  echo -e "${GREEN}Dnsx completed.${NC}"
}

run_alterx() {
  input_file="$1"
  output_dir="$2"
  echo -e "${YELLOW}Running Alterx${NC}"
  cat "$input_file" | $ALTERX_PATH -silent -o "$output_dir/alterx" &
  spinner $!
  echo -e "${GREEN}Alterx completed.${NC}"
}

run_naabu() {
  input_file="$1"
  output_dir="$2"
  echo -e "${YELLOW}Running Naabu${NC}"
  $NAABU_PATH -list "$input_file" -port 0-65535 -silent -o "$output_dir/naabu" &
  spinner $!
  echo -e "${GREEN}Naabu completed.${NC}"
}

run_httpx() {
  input_file="$1"
  output_dir="$2"
  echo -e "${YELLOW}Running Httpx${NC}"
  $HTTPX_PATH -l "$input_file" -silent -o "$output_dir/httpx" &
  spinner $!
  echo -e "${GREEN}Httpx completed.${NC}"
}

run_katana() {
  input_file="$1"
  output_dir="$2"
  echo -e "${YELLOW}Running Katana${NC}"
  $KATANA_PATH -list "$input_file" -jc -silent -o "$output_dir/katana" &
  spinner $!
  echo -e "${GREEN}Katana completed.${NC}"
}

run_nuclei() {
  input_file="$1"
  nuclei_templates="$2"
  output_dir="$3"
  echo -e "${YELLOW}Running Nuclei${NC}"
  $NUCLEI_PATH -l "$input_file" -t "$nuclei_templates" -silent -o "$output_dir/nuclei" &
  spinner $!
  echo -e "${GREEN}Nuclei completed.${NC}"
}

run_mapcidr() {
  input="$1"
  output_dir="$2"
  echo -e "${YELLOW}Running Mapcidr${NC}"
  $MAPCIDR_PATH -cidr "$input" -silent -o "$output_dir/mapcidr" &
  spinner $!
  echo -e "${GREEN}Mapcidr completed.${NC}"
}

# Check if no arguments are provided
if [[ $# -eq 0 ]]; then
  show_help
  exit 1
fi

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -i|--input) input="$2"; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) echo -e "${BLUE}Unknown parameter passed: $1${NC}"; exit 1 ;;
  esac
  shift
done

# Set up the directory
output_dir="$input-$(date +%Y%m%d%H%M%S)"
create_directory "$output_dir"

print_banner

# Run appropriate recon based on input type
if [[ $input == */* ]]; then
  run_mapcidr "$input" "$output_dir"
  run_naabu "$output_dir/mapcidr" "$output_dir"
  run_httpx "$output_dir/mapcidr" "$output_dir"
  run_katana "$output_dir/mapcidr" "$output_dir"
  run_nuclei "$output_dir/mapcidr" "$nuclei_templates" "$output_dir"
else
run_subfinder "$input" "$output_dir"
  run_shuffledns "$input" "$wordlist" "$resolvers" "$output_dir"
  run_chaos "$input" "$api_key" "$output_dir"
  run_alterx "$input" "$output_dir"
  run_dnsx "$input" "$wordlist" "$output_dir"
  run_naabu "$input" "$output_dir"
  run_httpx "$input" "$output_dir"
  run_katana "$input" "$output_dir"
  run_nuclei "$input" "$nuclei_templates" "$output_dir"
fi

echo -e "${GREEN}Recon completed! Results are saved in: $output_dir${NC}"

