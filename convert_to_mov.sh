#!/bin/bash
set -e
description='
	You need to supply or two parameters: An input file parameter,
	and optionally an output file parameter. If supplied, the output
	file should have a .mov extension, and if not supplied it will
	be set to the same as the input, but with the extension .mov.
	The output file should not already exist.
'
infile=$1
outfile="${2:-${outfile%%.*}.mov}"
if [[ $# -lt 1 || $# -gt 2 || ${outfile##*.} != mov || -e $outfile ]] ; then
	echo "$description"
	exit 1
fi
nice -n 19 ffmpeg \
	-i "$infile" \
	-s 1920x1080 -r 25 \
	-vcodec dnxhd \
	-vf yadif \
	-acodec pcm_s16le \
	-b:v 185M \
	-threads 0 \
	"$outfile"
