#!/bin/bash

set -e

export IFS='
'
PLAY="https://play.google.com/store/apps/details?id="
FDROID="https://f-droid.org/packages"

echo "My favorite apps"

for foo in `adb shell pm list packages -3 -f`
do
	ID=`echo $foo | cut -d= -f2`

	if curl --silent --fail --head "$FDROID/$ID/" > /dev/null
		then
			URL="$FDROID/$ID/"
			NAME=`curl --silent "$URL" \
				| grep -iPo '(?<=<title>)(.*)(?=</title>)' \
				| sed "s/ | F-Droid.*//"`

	elif curl --silent --fail --head "$PLAY$ID" > /dev/null
	then
			URL="$PLAY$ID&hl=cs"
			NAME=`curl --silent "$URL" \
				| grep -iPo '(?<=<title id="main-title">)(.*)(?=</title>)' \
				| sed "s/ – Aplikace pro Android.*//"`
	else
			URL="https://www.google.com/search?q=$ID%20android"
			NAME=$ID
	fi
echo "* [$NAME]($URL)"
done | sort
