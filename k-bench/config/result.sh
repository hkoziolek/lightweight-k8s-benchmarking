my_path="$1/$(cd $1 && ls)/kbench.log"
sed -e 's/.\{47\}//' $my_path | grep -E 'Pod creation throughput|Pod creation average|Deployment Results|Pod Results|Pod startup total latency'

