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
exp_collection = mongo(collection="experiments", db="netdata", url=connection_string)
timestamps <- exp_collection$find(query="{\"experimentID\": TODO}", fields='{"_id":false, "experimentID":true, "timestamp":true}')
timestamp_start = timestamps$timestamp[1]
timestamp_end = timestamps$timestamp[2]

perf_collection = mongo(collection="netdata_collection", db="netdata", url=connection_string)
get.netdata <- function(hostname, chart_type, chart_family, chart_context, id, timestamp_start, timestamp_end) {
  return (perf_collection$find(
    query = paste("{\"hostname\":\"", hostname, "\", 
                  \"chart_type\":\"", chart_type, "\", 
                  \"chart_family\":\"", chart_family, "\", 
                  \"chart_context\":\"", chart_context, "\", 
                  \"id\":\"", id, "\", 
                  \"timestamp\":{\"$gt\":", timestamp_start, ",", "\"$lt\":", timestamp_end, "}}", sep=""),
    fields='{"_id":false, "value": true, "timestamp":true}'
  ))
}

get.utils <- function(name, t1, t2){
  cpu_util_master <- get.netdata("charon", "system", "cpu", "system.cpu", "idle", timestamp_start, timestamp_end)
  cpu_util_master <- subset (cpu_util_master, select = -timestamp)
  # we take the inverse of idle time (100 minus idle time) as overall cpu utilization: 
  cpu_util_master$value[1:length(cpu_util_master$value)] <- 100-cpu_util_master$value[1:length(cpu_util_master$value)]
  cpu_util_master['metric']=paste("'CPU Controller",name,"'")

  cpu_util_worker <- get.netdata("nix", "system", "cpu", "system.cpu", "idle", timestamp_start, timestamp_end)
  cpu_util_worker <- subset (cpu_util_worker, select = -timestamp)
  # we take the inverse of idle time (100 minus idle time) as overall cpu utilization: 
  cpu_util_worker$value[1:length(cpu_util_worker$value)] <- 100-cpu_util_worker$value[1:length(cpu_util_worker$value)]
  cpu_util_worker['metric']=paste("'CPU Worker",name,"'")
  
  mem_util_master <- get.netdata("charon", "system", "ram", "system.ram", "used", timestamp_start, timestamp_end)
  mem_util_master <- subset (mem_util_master, select = -timestamp)
  # system.ram used is in MBytes, to convert to util divide by 8105 (system has 8 GB RAM):
  mem_util_master$value[1:length(mem_util_master$value)] <- mem_util_master$value[1:length(mem_util_master$value)] / 8105 * 100
  mem_util_master['metric']=paste("'Mem Controller",name,"'")
  
  mem_util_worker <- get.netdata("nix", "system", "ram", "system.ram", "used", timestamp_start, timestamp_end)
  mem_util_worker <- subset (mem_util_worker, select = -timestamp)
  # system.ram used is in MBytes, to convert to util divide by 8105 (system has 8 GB RAM):
  mem_util_worker$value[1:length(mem_util_worker$value)] <- mem_util_worker$value[1:length(mem_util_worker$value)] / 8105 * 100
  mem_util_worker['metric']=paste("'Mem Worker",name,"'")
  
  disk_util_master <- get.netdata("charon", "disk_util", "sda", "disk.util", "utilization", timestamp_start, timestamp_end)
  disk_util_master <- subset (disk_util_master, select = -timestamp)
  disk_util_master['metric']=paste("'Disk Controller",name,"'")
  
  disk_util_worker <- get.netdata("nix", "disk_util", "sda", "disk.util", "utilization", timestamp_start, timestamp_end)
  disk_util_worker <- subset (disk_util_worker, select = -timestamp)
  disk_util_worker['metric']=paste("'Disk Worker",name,"'")
  
  util <- rbind(cpu_util_master, cpu_util_worker)
  util <- rbind(util, mem_util_master)
  util <- rbind(util, mem_util_worker)
  util <- rbind(util, disk_util_master)
  util <- rbind(util, disk_util_worker)
  
  return(util)
  
}

util <- get.utils("MicroK8s", timestamp_start, timestamp_end)

boxplot <- ggplot(util,aes(x=metric,y=value))+
  geom_boxplot()+
  xlab("MicroK8s")+
  ylab("Utilization")+
  ylim(0,25)

boxplot + plot_layout(nrow=1)

write.csv(util, file = "idle-utils.csv")


