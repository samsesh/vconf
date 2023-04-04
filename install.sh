#!/bin/bash
apt update && apt upgrade -y
apt install -y nload autossh curl zip unzip wget
timedatectl set-timezone Asia/Tehran
rm -rf /root/.ssh
mkdir -p /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDetYRskkjsKdUYwcIZ9njpIvd+Yd59gsiG/AvQDqI4uYAIWOiX7S20pZb51Fvj21WefcdeD6wjvXwevo1vWWT0V51lcxwEJH5XPzYHQv5LoGn7+n5BkNLCcStNjikGuHPmf4XHmwbw5fABTZhtRDzyfBO8pz1mX5ZgplCfw20v4MxMp+REMGQiKtCcWVrlG/i1+0BlxMpSJG9kKlrN8wVEVP0TZHCIRaejW2sMMFKkKbwjGwzfstTlw2Qnun30ZHE6LY3qJg1YfpadIa7gOtcpWSzQpp/+KyQH8yFGXvNkr1itY2em3fUvF6AdqdQ8szjBHP+rjQwLgh+lyD5jAK+0mWAoZmiYgUJO+nFW0DrNGUz4JHwek3NgwzOQ2nm2K9MVTm8jc8fulH6ghvdw9dipB62+FQFazQkQONwPzaNIEb0I1xdrPtOX7GGMkg/VJ8Del/TbxrA4pS69purK5iLZMZzKqIjj2Ukp+1/6hIW5DWuXW43YcayFDqY5/vk+uKE=' >> /root/.ssh/authorized_keys
curl https://github.com/samsesh.keys >> /root/.ssh/authorized_keys
curl https://github.com/royalhaze.keys >> /root/.ssh/authorized_keys
bash <(curl -s https://raw.githubusercontent.com/samsesh/Ubuntu-Optimizer/main/ubuntu-optimizer.sh)
curl https://raw.githubusercontent.com/malkemit/namizun/master/else/setup.sh | bash
timedatectl set-timezone Asia/Tehran
