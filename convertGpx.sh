#!/bin/bash

# 默认偏移量
default_offset_lat="0.002053979116"
default_offset_lon="-0.004352461249"

INPUT="$1"
OUTPUT=${INPUT%.*}
OUTPUT="fix/${OUTPUT}_fix.gpx"
echo "output is $OUTPUT"

if [ ! -d fix ] ; then 
    echo "mkdir fix"
    mkdir fix
fi

rm -f $OUTPUT

# 获取输入文件的总行数
total_lines=$(wc -l < "$INPUT")
echo "Total lines to process: $total_lines"

# 初始化已处理的行数
processed_lines=0

# 初始化偏移量
offset_lat=""
offset_lon=""

awk -v default_offset_lat="$default_offset_lat" -v default_offset_lon="$default_offset_lon" -v total_lines="$total_lines" -v input_lat="$2" -v input_lon="$3" '
BEGIN { 
    offset_lat = ""; 
    offset_lon = ""; 
}
/<trkpt lat=/ {
    lat = gensub(/.*lat="([^"]*)".*/, "\\1", "g");
    lon = gensub(/.*lon="([^"]*)".*/, "\\1", "g");
    if (offset_lat == "" || offset_lon == ""){
        if (input_lat != "" && input_lon != "") {
            offset_lat=sprintf("%.15f", input_lat - lat);
            offset_lon=sprintf("%.15f", input_lon - lon);
        }else{
            offset_lat = default_offset_lat
            offset_lon = default_offset_lon
        }
    }
    fixed_lat=sprintf("%.15f", lat + offset_lat);
    fixed_lon=sprintf("%.15f", lon + offset_lon);
    print "<trkpt lat=\"" fixed_lat "\" lon=\"" fixed_lon "\">" >> "'$OUTPUT'"
    processed_lines++;
    percent=processed_lines/total_lines*100;
    printf("Processing: %.2f% \r", percent);
}
! /trkpt lat=/ {
    print >> "'$OUTPUT'"
    processed_lines++;
    percent=processed_lines/total_lines*100;
    printf("Processing: %.2f% \r", percent);
}' "$INPUT"

echo "Finished processing all lines."
