FROM ubuntu:22.04 AS ubuntu-base

# Change bash as default shell instead of sh
SHELL ["/bin/bash", "-c"]

# Install some tools and libraries.
RUN apt-get update && apt-get -y install \
    vim wget curl unzip git \
    gcc g++ 

# install oh my zsh & change theme to af-magic
RUN apt-get update && apt-get -y install zsh 
RUN sh -c "$(wget https://raw.githubusercontent.com/Lisiiii/configurations/ubuntu/oh_my_zsh_install.sh -O -)" \
    sed -i 's/ZSH_THEME=\"[a-z0-9\-]*\"/ZSH_THEME="af-magic"/g' ~/.zshrc \
    echo "setopt nonomatch" >> ~/.zshrc \
    chsh -s /bin/zsh \
    source ~/.zshrc \
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    rm ./zsh-install.sh

RUN chsh root -s /bin/zsh

ENV NVIDIA_VISIBLE_DEVICES all
    
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility