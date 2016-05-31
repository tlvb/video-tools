#!/bin/bash
set -e
description='
	Requires three files: one .264 video file (input), one .wav
	(input), and one .mp4 (output). If only supplied with one
	name (with none of the extensions, say "xyz") it will assume
	that all files are based on that name (that is, "xyz.264",
	"xyz.wav", and "xyz.mp4").

	It is also possible supply chapter data with -c chapter_file
	and/or tag (meta) data with -t tag_file

	The input files (which need to exist) will be combined into
	the output file (which needs to not exist)

	CHAPTER FILE FORMAT:
		MP4Box documentation is authorative, but one accepted
		format is for each line, a timestamp, followed by the
		name of the chapter:

		hh:mm:ss:ms chapter foo name
		hh:mm:ss:ms chapter bar name
		...

	TAG FILE FORMAT:
		The tag file format is one tag=value pair per line,
		the value should be put in quotes if it contains
		spaces or any other funny characters.
		Valid tags are, from MP4Box -tag-list:

'$(MP4Box -tag-list|& sed -n '2,${s/^/\t/;p}')
while [[ -n "$*" ]] ; do
	case $1 in
		-t)
			tagopt=-itags
			tagdata=$(sed ':a N;s/\n/:/g;ta' "$2")
			shift
			;;
		-c)
			chapopt=-chap
			chapfile="$2"
			shift
			;;
		*.264)
			video_in="$1"
			;;
		*.wav)
			audio_in="$1"
			;;
		*.mp4)
			film_out="$1"
			;;
		*)
			video_in="${video_in:-$1.264}"
			audio_in="${audio_in:-$1.wav}"
			film_out="${film_out:-$1.mp4}"
			;;
	esac
	shift
done
if	[[ -z $video_in || -z $audio_in || -z $film_out ||
	( ! -f $video_in ) || ( ! -f $audio_in ) || ( -e $film_out ) ]] ;
then
	echo "$description"
	exit 1
fi
echo using video file $video_in
echo using audio file $audio_in
[[ -n $tagopt ]] && echo using metadata tag string $tagdata
[[ -n $chapopt ]] && echo using chapter file $chapfile
echo writing output film to $film_out
tmpdir=$(mktemp -d /tmp/crate_mp4.XXXXXX)
faac -o $tmpdir/converted.aac "$audio_in"
MP4Box -r 25 \
	-add "$video_in" \
	-add $tmpdir/converted.aac \
	-out "$film_out" \
	$tagopt "$tagdata" $chapopt "$chapfile"
rm -rf $tmpdir
