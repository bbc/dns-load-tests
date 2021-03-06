#!/bin/bash

start=`date +%s`
secs=1200

echo start: `date` > dig.log

while [ $(( $(date +%s) - secs )) -lt $start ]; do
  dig +tcp -f data/axfr_domains.txt  @132.185.154.12 | egrep '^;; Query time:|^;; XFR size:' >> dig.log
  sleep 0.1
done

echo end: `date` >> dig.log
