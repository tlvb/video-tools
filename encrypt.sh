#!/bin/bash
description='
	You need to supply a file that should be encrypted.
	The encrypted file will have the same name, but have
	the extension changed to .7z; it should not already
	exist.
'
encrypted_file=${1%%.*}.7z
if [[ $# -ne 1 || -e $encrypted_file ]] ; then
	echo $description
	exit 1
fi
7z -p -mhe -mx9 a "$encrypted_file" "$1"
