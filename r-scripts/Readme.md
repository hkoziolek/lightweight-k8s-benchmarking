The R-scripts in this folder were created to analyze and visualize the data from a paper on lightweight K8s benchmarking:

- cluster-idle-create-boxviolin.R: boxplot for cpu/mem/disk/net utliziations (Fig. 3)
- cluster-idle-write-utils.R: produced data for Fig. 3
- cluster-idle-write-utils-microshift.R: produced data for Fig. 3
- cp-operations.R: bar charts, Fig. 8, Fig. 10
- cp-pod-throughput-latency.R: bar charts, Fig. 7, Fig. 9
- dataplane-results.R: bar charts for Fig 12
- line-plot-visualizer.R: line plots for Fig. 4, 6, 11

To reuse the scripts, you need to edit the "TODO" markers to your local setup. 