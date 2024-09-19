FROM ubuntu:latest

ENV HOME /home/dev
WORKDIR /home/dev

RUN apt update && apt install -y software-properties-common && \
    add-apt-repository -y ppa:neovim-ppa/unstable && apt update && \
    apt install -y wget vim curl pkg-config neovim golang fzf ripgrep fd-find && \
    apt install -y zsh ssh gnupg jq && \
    bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" && \
    apt install -y clang clang-tools libclang-dev make cmake libc++-dev clangd clang-tidy clang-format && \
    update-alternatives --config cc


RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    go install github.com/jesseduffield/lazygit@latest && \
    apt install -y fonts-font-awesome && \
    apt install -y fonts-firacode && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt update && apt install -y terraform

RUN mkdir -p /home/dev/.vim/colors && \
    curl -o /home/dev/.vim/colors/PaperColor.vim https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim /home/dev/.local/share/nvim/site/pack/packer/start/packer.nvim

COPY .vimrc /home/dev/.vimrc
COPY .tmux.conf /home/dev/.tmux.conf
COPY .config/ /home/dev/.config/

ENV PATH="/home/dev/myapp/bin:$PATH"

SHELL ["/bin/zsh"]

CMD ["/bin/zsh"]
