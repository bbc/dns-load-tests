#!/bin/bash

rm -f dig.log

start=`date +%s`
secs=60

while [ $(( $(date +%s) - secs )) -lt $start ]; do
  dig +tcp -f data/axfr_domains.txt  @132.185.154.12 | egrep '^;; Query time:|^;; XFR size:' >> dig.log
  sleep 0.1
done
