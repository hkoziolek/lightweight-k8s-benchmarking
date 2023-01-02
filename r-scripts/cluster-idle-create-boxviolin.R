# library
library(ggplot2)

k8s=rep(c("MicroK8s", "k3s", "k0s"), each=360)
names=rep(c("CPU Controller", "CPU Worker", "Mem Controller", "Mem Worker", "Disk Controller", "Disk Worker"), each=60)

utils1 <- read.csv(file = gsub(" ", "", paste("147/idle-utils.csv")))
utils1$value[1:length(utils1$value)] <- round(utils1$value[1:length(utils1$value)], digits=1)
utils2 <- read.csv(file = gsub(" ", "", paste("167/idle-utils.csv")))
utils2$value[1:length(utils2$value)] <- round(utils2$value[1:length(utils2$value)], digits=1)
utils3 <- read.csv(file = gsub(" ", "", paste("154/idle-utils.csv")))
utils3$value[1:length(utils3$value)] <- round(utils3$value[1:length(utils3$value)], digits=1)
utils4 <- read.csv(file = gsub(" ", "", paste("161/idle-utils.csv")))
utils4$value[1:length(utils4$value)] <- round(utils4$value[1:length(utils4$value)], digits=1)

util = rbind (utils1, utils2, utils3)
data1=data.frame(util, k8s, names)

k8s=rep(c("MicroShift"), each=180)
names=rep(c("CPU Controller", "Mem Controller",  "Disk Controller"), each=60)
data2=data.frame(utils4, k8s, names)

data <- rbind(data1, data2)

install.packages("ggstatsplot")
install.packages("gapminder")

library(ggstatsplot)
library(gapminder)

ggbetweenstats(
  data,
  x = metric, 
  y = value, 
  type = "parameteric", ## type of statistics
  xlab = "", ## label for the x-axis
  ylab = "Resource utilization in idle condition (%)", ## label for the y-axis
  plot.type = "boxviolin", ## type of plot
  centrality.point.args = list(size = 3, color = "#2171B5"),
  outlier.tagging = FALSE, ## whether outliers should be flagged
  outlier.coef = 1.5, ## coefficient for Tukey's rule
  #outlier.label = country, ## label to attach to outlier values
  #outlier.label.args = list(color = "red"), ## outlier point label color
  ## turn off messages
  ggtheme = ggplot2::theme_gray(), ## a different theme
  package = "RColorBrewer", ## package from which color palette is to be taken
  palette = "Blues", ## choosing a different color palette
  results.subtitle = FALSE
  #title = "Test"
  #caption = "Source: Gapminder Foundation"
) + ## modifying the plot further
  ggplot2::scale_y_continuous(
    limits = c(0, 35),
    breaks = seq(from = 0, to = 35, by = 5)
  ) +
  scale_x_discrete(limits=rev)+ 
  coord_flip()
