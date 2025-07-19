FROM mcr.microsoft.com/devcontainers/base:1-bookworm

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
    fish \
    build-essential autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev rustc && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install asdf
RUN curl -L 'https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-amd64.tar.gz' | tar -xz -C /usr/local/bin && \
    mkdir -p /home/vscode/.config/fish/conf.d && \
    curl -L 'https://raw.githubusercontent.com/asdf-vm/asdf/refs/tags/v0.18.0/asdf.fish' > /home/vscode/.config/fish/conf.d/asdf.fish && \
    chown -R vscode:vscode /home/vscode/.config

# Install asdf plugins and specified runtimes
USER vscode
WORKDIR /home/vscode
COPY --chown=vscode:vscode .tool-versions /home/vscode/.tool-versions
RUN asdf plugin add ruby && \
    asdf install && \
    asdf reshim
