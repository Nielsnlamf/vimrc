# Nielsnlamf's Vim configuration

# load all package lists and functions from within the install.sh script
source ./install.sh

# ask if package should be removed
ask_removal() {
    subtitle $2
    read -p "Do you want to uninstall $2 using $1? [y/N] " uninstall
    case $uninstall in [Yy]|[Yy][Ee][Ss])
        if [ $1 == "pip3" ];then
            $1 uninstall -y $2
        fi
        if [ $1 == "npm" ];then
            $1 uninstall -g `echo $2 | cut -d "@" -f 1`
        fi
    esac
}

title "Uninstall Vim Configuration"
read -p "This will delete all Vim configuration, continue? [y/N] " uninstall
case $uninstall in [Yy]|[Yy][Ee][Ss])
    title "Deleting vimrc, vim plugins, eslintrc and coc packages completely..."
    rm -rf ~/.vim/ ~/.config/coc/ ~/.eslintrc.json
    title "Ask for individual package removal"
    for package in ${pip_packages[@]};do
        ask_removal pip3 $package
    done
    npm config set prefix "~/.local"
    for package in ${npm_packages[@]};do
        ask_removal npm $package
    done
esac
