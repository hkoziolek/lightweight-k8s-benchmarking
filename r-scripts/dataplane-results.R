# library
library(ggplot2)

latencies=rep(c(13.5,18.9,11.6,10.9))
latencies_max=rep(c(153.59900,174.07900,110.59100,178.175))
tp_op=c(14819,10537,17172,18354)
tp=c(628.65,446.97,728.44,778.62)
k8s=rep(c("MicroK8s", "k3s", "k0s", "MicroShift"))

data1=data.frame(latencies, latencies_max, tp_op, tp, k8s)

latency_plot <- ggplot(data1, aes(x=k8s, y=latencies)) + 
  geom_bar(stat="identity", color="black",position=position_dodge(), width =0.8, fill="#2171B5")+
  ylab("Average Latency (ms)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_errorbar(aes(ymin=latencies, ymax=latencies_max), width=.2, position=position_dodge(.9))+
  geom_text(aes(label = latencies), vjust = 1.5, colour = "white", size=3)

tp_op_plot <- ggplot(data1, aes(x=k8s, y=tp_op)) + 
  geom_bar(stat="identity", color="black", position=position_dodge(), width =0.8, fill="#2171B5")+
  ylab("Throughput Operations (Ops/sec)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_text(aes(label = tp_op), vjust = 1.5, colour = "white", size=3)

tp_plot <- ggplot(data1, aes(x=k8s, y=tp)) + 
  geom_bar(stat="identity", color="black", position=position_dodge(), width =0.8, fill="#2171B5")+
  ylab("Throughput Data (KB/sec)")+
  xlab("")+
  scale_x_discrete(limits = c("MicroK8s","k3s", "k0s", "MicroShift"))+
  geom_text(aes(label = tp), vjust = 1.5, colour = "white", size=3)

#latency_plot + tp_op_plot + tp_plot

latency_plot + tp_op_plot
