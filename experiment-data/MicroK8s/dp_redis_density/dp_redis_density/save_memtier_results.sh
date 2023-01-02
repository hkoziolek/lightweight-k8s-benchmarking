#!/usr/bin/bash
Num_Instances=2;

for((num=0;num < ${Num_Instances};num++))
{
        microk8s kubectl cp kbench-pod-namespace/kbench-pod-oid-0-tid-${num}:/tmp/redisoutput/memtier.out memtier-${num}.out
        echo "Saved memtier-$num.out";
}
