#!/bin/bash

# 检查参数数量
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 input_file [target_start_lat target_start_lon | start_file]"
    exit 1
fi

# 初始化偏移量
offset_lat=""
offset_lon=""

# 检查第二个参数是否是一个文件
if [ "$#" -eq 2 ] && [ -f "$2" ]; then
    # 如果是文件，那么从文件中提取起点作为目标纬度和经度
    target_start_lat=$(awk '/<trkpt lat=/ {print gensub(/.*lat="([^"]*)".*/, "\\1", "g"); exit}' "$2")
    target_start_lon=$(awk '/<trkpt lat=/ {print gensub(/.*lon="([^"]*)".*/, "\\1", "g"); exit}' "$2")
elif [ "$#" -eq 3 ] && [[ $2 =~ ^-?[0-9]*\.[0-9]+$ ]] && [[ $3 =~ ^-?[0-9]*\.[0-9]+$ ]]; then
    # 否则，如果提供了足够的参数，并且这些参数都是有效的小数，那么使用提供的参数作为目标纬度和经度
    target_start_lat="$2"
    target_start_lon="$3"
else
    echo "Error: Invalid arguments"
    echo "Usage: $0 input_file [target_start_lat target_start_lon | start_file]"
    exit 1
fi

echo target_start_lat: $target_start_lat
echo target_start_lon: $target_start_lon

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

awk -v default_offset_lat="$default_offset_lat" -v default_offset_lon="$default_offset_lon" -v total_lines="$total_lines" -v target_start_lat="$target_start_lat" -v target_start_lon="$target_start_lon" '
BEGIN { 
    offset_lat = ""; 
    offset_lon = ""; 
}
/<trkpt lat=/ {
    lat = gensub(/.*lat="([^"]*)".*/, "\\1", "g");
    lon = gensub(/.*lon="([^"]*)".*/, "\\1", "g");
    if (offset_lat == "" || offset_lon == ""){
        if (target_start_lat != "" && target_start_lon != "") {
            offset_lat=sprintf("%.15f", target_start_lat - lat);
            offset_lon=sprintf("%.15f", target_start_lon - lon);
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
