# Nielsnlamf's Vim configuration

# System-wide required packages
system_packages=(git node npm pip3 python3 vim)

# pip linting packages put into ~/.local
pip_packages=(pylint)

# npm linting packages put into ~/.local
npm_packages=(
    bash-language-server@latest
    eslint@latest
    eslint-plugin-react@latest
    eslint-plugin-vue@latest
    instant-markdown-d@latest
    prettier@latest
)

# vim plugins to install in ~/.vim/pack/plugins/start
vim_plugins=(
    junegunn/fzf
    junegunn/fzf.vim
    laggardkernel/vim-one
    lambdalisue/reword.vim
    mbbill/undotree
    "neoclide/coc.nvim release"
    pangloss/vim-javascript
    RRethy/vim-illuminate
    suan/vim-instant-markdown
    tpope/vim-fugitive
    vim-airline/vim-airline
)

# coc plugin with extensions installed using npm into ~/.config/coc/extensions
coc_packages=(
    coc-syntax@latest
    coc-snippets@latest
    coc-prettier@latest
    coc-html@latest
    coc-highlight@latest
    coc-git@latest
    coc-eslint@latest
    coc-diagnostic@latest
    coc-yaml@latest
    coc-react-refactor@latest
    coc-pyright@latest
    coc-markdownlint@latest
    coc-json@latest
    coc-docker@latest
    coc-css@latest
)

# show fancy titles for installation steps
title() { echo -e "\n\x1b[31m === \x1b[31m$1\x1b[0m\n"; }
subtitle() { echo -e "\n\x1b[31m - \x1b[33m$1\x1b[0m\n"; }

# clone and update a plugin in the vim/pack directory
plugin() {
    subtitle "$1"
    mkdir -p ~/.vim/pack/plugins/start
    cd ~/.vim/pack/plugins/start
    if [ ! -d $(basename $1) ];then
        git clone https://github.com/$1
    fi
    cd $(basename $1)
    git checkout $2
    git pull --all
}

setup() {
    title "Nielsnlamf's Vim installation script"
    echo "See https://github.com/Nielsnlamf/vimrc for info and updates"
    subtitle "Check required system software"
    for software in ${system_packages[@]};do
        which $software
        if [ $? == 1 ];then
            echo $software should be installed on your system
            exit
        fi
    done
    if [[ $1 = 'clean' ]];then
        rm -rf ~/.vim/spell/ ~/.vim/pack/ ~/.vim/vimrc ~/.vim/coc-settings.json ~/.config/coc
    fi
    subtitle "Copy config files"
    mkdir -p ~/.vim/spell/
    cd $(dirname $(realpath $0))
    cp .eslintrc.json ~
    cp vimrc ~/.vim/vimrc
    if [[ $1 = 'config-only' ]];then
        title "Done"
        exit
    fi

    title "Install/update linters and parsers"
    subtitle "Pip packages"
    pip3 install --user -U ${pip_packages[@]}
    subtitle "Npm packages"
    npm config set prefix "~/.local"
    npm --loglevel=error i --force --no-audit --no-fund -g ${npm_packages[@]}
    
    title "Install/update Vim plugins"
    for plug in "${vim_plugins[@]}";do
        plugin $plug
    done

    title "Install/update CoC extensions"
    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc
    echo '{"coc-eslint|global": {eslintAlwaysAllowExecution": true}}' > memos.json
    cd ~/.config/coc/extensions
    # start workaround
    git clone https://github.com/fannheyward/coc-eslint
    cd coc-eslint
    git checkout feat/eslint-8
    npm i --force 
    npm run build
    cd ..
    # end workaround
    echo '{"dependencies":{}}' > package.json
    npm --loglevel=error i --force --ignore-scripts --no-package-lock --only=prod --no-audit --no-fund ${coc_packages[@]}
    for package in "${coc_packages[@]}";do
        cd ~/.config/coc/extensions/node_modules/${package%%@*}
        npm --loglevel=error i --force --ignore-scripts --only=prod --no-audit --no-fund
    done

    title "Install onehalfdark theme"
    cd ~/.vim/pack/plugins/start
    git clone https://github.com/sonph/onehalf.git && cd onehalf
    mv vim  ~/.vim/pack/plugins/start/onehalfdark
    cd .. && rm -r -f onehalf

    title "Done"
}

# start the setup if called as a script
$(return >/dev/null 2>&1)
if [ $? != 0 ];then
    setup $1
fi
