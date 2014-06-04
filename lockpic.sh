#!/bin/bash

get_last(){
	ls -1 $picfldr/ | grep .txt | sort -n | tail -1 | cut -d. -f1
}

calc(){
	python -c "print $1"
}

cp_dropbox() {
	if [[ ! -z $droplockfldr ]]; then
		cp $1 $droplockfldr
	fi
}

take_pic(){
	cd $picfldr
	now=$(date +%s)

	# Take a photo
	streamer -f jpeg -o $now.jpeg -s 1280x720 >> /dev/null 2>&1
	cp_dropbox $now.jpeg


	#Check whether to add caption
	prev=$(get_last)
	if [[ -z $prev ]]; then 
		zenity --entry --text "What did you do today?" --title "DayLog" >> $now.txt
		cp_dropbox $now.txt
	else
		sub=$(calc "$now - $prev")
		if [[ $sub -ge 86400 ]]; then 
			zenity --entry --text "What did you do today?" --title "DayLog" >> $now.txt
			cp_dropbox $now.txt
		fi
	fi

	cd - >> /dev/null 2>&1
}

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" | ( while true; do read X; if echo $X | grep "boolean false" &> /dev/null; then take_pic; fi done )