#!/bin/bash

read -e -p "Enter photos directory: " fldr
read -e -p "Enter dropbox directory: " dropboxfldr

if [ -z $fldr ]; then
	exit
fi

if echo $fldr | grep "~" >> /dev/null; then
	fldr=$HOME"$(echo $fldr| tr -d '~')"
fi

if echo $dropboxfldr | grep "~" >> /dev/null; then
	dropboxfldr=$HOME"$(echo $dropboxfldr| tr -d '~')"
fi

if [ ! -d "$fldr" ]; then 
	mkdir $fldr
fi

if [ ! -d "$dropboxfldr" ]; then 
	mkdir $dropboxfldr
fi

if [ ! -d "$HOME/bin" ]; then
	mkdir $HOME/bin
fi

cd $HOME/bin
wget -q https://raw.githubusercontent.com/vthurimella/Lockpic/master/lockpic.sh
mv lockpic.sh lockpic
chmod +x lockpic

if ! echo $PATH | grep "$HOME/bin" >> /dev/null;  then 
	echo "PATH=\$PATH:$HOME/bin" >> $HOME/.bashrc
fi

sed -i "3i dropboxfldr="$dropboxfldr $HOME/bin/lockpic
sed -i "3i picfldr="$fldr $HOME/bin/lockpic

echo "lockpic &" >> .profile

cd - >> /dev/null 2>&1
