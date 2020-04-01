#!/bin/bash

set -e

echo "Source remote git repo:"
source <(curl -s https://raw.githubusercontent.com/MaksymSemenykhin/bash_scripts/master/output.sh)

print_info "$(ls -la)"

print_title "NodeJS $(node -v)"
print_title "NPM $(npm -v)"
print_title "Yarn $(yarn -v)"

# Build
print_info "Start build"
yarn install
