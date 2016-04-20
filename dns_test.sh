#!/bin/bash

# Example
# sh dns_test.sh "www.bbc.net.uk A" 132.185.154.12 2 2 bind

rm -f /tmp/*log.*

query=$1
ip=$2
count=$3
duration=$4
log=$5

echo $query > "$HOME/query"

while [ $count -gt 0 ]
do 
  count=$((count - 1))
  dnsperf -s $ip -l $duration -d "$HOME/query" > /tmp/$log.log.$count &
done
wait
grep qps /tmp/$log.log.* | 
  perl -p -e 's/[\r\n]+$//; s/^.* (\d+)\..*$/$1/; push(@val, $_); $sum += $_; $_=""; END { print "$sum = " . join("+",@val) . "\n";}'
