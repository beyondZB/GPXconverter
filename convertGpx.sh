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

# 获取输入文件的总行数
total_lines=$(wc -l < "$INPUT")
echo "Total lines to process: $total_lines"

# 初始化已处理的行数
processed_lines=0

while read l ; do 
    # 更新已处理的行数
    ((processed_lines++))

    # 计算并显示进度百分比
    percent=$(echo "scale=2; $processed_lines/$total_lines*100" | bc)
    echo -ne "Processing: $percent% \r"

    if [ ! -z "`echo $l | grep \<trkpt\ lat=`" ] ; then
        lat=`echo $l |sed 's/.*lat="\([^"]*\)".*/\1/'`
        lon=`echo $l |sed 's/.*lon="\([^"]*\)".*/\1/'`
        fixed_lat=`echo $lat + $offset_lat |bc`
        fixed_lon=`echo $lon + $offset_lon |bc`
        # echo "<trkpt lat=\"$fixed_lat\" lon=\"$fixed_lon\">" 
        echo "<trkpt lat=\"$fixed_lat\" lon=\"$fixed_lon\">" >> "$OUTPUT"
    else 
        echo $l >>"$OUTPUT"
    fi 
done < "$INPUT"

# 清除进度显示的行
echo -ne "\nFinished processing all lines.\n"
