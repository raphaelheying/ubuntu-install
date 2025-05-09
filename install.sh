#!/bin/bash
set -e

sudo apt update
sudo apt upgrade -y

ubuntu-report send no
apt remove ubuntu-report -y
apt remove apport apport-gtk -y
sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news 2>/dev/null
pro config set apt_news=false

sudo apt install -y zip curl unzip flameshot snapd git btop apache2-utils python3 gnome-tweaks

sudo snap install chromium vlc libreoffice bitwarden spotify pinta xournalpp typora ollama discord gimp
sudo snap install sublime-text --classic
sudo snap install code --classic
sudo snap install phpstorm --classic
sudo snap install datagrip --classic
sudo snap install rider --classic

echo '🚀 Instalando e configurando: docker...'
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo usermod -aG docker ${USER}
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

echo '🚀 Instalando e configurando: chrome...'
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop
cd -

echo '🚀 Instalando e configurando: lazygit...'
cd /tmp
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
mkdir -p ~/.config/lazygit/
touch ~/.config/lazygit/config.yml
cd -

echo '🚀 Instalando e configurando: php...'
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt -y install php8.4 php8.4-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip}
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
rm composer-setup.php

echo '🚀 Instalando e configurando: github cli...'
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh

echo '🚀 Instalando e configurando: fastfetch...'
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update
sudo apt install -y fastfetch

echo '🚀 Instalando e configurando: ulauncher...'
gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176
gpg --export 0xfaf1020699503176 | sudo tee /usr/share/keyrings/ulauncher-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ulauncher-archive-keyring.gpg] http://ppa.launchpad.net/agornostal/ulauncher/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/ulauncher-noble.list
sudo apt update
sudo apt install -y ulauncher

echo '🚀 Instalando e configurando: nvm...'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install --lts

echo '🚀 Instalando e configurando: .net...'
sudo add-apt-repository ppa:dotnet/backports
sudo apt-get update
sudo apt-get install -y dotnet-sdk-9.0 aspnetcore-runtime-9.0 dotnet-runtime-9.0 zlib1g

echo '🚀 Aplicando configurações git...'
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true

echo '🚀 Aplicando configurações docker...'
sudo docker run -d --restart unless-stopped -p "127.0.0.1:3306:3306" --name=mysql8 -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:8.4
sudo docker run -d --restart unless-stopped -p "127.0.0.1:6379:6379" --name=redis redis:7
sudo docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" --name=postgres16 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16

echo '🚀 Instalando e configurando: whatsapp...'
mkdir -p ~/.local/share/applications
cat <<EOF > ~/.local/share/applications/whatsapp-web.desktop
[Desktop Entry]
Name=WhatsApp Web
Exec=chromium --app=https://web.whatsapp.com
Icon=whatsapp
Type=Application
Categories=Network;
StartupWMClass=Chromium
EOF

echo '🚀 Instalando e configurando: todo...'
cat <<EOF > ~/.local/share/applications/microsoft-todo.desktop
[Desktop Entry]
Name=Microsoft To Do
Exec=chromium --app=https://to-do.microsoft.com
Icon=calendar
Type=Application
Categories=Office;
StartupWMClass=Chromium
EOF
