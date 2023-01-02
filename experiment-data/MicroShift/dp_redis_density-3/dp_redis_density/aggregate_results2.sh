#/bin/bash
Num_Instances=2;

Agg_throughput=0;
for((num=0;num < ${Num_Instances};num++))
{ 
	throughput=`microk8s kubectl exec -it kbench-pod-oid-0-tid-${num} -n kbench-pod-namespace -- cat /tmp/redisoutput/memtier.out  | grep "Totals" | awk {'print $2'}`
	echo "Throughput of pod $num is $throughput";
	Agg_throughput=`echo "$throughput + $Agg_throughput" | bc`
}
echo "Aggregate throughput = $Agg_throughput";
