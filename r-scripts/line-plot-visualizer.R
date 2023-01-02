if (!require(patchwork)) install.packages("patchwork")
library(patchwork)

if (!require(mongolite)) install.packages("mongolite")
library(mongolite)

if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

if (!require(lubridate)) install.packages("lubridate")
library(lubridate)
library(ggplot2)

connection_string = 'mongodb://TODO'
perf_collection = mongo(collection="netdata_collection", db="netdata", url=connection_string)
exp_collection = mongo(collection="experiments", db="netdata", url=connection_string)

experiment_id = 179 # TODO: use correct experiment ID
timestamps <- exp_collection$find(query=paste("{\"experimentID\": ", experiment_id, "}"), fields='{"_id":false, "experimentID":true, "timestamp":true}')
timestamp_start = timestamps$timestamp[1]
timestamp_end = timestamps$timestamp[2]

# get data from MongoDB
get.netdata <- function(chart_type, chart_family, chart_context, id, timestamp_start, timestamp_end) {
  return (perf_collection$find(
    query = paste("{\"hostname\":\"charon\", 
                  \"chart_type\":\"", chart_type, "\", 
                  \"chart_family\":\"", chart_family, "\", 
                  \"chart_context\":\"", chart_context, "\", 
                  \"id\":\"", id, "\", 
                  \"timestamp\":{\"$gt\":", timestamp_start, ",", "\"$lt\":", timestamp_end, "}}", sep=""),
    fields='{"_id":false, "value": true, "timestamp":true}'
  ))
}


# process the data and create the plots
cpu_util <- get.netdata("system", "cpu", "system.cpu", "idle", timestamp_start, timestamp_end)
# we take the inverse of idle time (100 minus idle time) as overall cpu utilization: 
cpu_util$value[1:length(cpu_util$value)] <- 100-cpu_util$value[1:length(cpu_util$value)]
cpu_util$timestamp[1:length(cpu_util$value)] <- (cpu_util$timestamp[1:length(cpu_util$value)] - timestamp_start - 1)/60
cpu_plot <- ggplot(cpu_util,aes(x=timestamp,y=value))+
  geom_line(size=1,color="blue")+
  #geom_point(size=2,color="black")+
  xlab("Experiment Duration (minutes)")+
  ylab("CPU Utilization (percent)")+
  ylim(0,100)

mem_util <- get.netdata("system", "ram", "system.ram", "used", timestamp_start, timestamp_end)
# system.ram used is in MBytes, to convert to util divide by 8105 (system has 8 GB RAM):
mem_util$value[1:length(mem_util$value)] <- mem_util$value[1:length(mem_util$value)] / 8105 * 100
mem_util$timestamp[1:length(mem_util$value)] <- (mem_util$timestamp[1:length(mem_util$value)] - timestamp_start - 1)/60
mem_plot <- ggplot(mem_util,aes(x=timestamp,y=value))+
  geom_line(size=1,color="blue")+
  xlab("Experiment Duration (minutes)")+
  ylim(0,100)

disk_util <- get.netdata("disk_util", "sda", "disk.util", "utilization", timestamp_start, timestamp_end)
disk_util$timestamp[1:length(disk_util$value)] <- (disk_util$timestamp[1:length(disk_util$value)] - timestamp_start - 1)/60
disk_plot <- ggplot(disk_util,aes(x=timestamp,y=value))+
  geom_line(size=1,color="blue")+
  xlab("Experiment Duration (minutes)")+
  ylab("Disk Utilization (percent)")+
  ylim(0,100)

net_util <- get.netdata("system", "network", "system.net", "InOctets", timestamp_start, timestamp_end)
net_util$timestamp[1:length(net_util$value)] <- (net_util$timestamp[1:length(net_util$value)] - timestamp_start - 1)/60
net_plot <- ggplot(net_util,aes(x=timestamp,y=value))+
  geom_line(size=1,color="blue")+
  xlab("Experiment Duration (minutes)")+
  ylab("Network InOcts")+
  ylim(0,100)

cpu_plot + mem_plot + disk_plot + net_plot

#write the processed data to csv files for further processing:
dir.create(gsub(" ", "", paste("",experiment_id,"")))
write.csv(cpu_util, file = gsub(" ", "", paste("",experiment_id,"/cpu_util.csv")))
write.csv(mem_util, file = gsub(" ", "", paste("", experiment_id, "/mem_util.csv")))
write.csv(disk_util, file = gsub(" ", "", paste("", experiment_id, "/disk_util.csv")))
write.csv(net_util, file = gsub(" ", "", paste("", experiment_id, "/net_util.csv")))

cpu_plot + mem_plot + disk_plot + plot_layout(nrow=1)

