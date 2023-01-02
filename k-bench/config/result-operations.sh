#!/usr/bin/bash
#$1 = experiment number
#$2 = kubernetes distro
#$3 = operation: namespace, pod, deployment, service

filename="$1-$3.csv"
my_path="$1/$(cd $1 && ls)/kbench.log"

echo k8s,metrics,medians,mins,maxs > $filename

median=$(sed -e 's/.\{47\}//' $my_path | grep -E "create $3 latency" | awk '{print $4}')
min=$(sed -e 's/.\{47\}//' $my_path | grep -E "create $3 latency" | awk '{print $5}')
max=$(sed -e 's/.\{47\}//' $my_path | grep -E "create $3 latency" | awk '{print $6}')
echo $2,create,$median,$min,$max >> $filename

median=$(sed -e 's/.\{47\}//' $my_path | grep -E "get $3 latency" | awk '{print $4}')
min=$(sed -e 's/.\{47\}//' $my_path | grep -E "get $3 latency" | awk '{print $5}')
max=$(sed -e 's/.\{47\}//' $my_path | grep -E "get $3 latency" | awk '{print $6}')
echo $2,get,$median,$min,$max >> $filename

median=$(sed -e 's/.\{47\}//' $my_path | grep -E "list $3 latency" | awk '{print $4}')
min=$(sed -e 's/.\{47\}//' $my_path | grep -E "list $3 latency" | awk '{print $5}')
max=$(sed -e 's/.\{47\}//' $my_path | grep -E "list $3 latency" | awk '{print $6}')
echo $2,list,$median,$min,$max >> $filename

median=$(sed -e 's/.\{47\}//' $my_path | grep -E "update $3 latency" | awk '{print $4}')
min=$(sed -e 's/.\{47\}//' $my_path | grep -E "update $3 latency" | awk '{print $5}')
max=$(sed -e 's/.\{47\}//' $my_path | grep -E "update $3 latency" | awk '{print $6}')
echo $2,update,$median,$min,$max >> $filename

median=$(sed -e 's/.\{47\}//' $my_path | grep -E "delete $3 latency" | awk '{print $4}')
min=$(sed -e 's/.\{47\}//' $my_path | grep -E "delete $3 latency" | awk '{print $5}')
max=$(sed -e 's/.\{47\}//' $my_path | grep -E "delete $3 latency" | awk '{print $6}')
echo $2,delete,$median,$min,$max >> $filename

cat $filename