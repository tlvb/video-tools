#!/bin/bash
set -e
video_in=$1
audio_in=$2
film_out=$3
shift 3
if [[ ${video_in##*.} != 264 || ! -f $video_in ]] ; then
	echo an existing .264 video file is required as first argument
	exit 1
elif [[ ${audio_in##*.} != wav || ! -f $audio_in ]] ; then
	echo an existing .wav audio file is required as second argument
	exit 1
elif [[ ${film_out##*.} != mp4 || -e $film_out ]] ; then
	echo a .mp4 file name is required as third argument
	echo and the file should not already exist
	exit 1
fi

a=($@)
for (( i=0; i<$# ; i+=2 )) ; do
	case ${a[$i]} in
		-t)
			tagopt=-itags
			tagdata=$(sed ':a N;s/\n/:/g;ta' ${a[$i+1]})
			;;
		-c)
			chapopt=-chap
			chapfile=${a[$i+1]}
			;;
		*)
			echo unknown option ${a[$i]}
			exit 1
			;;
	esac
done

tmpdir=$(mktemp -d /tmp/crate_mp4.XXXXXX)
faac -o $tmpdir/converted.aac "$audio_in"
MP4Box -r 25 \
	-add "$video_in" \
	-add $tmpdir/converted.aac \
	-out "$film_out" \
	$tagopt "$tagdata" $chapopt "$chapfile"
rm -rf $tmpdir
