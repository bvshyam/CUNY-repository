## Bigvis - City of New York 


#install.packages("Rtools")

#devtools::install_github("hadley/bigvis")

devtools::install_github("dgrtwo/gganimate")

library(gganimate)
library(bigvis)

if(!require("ggplot2", character.only = TRUE, quietly = TRUE)) {
  install.packages("ggplot2")
  library("ggplot2", character.only = TRUE)
}

if(!require("dplyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("dplyr")
  library("dplyr", character.only = TRUE)
}

if(!require("dplyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("dplyr")
  library("dplyr", character.only = TRUE)
}

if(!require("devtools", character.only = TRUE, quietly = TRUE)) {
  install.packages("devtools")
  library("devtools", character.only = TRUE)
}

if(!require("Rcpp", character.only = TRUE, quietly = TRUE)) {
  install.packages("Rcpp")
  library("Rcpp", character.only = TRUE)
}



temp = list.files(path = "G:/Google_drive/CUNY/Courses/Archive/nyc_pluto_16v2/BORO_zip_files_csv",pattern="*.csv")
setwd("G:/Google_drive/CUNY/Courses/Archive/nyc_pluto_16v2/BORO_zip_files_csv")

#temp = list.files(path = "C:/Users/paperspace/Google Drive/CUNY/Courses/Archive/nyc_pluto_16v2/BORO_zip_files_csv",pattern="*.csv")

#setwd("C:/Users/paperspace/Google Drive/CUNY/Courses/Archive/nyc_pluto_16v2/BORO_zip_files_csv")


all_PLUTO_data = read.csv(temp[1],header=TRUE,sep=",",na.strings = c("","NA"),nrow=1,stringsAsFactors = FALSE)
all_PLUTO_data = all_PLUTO_data[0,]

for(i in 1:length(temp)) {

  all_PLUTO_data <- rbind.data.frame(all_PLUTO_data,read.csv(temp[i],header=TRUE,sep=",",na.strings = c("","NA"),stringsAsFactors = FALSE) )
}

setwd("G:/Google_drive/CUNY/Courses/CUNY-repository/608 - Visual Analytics/Homework 2 - bigvis")

#setwd("C:/Users/paperspace/Google Drive/CUNY/Courses/CUNY-repository/608 - Visual Analytics/Homework 2 - bigvis")


#Question 1:

#1. After a few building collapses, the City of New York is going to begin investigating older buildings for safety. However, the city has a limited number of inspectors, and wants to find a‘cut-off’ date before most city buildings were constructed. Build a graph to help the city determine when most buildings were constructed. Is there anything in the results that causes you to question the accuracy of the data? (note: only look at buildings built since 1850) 

#Chart 1

building_1850_count <- all_PLUTO_data %>%  filter(YearBuilt>=1850, YearBuilt <= 2018) %>% 
  with(condense(bin(YearBuilt,5))) %>% filter(!is.na(YearBuilt))

ggplot(building_1850_count,aes(x=YearBuilt,y=.count)) + geom_bar( stat ="sum", position = "stack") + 
  xlim(1850, 2017)  + ggtitle("Building build on each Year")  + ggsave("Figure1_1.png",path="Images")


ggplot(building_1850_count,aes(x=YearBuilt,y=.count)) + geom_line() + 
  xlim(1850, 2017) + ggtitle("Building build on each Year") + ggsave("Figure1_2.png",path="Images")


#Chart 2

building_filtered <- all_PLUTO_data %>%  filter(YearBuilt>=1850, YearBuilt <= 2017, (YearBuilt < YearAlter1 | YearAlter1 ==0),
    (YearBuilt < YearAlter1 | YearAlter1 ==0)) %>% select(YearBuilt,YearAlter1,YearAlter2) %>% 
    with(condense(bin(YearBuilt,1))) %>% filter(!is.na(YearBuilt))


ggplot(building_filtered,aes(x=YearBuilt,y=.count)) +  theme(legend.position="none") +
  geom_bar( stat ="sum") + ggtitle("Bar chart of building build on each Year") +ggsave("Figure1_3.png",path="Images",width=10,height=6)


ggplot(building_filtered,aes(x=YearBuilt,y=.count)) + geom_line(aes(color=YearBuilt)) +  theme(legend.position="none") +
  xlim(1850, 2017) + ggtitle("Line chart of building build on each Year") + ggsave("Figure1_4.png",path="Images",width=10,height=6)



# Problem 2

# 2. The city is particularly worried about buildings that were unusually tall when they were
# built, since best-practices for safety hadn’t yet been determined. Create a graph that shows
# how many buildings of a certain number of floors were built in each year (note: you may                                                                          want to use a log scale for the number of buildings). It should be clear when 20-story
# buildings, 30-story buildings, and 40-story buildings were first built in large numbers.


safety_building <- all_PLUTO_data %>%  filter(YearBuilt >0,YearBuilt>=1850, YearBuilt <= 2018) %>% select(YearBuilt,NumFloors) 



#Chart 1

ggplot(safety_building,aes(YearBuilt,NumFloors)) + geom_point(aes(color=NumFloors>=20 & NumFloors<=40)) +
  scale_y_log10() + scale_x_continuous(breaks = seq(1850,2018,10)) + ylab("Number of Floors") +ggtitle("Floors on each Year") + 
  ggsave("Figure2_1.png",path="Images",width=10,height=6)
  
#Chart 2
  
  safety_building_all <- all_PLUTO_data %>%  filter(YearBuilt >0,YearBuilt>=1850, YearBuilt <= 2018,(NumFloors>=20 & NumFloors<=50)) %>% 
  select(YearBuilt,NumFloors,Borough,LotArea) %>% 
  mutate(section = ifelse(NumFloors <30," Less than 30 floors",ifelse(NumFloors >=30 & NumFloors <40,"30 to 40 floors","Greater than 40 floors")))

ggplot(safety_building_all,aes(YearBuilt,NumFloors)) +geom_smooth() + facet_grid(.~section) + ggtitle("Floors on each Year") + 
  ylab("Number of Floors") +  ggsave("Figure2_2.png",path="Images")


#Chart 3

safety_building_avg <- all_PLUTO_data %>%  filter(YearBuilt >0,YearBuilt>=1850, YearBuilt <= 2018,(NumFloors>=20 & NumFloors<=50)) %>% 
  select(YearBuilt,NumFloors,Borough,LotArea) %>% group_by(YearBuilt) %>% summarise(AvgNumFloors=mean(NumFloors))  %>% 
  mutate(section = ifelse(AvgNumFloors <30,"Average floors(<30) in that year",ifelse(AvgNumFloors >=30 & AvgNumFloors <40,"Average floors(>30 to 40) in that year","3")))

ggplot(safety_building_avg,aes(YearBuilt,AvgNumFloors)) +geom_smooth() + facet_grid(.~section) + ggtitle("Average Floors on each Year") + 
  ylab("Average number of Floors") +  ggsave("Figure2_3.png",path="Images")



# Problem 3

# 3. Your boss suspects that buildings constructed during the US’s involvement in World War
# II (1941-1945) are more poorly constructed than those before and after the way due to the
# high cost of materials during those years. She thinks that, if you calculate assessed value
# per floor, you will see lower values for buildings at that time vs before or after. Construct a
# chart/graph to see if she’s right.


assessed_value <- all_PLUTO_data %>% filter(YearBuilt >0,YearBuilt>=1850, YearBuilt <= 2018,NumFloors>0,AssessTot>0) %>% 
  select(YearBuilt,NumFloors,AssessTot,BldgClass,Borough,LotType) %>% 
  mutate(perfloorasses = AssessTot/NumFloors)

# Chart 1

assessed_value  %>% group_by(YearBuilt) %>% summarise(meanfloorass = mean(perfloorasses)) %>% #filter(YearBuilt >1938,YearBuilt<=1948) %>%  
  ggplot(aes(x=YearBuilt,y=meanfloorass))   + geom_bar( stat ="sum", position = "stack",color="gray") + geom_line(color="red") +
  scale_x_continuous(breaks = seq(1850,2018,7)) + theme(legend.position="none")  + ylab("Asset value of Floors")  +
  ggtitle("Asset value of Building in each year") +  ggsave("Figure3_1.png",path="Images",width=10,height=6)


#It seems the lower values were there before and after World War II (1941-1945). But historically it is not the lowest asset values.

# Chart 2

assessed_value  %>% filter(YearBuilt >1938,YearBuilt<=1948) %>% group_by(YearBuilt,LotType,Borough) %>% summarise(meanfloorass = mean(perfloorasses)) %>%  
  ggplot(aes(x=YearBuilt,y=meanfloorass)) + geom_point() + geom_jitter() + facet_grid(LotType ~ Borough) + ylab("Mean asset value Floors") + 
  ggtitle("Asset value of Building in each year in Borough & Lot type") +
  ggsave("Figure3_2.png",path="Images",width=10,height=6)


