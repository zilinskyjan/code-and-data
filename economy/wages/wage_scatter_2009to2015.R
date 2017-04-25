# Purpose: compare 2009-12 and 2012-15 wage growth rates

library(dplyr)
library(ggplot2)
library(directlabels)
library(ggrepel)

# Download data

dat <- read.csv("https://raw.githubusercontent.com/zilinskyjan/datasets/master/economy/wages/wages_annualized.csv")
dat2 <- select(dat,country,wgrowth1215,wgrowth0912)
dat2$wgrowth0912 <- dat2$wgrowth0912*100
dat2$wgrowth1215 <- dat2$wgrowth1215*100

# Make the figure

p <- ggplot(dat2)
p + geom_point(aes(wgrowth0912, wgrowth1215),col="black") +
  geom_text_repel(aes(wgrowth0912, wgrowth1215, label = country), size=4) +
  ylab("Real wage growth (2012-15)") +
  xlab("Real wage growth (2009-12)") 
