#!/bin/bash
set -e
description='
	You need to supply either one or three parameters:
	An input file (always required), and two output files (optional)
	The output files should have the extension .flac if supplied,
	and if not supplied they will get their name from the input
	file name, together with "_left" and "_right" respectively.
	The input file must exist, but the output files should not.
'
input="$1"
out_l="${2:-${input%%.*}_left.flac}"
out_r="${3:-${input%%.*}_right.flac}"
if [[ $# -eq 2 || $# -gt 3 ||
	${out_l##*.} != flac || ${out_r##*.} != flac ||
	( ! -f $input ) || -e $out_l || -e $out_r ]]
then
	echo "$description"
	exit 1
fi
ffmpeg -i "$input" -vn -acodec flac \
	-map_channel 0.1.0 "$out_l" \
	-map_channel 0.1.1 "$out_r"
