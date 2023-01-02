if (!require(patchwork)) install.packages("patchwork")
library(patchwork)

if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

if (!require(lubridate)) install.packages("lubridate")
library(lubridate)
library(ggplot2)

operation = "pod"

m1 <- read.csv(file = gsub(" ", "", paste("149-",operation,".csv")))
m2 <- read.csv(file = gsub(" ", "", paste("151-",operation,".csv")))
m3 <- read.csv(file = gsub(" ", "", paste("158-",operation,".csv")))
m4 <- read.csv(file = gsub(" ", "", paste("162-",operation,".csv")))

measurements <- rbind(m1,m2,m3,m4)
data=data.frame(measurements)

plot1 <- ggplot(data, aes(x=metrics, y=medians, fill=k8s)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge())+
  scale_fill_brewer(palette="Blues")+
  ylab("Latency (ms)")+
  xlab(paste(operation," operations"))+
  geom_errorbar(aes(ymin=mins, ymax=maxs), width=.2, position=position_dodge(.9))

plot1


n1 <- read.csv(file = gsub(" ", "", paste("148-",operation,".csv")))
n2 <- read.csv(file = gsub(" ", "", paste("152-",operation,".csv")))
n3 <- read.csv(file = gsub(" ", "", paste("159-",operation,".csv")))
n4 <- read.csv(file = gsub(" ", "", paste("163-",operation,".csv")))


measurements2 <- rbind(n1,n2, n3, n4)
data2=data.frame(measurements2)

plot2 <- ggplot(data2, aes(x=metrics, y=medians, fill=k8s)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge())+
  scale_fill_brewer(palette="Blues")+
  ylab("Latency (ms)")+
  xlab(paste(operation," operations"))+
  geom_errorbar(aes(ymin=mins, ymax=maxs), width=.2, position=position_dodge(.9))


plot1 + plot2

plot2

