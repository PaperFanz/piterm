#!/bin/sh
# inspired largely by z3bra's tutorial on making bar scripts

clock() {
	date '+%H:%M:%S [%Y-%m-%d]'
}

groups() {
	cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
	tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`

	for w in `seq 0 $((cur - 1))`; do line="${line}[-] "; done
	line="${line}%{F#009bef}[~]%{F-}"
	for w in `seq $((cur + 2)) $tot`; do line="${line} [-]"; done

	echo $line
}

# loop to buffer info and output to stdout
while :; do
	buf=""
	buf="${buf}%{c}$(groups)"
	buf="${buf}%{r}$(clock)"

	#print buffer every second
	echo $buf
	sleep 1
done
