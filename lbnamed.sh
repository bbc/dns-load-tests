#!/bin/bash

echo "www.bbc.net.uk A" > "$HOME/query"
rm -f /tmp/lbnamed.log.*

count=2
duration=2   #secs
vip=132.185.154.12

while [ $count -gt 0 ]
do 
  count=$((count - 1))
  dnsperf -s $vip -l $duration -d "$HOME/query" > /tmp/lbnamed.log.$count &
done
wait
grep qps /tmp/lbnamed.log.* | 
  perl -p -e 's/[\r\n]+$//; s/^.* (\d+)\..*$/$1/; push(@val, $_); $sum += $_; $_=""; END { print "$sum = " . join("+",@val) . "\n";}'
