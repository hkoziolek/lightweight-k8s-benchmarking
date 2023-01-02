if (!require(patchwork)) install.packages("patchwork")
library(patchwork)

if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

if (!require(lubridate)) install.packages("lubridate")
library(lubridate)
library(ggplot2)

# data taken from kbench.log files:

throughput_pod_8 = (c(89.97,92.54,78.79,64.73))
avg_latency_pod_8 = (c(2.56,2.41,2.73, 3.64))
throughput_deployment_8 = (c(115.81,133.73,129.42,62.05))
avg_latency_deployment_8 = (c(10.31,9.01,9.34,18.12))

throughput_pod_24 = (c(110.12,130.58,127.19))
avg_latency_pod_24 = (c(6.54,5.67,5.56))
throughput_deployment_24 = (c(105.73,143.22,152.05))
avg_latency_deployment_24 = (c(37.78,24.34,23.44))


# plot throughput/latency bar charts for 8 pod scenario for MicroK8s, k3s, k0s, Microshift

k8s=rep(c("MicroK8s", "k3s", "k0s", "MicroShift"))

data1=data.frame(
  throughput_pod_8, avg_latency_pod_8, throughput_deployment_8, avg_latency_deployment_8,
  k8s)


plot1 <- ggplot(data1, aes(x=k8s, y=throughput_pod_8, fill = ifelse(k8s == "MicroShift", "Highlighted", "Normal"))) + 
  geom_bar(stat = "identity", color="black", position=position_dodge(), width=0.6)+
  ylab("Throughput Pod creation\n 8 pods (pods/min)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_text(aes(label = throughput_pod_8), vjust = 1.5, colour = "white", size=3)+
  scale_fill_manual( "legend", values = c("Highlighted"="darkgray", "Normal"="#2171B5"), guide="none" )

plot2 <- ggplot(data1, aes(x=k8s, y=avg_latency_pod_8, fill = ifelse(k8s == "MicroShift", "Highlighted", "Normal"))) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6)+
  ylab("Pod creation avg latency\n 8 pods (sec)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_text(aes(label = avg_latency_pod_8), vjust = 1.5, colour = "white", size=3)+
  scale_fill_manual( "legend", values = c("Highlighted"="darkgray", "Normal"="#2171B5"), guide="none" )

plot3 <- ggplot(data1, aes(x=k8s, y=throughput_deployment_8, fill = ifelse(k8s == "MicroShift", "Highlighted", "Normal"))) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6)+
  ylab("Throughput Deployment\n 40 pods, (pods/min)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_text(aes(label = throughput_deployment_8), vjust = 1.5, colour = "white", size=3)+
  scale_fill_manual( "legend", values = c("Highlighted"="darkgray", "Normal"="#2171B5"), guide="none" )

plot4 <- ggplot(data1, aes(x=k8s, y=avg_latency_deployment_8, fill = ifelse(k8s == "MicroShift", "Highlighted", "Normal"))) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6)+
  ylab("Pod creation avg latency\n40 pods (sec)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_text(aes(label = avg_latency_deployment_8), vjust = 1.5, colour = "white", size=3)+
  scale_fill_manual( "legend", values = c("Highlighted"="darkgray", "Normal"="#2171B5"), guide="none" )


plot1 + plot2 + plot3 + plot4



# plot throughput/latency bar charts for 24 pod scenario for MicroK8s, k3s, k0s, but not MicroShift

k8s=rep(c("MicroK8s", "k3s", "k0s"))

data2=data.frame(
  throughput_pod_24, avg_latency_pod_24, throughput_deployment_24, throughput_deployment_24, 
  k8s)

plot5 <- ggplot(data1, aes(x=k8s, y=throughput_pod_24)) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6,fill="#2171B5")+
  ylab("Throughput Pod creation\n24 pods (pods/min)")+
  xlab("")+
  scale_x_discrete(limits=rev)+
  geom_text(aes(label = throughput_pod_24), vjust = 1.5, colour = "white", size=3)

plot6 <- ggplot(data1, aes(x=k8s, y=avg_latency_pod_24)) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6,fill="#2171B5")+
  ylab("Pod creation avg latency\n24 pods (sec)")+
  xlab("")+
  scale_x_discrete(limits=rev)+
  geom_text(aes(label = avg_latency_pod_24), vjust = 1.5, colour = "white", size=3)

plot7 <- ggplot(data1, aes(x=k8s, y=throughput_deployment_24)) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6,fill="#2171B5")+
  ylab("Throughput Deployment\n120 pods, (pods/min)")+
  xlab("")+
  scale_x_discrete(limits=rev)+
  geom_text(aes(label = throughput_deployment_24), vjust = 1.5, colour = "white", size=3)

plot8 <- ggplot(data1, aes(x=k8s, y=avg_latency_deployment_24)) + 
  geom_bar(stat = "identity", color="black",position=position_dodge(), width=0.6,fill="#2171B5")+
  ylab("Pod creation avg latency\n120 pods (sec)")+
  xlab("")+
  scale_x_discrete(limits=rev)+
  geom_text(aes(label = avg_latency_deployment_24), vjust = 1.5, colour = "white", size=3)


plot5 + plot6 + plot7 + plot8


