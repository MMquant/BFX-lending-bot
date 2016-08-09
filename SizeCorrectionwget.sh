#!/bin/bash

# Data file size correction for wget lastSwapsUSD.csv download.
# Wget tends to download just part of the whole file.
# We will resume downloads until we get the whole file.

dlsize=0
truesize=$(curl -sI https://bfxdata.com/csv/lastSwapsUSD.csv | grep -i content-length | awk '{print $2}' | tr -d '\r')

while [[ $dlsize != $truesize ]]; do
/usr/bin/wget -t 0 https://bfxdata.com/csv/lastSwapsUSD.csv --random-wait -O /home/maple/Documents/MATLAB/data/lastSwapsUSD.csv -a /home/maple/Documents/MATLAB/logs/wget.log
dlsize=$(stat -c%s "/home/maple/Documents/MATLAB/data/lastSwapsUSD.csv")
truesize=$(curl -sI https://bfxdata.com/csv/lastSwapsUSD.csv | grep -i content-length | awk '{print $2}' | tr -d '\r')
# echo "dlsize="$dlsize
# echo "truesize="$dlsize
done
