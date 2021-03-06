#!/bin/bash 

set -e

# input params
BRANCHNAME=$1

# Source functions
echo "Source remote git repo:"
source <(curl -s https://raw.githubusercontent.com/MaksymSemenykhin/bash_scripts/master/output.sh)

# Check input params
if [[ ${BRANCHNAME} =~ ^(dev|master)$ ]]; then
  print_title "Select branch: $BRANCHNAME"
else
  print_error "ERROR. Branch not correct. Script stoped."
fi


# Prereq.
DEPLOY_FOLDER="/var/www/nodes/$BRANCHNAME"
mkdir -p "$DEPLOY_FOLDER"
print_title "Deploy folder: $DEPLOY_FOLDER"

# Prepare config
sed -i s#%ENV%#\'$BRANCHNAME\'#g ./ecosystem.config.js
sed -i s#development#$BRANCHNAME#g ./ecosystem.config.js

print_info "Print ecosystem js file:"
cat ecosystem.config.js

# Deploy part
print_info "Start deploy part"

mkdir -p "$DEPLOY_FOLDER/config"
cp ./config/"$BRANCHNAME".json "$DEPLOY_FOLDER/config/local.config.json"


print_info "Print app config file"
cat "$DEPLOY_FOLDER/config/local.config.json"


print_title "Copy app to $DEPLOY_FOLDER"
cp -r . "$DEPLOY_FOLDER"

#print_info "PM2 version: $(pm2 --version)"
cd "$DEPLOY_FOLDER"
#export NODE_ENV=$BRANCHNAME
#pm2 start

#yes | docker system prune -a

docker build -t "$BRANCHNAME-app-local:latest" . 
docker images

if [[ -f docker-compose.yml ]]; then
    echo "Compose file exist."
else
    echo "ERROR. Compose file not found."
fi

docker-compose up -d

APP_PORT=$(jq -r '.port' ./config/"$BRANCHNAME".json)
sleep 30

echo "Open port check:"
netstat -tlnp | grep "$APP_PORT"

echo "Check $BRANCHNAME-app-local container status:"
docker inspect "$BRANCHNAME-app" 2>&1 | jq -r '.[].State.Status'

# Test
#print_info "Start unit && functional test part"
#npm run test
