#!/bin/bash
infile=$1
shift
trackers="-t ${1:-http://pineappletracker.no-ip.org:6969/announce}"
shift
if [[ ${infile##*.} != 7z ]] ; then
	echo you probably want to encrypt your file first
	exit 1
fi
for t in "$@" ; do
	trackers="$trackers -t $t"
done
transmission-create -o ${infile%%.*}.torrent $trackers $infile
