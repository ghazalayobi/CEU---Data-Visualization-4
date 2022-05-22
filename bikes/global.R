library(data.table)
library(DT)
library(ggplot2)
library(plotly)
library(dplyr)
library(lubridate)
library(viridis)
library(tidyverse)



# Creating the helper functions 

# reading the data ####################
df <- read.csv("https://raw.githubusercontent.com/ghazalayobi/CEU-Data-Visualization-4/main/data/Sales.csv")
df <- na.omit(df) %>% filter()
df$Date <- ymd(df$Date)


# functions ####################


# get Frequency 
get_freqpoly <- function(df, X, Y) {
  ggplot(df, aes(x = X, color = Y)) + geom_freqpoly(bins = 100) + 
    scale_color_viridis_d() +
    theme_bw() + 
    theme(legend.position="bottom")
}

# Get density function
get_density <- function(df, X, Y){
  ggplot(df, aes(x=X, group=Y, fill=Y)) +
    geom_density(adjust=1.5, position="fill", alpha =0.9) +
    scale_fill_viridis(discrete = T) +
    theme_bw() + 
    theme(legend.position="bottom")
}


# get bar plot

get_bar <- function(df, X, Y, Z) {
  ggplot(df, aes(x= X, y= Y, fill= Z)) + 
    geom_bar(position="stack", stat="identity") +
    scale_fill_viridis_d() +
    theme_bw() +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
}

# get histogram

get_hist <- function(df, X, Y) {
  ggplot(df, aes(x = X, fill = Y)) + geom_histogram(bins = 36) + 
    scale_fill_viridis_d(alpha = 0.9) +
    theme_bw() +
    theme(legend.position = "bottom")
}










