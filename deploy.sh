#!/bin/bash -e

echo "Source remote git repo:"
source <(curl -s https://raw.githubusercontent.com/MaksymSemenykhin/bash_scripts/master/output.sh)

# Deploy part
print_info "Start deploy part"

# Test
print_info "Start unit && functional test part"
npm run test
