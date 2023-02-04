# K-Bench Configurations
This folder contains configurations for [k-bench](https://github.com/vmware-tanzu/k-bench) to test Kubernetes distributions. These files are in subfolders and called "config.json".
* cp_heavy_8client: starts 8 pods, then 8 deployments with 5 pods each, then 8 namespaces, and 8 services, finally repeats the entire procedure once
* cp_heavy_24client: starts 24 pods, then 24 deployments with 24 pods each, then 24 namespaces, and 24 services, finally repeats the entire procedure once
* dp_redis_density: creates two containers with the redis memtier benchmark and then executes this benchmark, which issues a lot of requests to redis NoSQL database.

The configuration files are in JSON format and to some extent self-explanatory. You can copy the config files in separate folder, edit them, and run your own custom experiments.

The folder also contains a couple of auxiliary scripts (.sh) to parse and aggregate the k-bench log files. They are not necessary for the experiments, but helped to extract the information for the charts reported in the paper. They assume that each experiment is given a specific number (e.g., 7 or 151).
* log.sh: follows the k-bench logging live on the console, given the experiment number as input argument.
* result-operations.sh: prints out the operations latency statistic for pods, deployments, namespaces, services. Check the content of the script for the input argument. This script can create a CSV file as a output, which can then be used for further processing and virtualization.
* result.sh: prints out pod and deployment throughput statistics for a given experiment number.