#!/bin/bash
#

declare -a hosts
declare -i elements i

readarray -t hosts < $1
elements=${#hosts[@]}

for ((i=0;i<$elements;i++)); do
        echo "${hosts[${i}]}:"
        ssh -i /root/xxx.key root@${hosts[${i}]} 'ntpdate -u time.rightscale.com'
        ssh -i /root/xxx.key root@${hosts[${i}]} 'service ntpd restart'
done

exit 0