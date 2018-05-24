#!/bin/bash

if [ -f $HOME/.gitconfig ]; then
    echo " You already have configurated GIT!";
    echo " Skipping";
    exit 0
fi

clear
iscorrect=0

function traped () {
    echo "\n Finish the process to skip me!"; 
}

trap traped SIGINT

echo " ";
echo " Welcome to this script. It will help you to configure your .gitconfig file.";
echo " You should know, that the script will force you to finish all the process."
echo " ";
echo " Well, let's get started.";
while [ $iscorrect -eq 0 ]; do
    echo " "; 
    read -p " Your name and lastname: " name
    echo " ";
    read -p " Your email: " email
    echo " ";
    
    PS3=' Please, select a text editor: '
    options=("nano (the simplest)" "vim")
    select opt in "${options[@]}"
    do
        case $opt in
            "nano (the simplest)")
                editor="nano"
                break;
                ;;
            "vim")
                editor="vim"
                break;
                ;;
            *) echo invalid option;;
        esac
    done
    echo " ";
    ga="0"
    while [ "$ga" == "0" ]; do
        read -p " Do you want some aliases for git? (y/n)? " gaanswer
        if [[ "$gaanswer" =~ ^([yY][eE][sS]|[yY])+$ ]]
            then
            ga="Yes"
        elif [[ "$gaanswer" =~ ^([nN][oO]|[nN])+$ ]]
            then
            ga="No"
        else
            echo -e " Just write \e[93my\e[0m or \e[93mn\e[0m "
        fi
    done

    echo " ";
    echo " This is your information:";
    echo " ";
    echo -e " Name:       \e[32m$name\e[0m";
    echo -e " Email:      \e[32m$email\e[0m";
    echo -e " Editor:     \e[32m$editor\e[0m";
    echo -e " Git Alias:  \e[32m$ga\e[0m";
    echo " ";

    yn=0
    while [ "$yn" -eq 0 ]; do
        read -p " Is all this information correct? (y/n)? " answer
        if [[ "$answer" =~ ^([yY][eE][sS]|[yY])+$ ]] 
            then
            let iscorrect=iscorrect+1
            let yn=yn+1
        elif [[ "$answer" =~ ^([nN][oO]|[nN])+$ ]]
            then
            let yn=yn+1
            echo " Then, try again";
        else
            echo -e " Just write \e[93my\e[0m or \e[93mn\e[0m "
        fi
    done

done
echo " ";

if [ ! -f $HOME/.gitconfig ]; then
    touch $HOME/.gitconfig
fi

echo " Setting up GIT config"
git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor "$editor"
if [ "$ga" == "Yes" ]; then
    git config --global alias.co "checkout"
    git config --global alias.br "branch"
    git config --global alias.st "status"
    git config --global alias.last "log -1"
fi

echo " ";
echo " Congratulations, your GIT settings are done!";
echo " ";
