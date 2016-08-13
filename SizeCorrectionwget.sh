#!/bin/bash

# Data file size correction for wget lastSwapsUSD.csv download.
# Wget tends to download just part of the whole file.
# We will resume downloads until we get the whole file.
# Set dlpath before use.

dlsize=0
dlpath=your/custom/path/lastSwaps.csv # SET BEFORE USE
logpath=your/custom/path/wget.log # SET BEFORE USE
truesize=$(curl -sI https://bfxdata.com/csv/lastSwapsUSD.csv | grep -i content-length | awk '{print $2}' | tr -d '\r')

while [[ $dlsize != $truesize ]]; do
/usr/bin/wget -t 0 https://bfxdata.com/csv/lastSwapsUSD.csv --random-wait -O $dlpath -a $logpath
dlsize=$(stat -c%s "$dlpath")
# truesize=$(curl -sI https://bfxdata.com/csv/lastSwapsUSD.csv | grep -i content-length | awk '{print $2}' | tr -d '\r')
# echo "dlsize="$dlsize
# echo "truesize="$dlsize
done
