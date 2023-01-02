my_path="$1/$(cd $1 && ls)/kbench.log"
tail -f $my_path
