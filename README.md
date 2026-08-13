# Develop
## packages
``` bash
# basic develop packages
sudo apt-get install -y \
    build-essential lsb-release gnupg software-properties-common \
    wget curl unzip git zsh \
    gcc g++ gdb make cmake 

## zsh config
``` bash
# install oh my zsh & change theme to af-magic
sh -c "$(wget https://raw.githubusercontent.com/Lisiiii/configurations/ubuntu/oh_my_zsh_install.sh -O -)"

sed -i 's/ZSH_THEME=\"[a-z0-9\-]*\"/ZSH_THEME="af-magic"/g' ~/.zshrc
echo "setopt nonomatch" >> ~/.zshrc

chsh -s /bin/zsh
source ~/.zshrc

sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm ./zsh-install.sh

```


## docker
run docker without sudo
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

set proxy for docker pulling
```bash
sudo mkdir -p /etc/systemd/system/docker.service.d 

sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf

echo -e "[Service]\nEnvironment="HTTP_PROXY=http://127.0.0.1:7890"\n\
Environment="HTTPS_PROXY=http://127.0.0.1:7890"" |\
sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf

sudo systemctl daemon-reload
sudo systemctl restart docker

# you can check
echo "DOCKER ENV"
sudo systemctl show --property=Environment docker
```


## fuck qq login in linux with docker

```bash
# this disable the appearance of "docker0"
# you can `ifconfig` to check this
echo "{\n  \"bridge\": \"none\"\n}" | sudo tee -a /etc/docker/daemon.json
sudo systemctl restart docker

# cancel it
sudo mv /etc/docker/daemon.json /etc/docker/daemon.json.bak

# cancel your cancel
sudo mv /etc/docker/daemon.json.bak /etc/docker/daemon.json
```