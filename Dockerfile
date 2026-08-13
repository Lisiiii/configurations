FROM ubuntu:24.04 AS ubuntu-base

# Change bash as default shell instead of sh
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install system tools and zsh in one layer.
RUN apt-get update && apt-get -y install --no-install-recommends \
    vim \
    wget \
    curl \
    unzip \
    git \
    gcc \
    g++ \
    sudo \
    zsh \
    ca-certificates 

# Create the default non-root user.
# Passwordless sudo is convenient for an interactive development container.
RUN useradd --create-home --shell /bin/zsh --groups sudo developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer \
    && chmod 0440 /etc/sudoers.d/developer

# Install oh-my-zsh and plugins into developer's home directory.
USER developer
WORKDIR /home/developer
ENV HOME=/home/developer
ENV USER=developer

RUN sh -c "$(wget -qO- https://raw.githubusercontent.com/Lisiiii/configurations/ubuntu/oh_my_zsh_install.sh)" \
    && sed -i 's/ZSH_THEME=\"[a-z0-9\-]*\"/ZSH_THEME=\"af-magic\"/g' "$HOME/.zshrc" \
    && echo "setopt nonomatch" >> "$HOME/.zshrc" \
    && sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' "$HOME/.zshrc" \
    && git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" \
    && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Explicitly retain developer as the image's default runtime user.
USER developer
WORKDIR /home/developer