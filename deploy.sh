#!/bin/sh

vared -p "Enter commit message: " -c message

printf "\e[33m\n\nPushing latest changes to mithun.tech repository...\e[39m\n\n"
git status
git add .
git status
git commit -m "$message"
git push origin master
printf "\033[0;32m\nSuccessfully pushed changes to mithun.tech repository!\e[39m\n"

printf "\e[33m\nBuilding project...\e[39m\n"
hugo -d ../tech-mithun.github.io

printf "\\e[33m\nPushing to tech-mithun.github.io repository...\e[39m\n\n"
cd ../tech-mithun.github.io
git status
git add .
git status
git commit -m "$message"
git push origin master
printf "\e[32m\nSuccessfully deployed the website!\e[39m"


