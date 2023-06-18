#!/bin/bash

check_if_running_as_root() {
    # If you want to run as another user, please modify $EUID to be owned by this user
    if [[ "$EUID" -ne '0' ]]; then
        echo "$(tput setaf 1)Error: You must run this script as root!$(tput sgr0)"
        exit 1
    else
        echo $(tput setaf 2)vconf starting ...$(tput sgr0)
    fi
}

#dns config
dns() {
    # Define the shecan DNS IP addresses here
    new_dns=(178.22.122.100 185.51.200.2)

    # Clear the current DNS entries in the resolv.conf file
    sed -i '/nameserver/d' /etc/resolv.conf

    # Add the new DNS entries to the resolv.conf file
    for dns in "${new_dns[@]}"; do
        echo "nameserver $dns" | tee -a /etc/resolv.conf >/dev/null
    done

    # Restart the network service to apply the changes
    service network-manager restart

    echo $(tput setaf 2)DNS change to shecan$(tput sgr0)

    sleep 5
    clear
}
dnsone() {
    # Define the shecan DNS IP addresses here
    new_dns=(1.1.1.1 1.0.0.1)

    # Clear the current DNS entries in the resolv.conf file
    sed -i '/nameserver/d' /etc/resolv.conf

    # Add the new DNS entries to the resolv.conf file
    for dns in "${new_dns[@]}"; do
        echo "nameserver $dns" | tee -a /etc/resolv.conf >/dev/null
    done

    # Restart the network service to apply the changes
    service network-manager restart

    echo $(tput setaf 2)DNS change to cloudflare$(tput sgr0)
    sleep 5
    clear
}

sysup() {
    #update and install ruqerment app and optimazer server
    bash <(curl -s https://raw.githubusercontent.com/samsesh/Ubuntu-Optimizer/main/ubuntu-optimizer.sh)
    bash <(curl -fsSL https://github.com/samsesh/gost/raw/master/install.sh) --install
    sleep 5
    clear
}

dockercheck() {
    #install docker

    # Check if Docker is already installed
    if ! command -v docker &>/dev/null; then
        echo $(tput setaf 2)Docker is not installed on this system. Installing Docker...$(tput sgr0)

        # Install Docker using the official Docker installation script
        curl -sSL https://get.docker.com | sh

        # Add the current user to the docker group so you can run Docker commands without sudo
        usermod -aG docker $USER

        # Start the Docker service
        service docker start

        echo $(tput setaf 2)Docker has been installed successfully!$(tput sgr0)
    else
        echo $(tput setaf 2)Docker is already installed on this system.$(tput sgr0)
    fi

    sleep 5
    clear
}

proxydocker(){

    if docker ps -a --format '{{.Names}}' | grep -q proxydocker; then
        echo $(tput setaf 2)proxydocker is already installed as a Docker container on this system.$(tput sgr0)
    else
        echo $(tput setaf 2)proxydocker is not installed as a Docker container on this system.start installing$(tput sgr0)
        docker run --restart unless-stopped -d \
        -p "3128:3128/tcp" \
        -p "1080:1080/tcp" \
        -e "PROXY_LOGIN=vipvpn" \
        -e "PROXY_PASSWORD=vpnvip" \
        -e "PRIMARY_RESOLVER=2001:4860:4860::8888" \
        --name proxydocker \
        tarampampam/3proxy:latest
}
nginxporxymanager() {

    if docker ps -a --format '{{.Names}}' | grep -q nginx-proxy-manager; then
        echo $(tput setaf 2)Nginx Proxy Manager is already installed as a Docker container on this system.$(tput sgr0)
    else
        echo $(tput setaf 2)Nginx Proxy Manager is not installed as a Docker container on this system.start installing$(tput sgr0)
        # Create a new directory for the Docker Compose project
        mkdir -p /docker/nginx-proxy-manager
        cd /docker/nginx-proxy-manager

        # Create a new Docker Compose file and copy the configuration
        tee docker-compose.yml >/dev/null <<EOF
version: "3"

services:
  app:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    volumes:
      - ./data:/config
EOF

        # Create a new directory for the Nginx Proxy Manager configuration files
        mkdir -p data

        # Start the Docker Compose project in the background
        docker compose up -d

        echo $(tput setaf 2)Nginx Proxy Manager has been installed successfully!$(tput sgr0)
    fi
    sleep 5
    clear
}

sshconf() {
    #config ssh keys
    rm -rf /root/.ssh
    mkdir -p /root/.ssh
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDetYRskkjsKdUYwcIZ9njpIvd+Yd59gsiG/AvQDqI4uYAIWOiX7S20pZb51Fvj21WefcdeD6wjvXwevo1vWWT0V51lcxwEJH5XPzYHQv5LoGn7+n5BkNLCcStNjikGuHPmf4XHmwbw5fABTZhtRDzyfBO8pz1mX5ZgplCfw20v4MxMp+REMGQiKtCcWVrlG/i1+0BlxMpSJG9kKlrN8wVEVP0TZHCIRaejW2sMMFKkKbwjGwzfstTlw2Qnun30ZHE6LY3qJg1YfpadIa7gOtcpWSzQpp/+KyQH8yFGXvNkr1itY2em3fUvF6AdqdQ8szjBHP+rjQwLgh+lyD5jAK+0mWAoZmiYgUJO+nFW0DrNGUz4JHwek3NgwzOQ2nm2K9MVTm8jc8fulH6ghvdw9dipB62+FQFazQkQONwPzaNIEb0I1xdrPtOX7GGMkg/VJ8Del/TbxrA4pS69purK5iLZMZzKqIjj2Ukp+1/6hIW5DWuXW43YcayFDqY5/vk+uKE=' >>/root/.ssh/authorized_keys
    curl https://github.com/samsesh.keys >>/root/.ssh/authorized_keys
    curl https://github.com/royalhaze.keys >>/root/.ssh/authorized_keys
    clear
    echo $(tput setaf 2)ssh keys added$(tput sgr0)
    sleep 5
    clear
}

namizuntrafik() {
    if command -v namizun &>/dev/null; then
        echo $(tput setaf 2)Namazum is already installed on this system.$(tput sgr0)
    else
        echo $(tput setaf 2)Namazun is not installed on this system. Installing Namazun$(tput sgr0)
        curl https://raw.githubusercontent.com/malkemit/namizun/master/else/setup.sh | bash
        echo $(tput setaf 2)Namazun has been installed successfully!$(tput sgr0)
    fi
    sleep 5
    clear
}

#set timezone
timedatectl set-timezone Asia/Tehran

#run
check_if_running_as_root
sshconf
sysup
dns
dockercheck
sshconf
#namizuntrafik
proxydocker
nginxporxymanager
dnsone

echo $(tput setaf 2)vconfiged successfully$(tput sgr0)
