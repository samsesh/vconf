#!/bin/bash

check_if_running_as_root() {
    # If you want to run as another user, please modify $EUID to be owned by this user
    if [[ "$EUID" -ne '0' ]]; then
        echo "$(tput setaf 1)Error: You must run this script as root!$(tput sgr0)"
        exit 1
    fi
}

#dns config
dns() {
    # Define the shecan DNS IP addresses here
    new_dns=(178.22.122.100 185.51.200.2)

    # Clear the current DNS entries in the resolv.conf file
    sudo sed -i '/nameserver/d' /etc/resolv.conf

    # Add the new DNS entries to the resolv.conf file
    for dns in "${new_dns[@]}"; do
        echo "nameserver $dns" | sudo tee -a /etc/resolv.conf >/dev/null
    done

    # Restart the network service to apply the changes
    sudo service network-manager restart

    echo "DNS change to shecan"
    sleep 5
    clear
}
dnsone() {
    # Define the shecan DNS IP addresses here
    new_dns=(1.1.1.1 1.0.0.1)

    # Clear the current DNS entries in the resolv.conf file
    sudo sed -i '/nameserver/d' /etc/resolv.conf

    # Add the new DNS entries to the resolv.conf file
    for dns in "${new_dns[@]}"; do
        echo "nameserver $dns" | sudo tee -a /etc/resolv.conf >/dev/null
    done

    # Restart the network service to apply the changes
    sudo service network-manager restart

    echo "DNS change to cloudflare"
    sleep 5
    clear
}

sysup() {
    #update and install ruqerment app and optimazer server
    bash <(curl -s https://raw.githubusercontent.com/samsesh/Ubuntu-Optimizer/main/ubuntu-optimizer.sh)
    sleep 5
    clear
}

dockercheck() {
    #install docker

    # Check if Docker is already installed
    if ! command -v docker &>/dev/null; then
        echo "Docker is not installed on this system. Installing Docker..."

        # Install Docker using the official Docker installation script
        curl -sSL https://get.docker.com | sh

        # Add the current user to the docker group so you can run Docker commands without sudo
        sudo usermod -aG docker $USER

        # Start the Docker service
        sudo service docker start

        echo "Docker has been installed successfully!"
    else
        echo "Docker is already installed on this system."
    fi

    sleep 5
    clear
}

nginxporxymanager() {

    if sudo docker ps -a --format '{{.Names}}' | grep -q nginx-proxy-manager; then
        echo "Nginx Proxy Manager is already installed as a Docker container on this system."
    else
        echo "Nginx Proxy Manager is not installed as a Docker container on this system.start installing"
        # Create a new directory for the Docker Compose project
        sudo mkdir -p /docker/nginx-proxy-manager
        cd /docker/nginx-proxy-manager

        # Create a new Docker Compose file and copy the configuration
        sudo tee docker-compose.yml >/dev/null <<EOF
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
        sudo mkdir -p data

        # Start the Docker Compose project in the background
        sudo docker compose up -d

        echo "Nginx Proxy Manager has been installed successfully!"
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
    echo "ssh keys added"
    sleep 5
    clear
}

namizuntrafik() {
    if command -v namizun &>/dev/null; then
        echo "Namazum is already installed on this system."
    else
        echo "Namazun is not installed on this system. Installing Namazun"
        curl https://raw.githubusercontent.com/malkemit/namizun/master/else/setup.sh | bash
        echo "Namazun has been installed successfully!"
    fi
    sleep 5
    clear
}

#set timezone
timedatectl set-timezone Asia/Tehran

#run
check_if_running_as_root
dns
sysup
dockercheck
sshconf
namizuntrafik
nginxporxymanager
dnsone

echo "vconfiged successfully"
