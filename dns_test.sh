#!/bin/bash

# Example
# sh dns_test.sh bind "www.bbc.co.uk A" 2 2 
# sh dns_test.sh lbnamed "www.bbc.net.uk A" 2 2

tmplog=/tmp/*.log.*
rm -f tmplog

if [ "$1" = "bind" ]
then
  ip=132.185.154.12
elif [ "$1" = "lbnamed" ]
then
  ip=212.58.234.248
else
  echo incorrect dns server
fi

query="$2"
count="$3"
duration="$4"

echo $query > "$HOME/query"

while [ $count -gt 0 ]
do 
  count=$((count - 1))
  dnsperf -s $ip -l $duration -q 20 -d "$HOME/query" > /tmp/$1.log.$count &
done
wait
qps=$(grep "Queries per second" $tmplog | 
perl -p -e 's/[\r\n]+$//; s/^.* (\d+)\..*$/$1/; push(@val, $_); $sum += $_; $_=""; END { print "$sum = " . join("+",@val) . "\n";}')

min=$(grep -h 'Average Latency' $tmplog | sed 's/,//g'| awk '{print $6}')
max=$(grep -h 'Average Latency' $tmplog | sed -e 's/)//g' | awk '{print $8}')
av=$(grep -h 'Average Latency' $tmplog | awk '{print $4}')

echo qps: $qps
echo min: $min
echo max: $max
echo av :  $av
