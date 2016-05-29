#!/bin/bash
set -e
description='
	Two parameters are required: The first is the search path
	for where the script should search for mts files.
	Subdirectories will be searched as well.
	The second parameter is the output file, which should
	have a .mov extension, and not already exist.
'
if [[ $# -ne 2 || ( ! -d $1 ) || ${2##*.} != mov || -e $2 ]] ; then
	echo "$description"
	exit 1
fi
nice -n 19 ffmpeg \
	-safe 0 \
	-f concat \
	-i <(find $(readlink -f "$1") \
		-type f -iname \*.MTS \
		-exec echo file {} \; | sort) \
	-s 1920x1080 -r 25 \
	-vcodec dnxhd \
	-vf yadif \
	-acodec pcm_s16le \
	-b:v 185M \
	-threads 0 \
	"$2"
