#!/bin/bash
set -e
if [[ $# -ne 2 ]] ; then
	echo an input file/fmtstring and an output file are required
	exit 1
elif [[ ${2##*.} != mov || -e $2 ]] ; then
	echo the output file should have the extension .mov
	echo and not already exist
	exit 1
fi

nice -n 19 ffmpeg \
	-i "$1" \
	-s 1920x1080 -r 25 \
	-vcodec dnxhd \
	-vf yadif \
	-acodec pcm_s16le \
	-b:v 185M \
	-threads 0 \
	"$2"
