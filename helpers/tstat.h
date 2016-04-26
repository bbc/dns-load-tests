#!/bin/sh

## usage: nice -n -1 tstat.sh

t=$1
[ ! -z $t ] || t=1

set -eu

ifname="ens2f0"
rcv0=0
snt0=0

while true; do
        ts=$(date +%s)
        rcv=$(ifconfig $ifname | grep 'RX packets' | tr ':' ' ' | awk '{print $3}')
        snt=$(ifconfig $ifname | grep 'TX packets' | tr ':' ' ' | awk '{print $3}')
        rcv_r=$(echo "$rcv $rcv0 $t" | awk '{ print ($1 - $2) / 1024 / $3 }')
        snt_r=$(echo "$snt $snt0 $t" | awk '{ print ($1 - $2) / 1024 / $3 }')
        rcv0=$rcv
        snt0=$snt

        rcvb=$(ifconfig $ifname | grep 'RX packets' | tr ':' ' ' | awk '{print $5}')
        sntb=$(ifconfig $ifname | grep 'TX packets' | tr ':' ' ' | awk '{print $5}')
        rcv_rb=$(echo "$rcvb $rcvb0 $t" | awk '{ print 8 * ($1 - $2) / 1024 / 1024 / $3 }')
        snt_rb=$(echo "$sntb $sntb0 $t" | awk '{ print 8 * ($1 - $2) / 1024 / 1024 / $3 }')
        rcvb0=$rcvb
        sntb0=$sntb

        clear
        printf "$ifname:\n\treceived:\t$rcv_r Kp/s\n\tsent:\t\t$snt_r Kp/s\n"
        printf "$ts\t$rcv_r\t$snt_r\n" >> tstat_$$.out
        printf "$ifname:\n\treceived:\t$rcv_rb Mb/s\n\tsent:\t\t$snt_rb Mb/s\n"
        printf "$ts\t$rcv_rb\t$snt_rb\n" >> tstat_$$.out
        sleep $t
done
