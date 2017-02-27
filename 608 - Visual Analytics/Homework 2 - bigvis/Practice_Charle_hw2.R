# sample code to create graphs using bigvis
# installation
# install_packages('devtools')
# library(devtools)
# install_github(repo='hadley/bigvis')

library(bigvis)
library(ggplot2)
library(dplyr)
library(ggthemes)


if(!require("ggplot2", character.only = TRUE, quietly = TRUE)) {
  install.packages("ggplot2")
  library("ggplot2", character.only = TRUE)
}

pData <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture2/some_PLUTO_data.csv")

# does lot area change with year of construction?
pData <- pData %>%
  filter(YearBuilt > 1850, LotArea > 100, AssessTot < 10000000, NumFloors != 0) %>%
  select(LotArea, YearBuilt)

# let's plot 5 year averages
yr <- with(pData, condense(bin(YearBuilt, 5), z=LotArea))

autoplot(yr) + xlim(1900, 2014) + ylim(0, 10000) + ylab('Lot Area')

ggplot(yr) + geom_line(aes(x=YearBuilt, y=.mean)) + 
  geom_point(aes(x=YearBuilt, y=.mean, color = .count)) +
  xlim(1900, 2014) + ylim(0, 10000) + ylab('Lot Area') + 
  scale_color_gradient(trans = "log")

# bins can be 2-dimensional

data(movies, package="bigvis")
n_bins = 1e4
bin_data = with(movies, 
                condense(bin(length, find_width(length, n_bins)),
                         bin(rating, find_width(rating, n_bins))))

ggplot(bin_data, aes(length, rating, fill=.count )) + 
  geom_raster()


ggplot(data=peel(bin_data), aes(length, rating, fill=.count )) + 
  geom_raster()

autoplot(peel(bin_data)) + theme_tufte()