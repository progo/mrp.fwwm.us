for arg in "$@"
do
	orig=$arg
	dest=`basename "$orig" .flac`.mp3

	title=`taginfo "$orig" | grep TITLE | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	artist=`taginfo "$orig" | grep ARTIST | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	album=`taginfo "$orig"  | grep ALBUM | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	track=`taginfo "$orig"  | grep TRACK | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	year=`taginfo "$orig"  | grep YEAR | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	genre=`taginfo "$orig"  | grep GENRE | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	flac -cd "$orig" | lame --ignore-tag-errors --noreplaygain --add-id3v2 -q 2 -V 2 --ta "$artist" --tl "$album" --tn "$track" --tt "$title" --tg "$genre" --ty "$year" - "$dest"

done

