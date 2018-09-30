#!/bin/bash 

IP="`ip addr show|grep 'inet'|grep 'global'|cat `"
HOWRAM="`free -m|grep 'Mem'|cat `"
PROC="`cat /proc/cpuinfo|grep processor`"

arrayram=($HOWRAM)
arrayip=($IP)
arrayproc=($PROC)
lastIndexAP=$((${#arrayproc[@]}-1))


varip=$(echo "IP: "${arrayip[1]})
varramz=$(echo "Ilosc Ram (zajete): "${arrayram[2]} "MB")
varramw=$(echo "Ilosc Ram (wolne): "${arrayram[3]} "MB")
varproc=$(echo "Ilosc procesow: "$((${arrayproc[lastIndexAP]}+1)))

if [ -e mail.txt ] 
then
	arraymail=()
	IFS=$'\n' read -d '' -r -a arraymail < mail.txt
	
	if [ "$varip" != "${arraymail[0]}" ] ; then
		echo "$varip" >> zmiany.txt
	fi
	if [ "$varramz" != "${arraymail[1]}" ] ; then
		echo "$varramz" >> zmiany.txt
	fi
	if [ "$varramw" != "${arraymail[2]}" ] ; then
		echo "$varramw" >> zmiany.txt
	fi
	if [ "$varproc" != "${arraymail[3]}" ] ; then
		echo "$varproc" >> zmiany.txt
	fi
	
	if [ -e zmiany.txt ] ; then
		$(mail -s "parametry" "$1" < zmiany.txt)
		$(rm zmiany.txt)
	fi
	
	echo "$varip" > mail.txt
	echo "$varramz" >>mail.txt
	echo "$varramw" >>mail.txt
	echo "$varproc" >>mail.txt
else
	echo "$varip" > mail.txt
	echo "$varramz" >>mail.txt
	echo "$varramw" >>mail.txt
	echo "$varproc" >>mail.txt
	$(mail -s 'parametry' "$1" < mail.txt)
	#mail -s 'parametry' -a mail "$1"
fi
