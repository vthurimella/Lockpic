#!/bin/bash

now=$(date +%s)
logfldr="/home/vijay/Pictures/DayLog"
dropfldr="/home/vijay/Dropbox/Photos/DayLog"

get_last(){
	ls $logfldr | sort -n | tail -1 | cut -d. -f1
}

calc(){
	python -c "print $1"
}

take_log_pic(){
	cd $logfldr
	zenity --entry --text "What did you do today?" --title "DayLog" >> $now.txt
	streamer -f jpeg -o $now.jpeg -s 1280x720 >> /dev/null 2>&1
	cd - >> /dev/null 2>&1
}

cp_dropbox(){
	cd $logfldr
	cp $now.txt $dropfldr
	cp $now.jpeg $dropfldr
	cd - >> /dev/null 2>&1
}

prev=$(get_last)
if [[ -z $prev ]]; then 
	take_log_pic
	if [[ ! -z $dropfldr ]]; then
		cp_dropbox
	fi

else 
	sub=$(calc "$now - $prev")
	if [[ $sub -ge 86400 ]]; then 
		take_log_pic
		if [[ ! -z $dropfldr ]]; then
			cp_dropbox
		fi
	fi

fi
