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

#Add to startup 
start_loc="$HOME/.config/autostart/lockpic.desktop"

if [[ -f $start_loc ]]; then
	rm $start_loc
fi

echo "[Desktop Entry]" >> $start_loc
echo "Type=Application" >> $start_loc
echo "Exec=$HOME/bin/lockpic &" >> $start_loc
echo "Hidden=false" >> $start_loc
echo "NoDisplay=false" >> $start_loc
echo "X-GNOME-Autostart-enabled=true" >> $start_loc
echo "Name[en_US]=Lockpic" >> $start_loc
echo "Name=Lockpic" >> $start_loc
echo "Comment[en_US]=Lockpic that takes a photo with the webcam everytime a login or unlock of the computer occurs" >> $start_loc
echo "Comment=Lockpic that takes a photo with the webcam everytime a login or unlock of the computer occurs" >> $start_loc

cd - >> /dev/null 2>&1