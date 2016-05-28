set -e
if [[ $# -ne 3 ]] ; then
	echo needs an input file and two output file names
	exit
elif [[ ${2##*.} != flac || ${3##*.} != flac || -e $2 || -e $3 ]] ; then
	echo the output files names should have the extension .flac
	echo and should not already exist
	exit 1
fi
ffmpeg -i "$1" -vn -acodec flac -map_channel 0.1.0 "$2" -map_channel 0.1.1 "$3"
