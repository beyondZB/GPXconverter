#!/bin/bash

INPUT="$1"
OUTPUT=${INPUT%.*}
OUTPUT=fix/${OUTPUT}_fix.gpx
echo output is $OUTPUT
offset_lat="0.002053979116"
offset_lon="-0.004352461249"


if [ ! -d fix ] ; then 
    echo mkdir fix
    mkdir fix
fi



rm -f $OUTPUT


while read l ; do 
    #echo $l 
    if [ ! -z "`echo $l | grep \<trkpt\ lat=`" ] ; then
        lat=`echo $l |sed 's/.*lat="\([^"]*\)".*/\1/'`
        lon=`echo $l |sed 's/.*lon="\([^"]*\)".*/\1/'`
        fixed_lat=`echo $lat + $offset_lat |bc`
        fixed_lon=`echo $lon + $offset_lon |bc`
        #echo get lat $lat, fix: $fixed_lat
        #echo get lon $lon, fix: $fixed_lon
        echo "<trkpt lat=\"$fixed_lat\" lon=\"$fixed_lon\">" 
        echo "<trkpt lat=\"$fixed_lat\" lon=\"$fixed_lon\">" >> "$OUTPUT"
    else 
        echo $l >>"$OUTPUT"

    fi 
    # 
done < "$INPUT"