#### Rinnakkaisversio tutusta skriptistä. Interaktiivinenkin myös
#### Kysytään ensin laatu

echo "Quality please! [default 0]: "
read quality
if [[ -z $quality ]]
then
	# Laatu jätetty tyhjäksi, se olkoon v0
	quality="0"
fi

buildlist=()
i=0

#### Sitten muodostetaan käännöslistaus argumenteista
for orig in "$@"
do
	dest=`basename "$orig" .flac`.mp3

	title=`taginfo "$orig" | grep TITLE | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	artist=`taginfo "$orig" | grep ARTIST | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	album=`taginfo "$orig"  | grep ALBUM | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	track=`taginfo "$orig"  | grep TRACK | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	year=`taginfo "$orig"  | grep YEAR | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	genre=`taginfo "$orig"  | grep GENRE | sed -e "s/^.*=//" | sed -e "s/\"//g"`
	
	# heitetään rojut tauluun 
	buildlist[$i]="${buildlist[$i]} echo \"Converting $title...\"\n" 
	buildlist[$i]="${buildlist[$i]}flac -scd \"$orig\" | lame --quiet --ignore-tag-errors --noreplaygain -q 2 -V $quality" 
	buildlist[$i]="${buildlist[$i]} --add-id3v2 --ta \"$artist\" --tl \"$album\" --tn \"$track\""
	buildlist[$i]="${buildlist[$i]} --tt \"$title\" --tg \"$genre\" --ty \"$year\" - \"$dest\""
	
	# insert newline
	buildlist[$i]="${buildlist[$i]}\n"

	let i=i+1
done 

# """
#### Sitten se lista jaetaan kahdeksi osalistaksi ja ajetaan molemmat simultaanisti.

let split=`echo "${#buildlist[*]} / 2" |bc`
first=${buildlist[@]:0:$split}
second=${buildlist[@]:$split}


echo -e $first |bash 
echo -e $second |bash


