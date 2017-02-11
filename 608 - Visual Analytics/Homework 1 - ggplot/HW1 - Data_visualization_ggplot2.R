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


us_invest <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture1/Data/inc5000_data.csv",header=TRUE,sep=",",na.strings = c("","NA")) 


#1. Create a graph that shows the distribution of companies in the dataset by State (ie how many are in each state). There are a lot of States, so consider which axis you should use assuming I am using a ‘portrait’ oriented screen (ie taller than wide).

us_invest_state <- us_invest %>% group_by(State) %>% count(State) %>% rename(industry_count=n)


ggplot(us_invest_state, aes(State,industry_count)) + geom_point(aes(size=industry_count,color=industry_count),alpha=1/2) + 
  theme(legend.position="none") +
  ggtitle("State vs Companies Count") +ggsave("Figure1.png",path="Images",width=12,height=6)

#2. Let’s dig in on the State with the 3 rd most companies in the data set. Imagine you work for the state and are interested in how many people are employed by companies in different industries employ. Create a plot of average employment by industry for companies in this state (only use cases with full data (user R’s complete.cases() function). Your graph should show how variable the ranges are, and exclude outliers.

us_invest_ny <- us_invest[complete.cases(us_invest),] %>% filter(State=="NY") %>% group_by(Industry) %>%  summarize(avg_emp=mean(Employees))

#ggplot(us_invest_ny, aes(Industry,avg_emp)) + geom_point(aes(color=Industry),alpha=1/2) 

#us_invest[complete.cases(us_invest), ] %>% filter(State == "NY") %>% filter(Industry !="Business Products & Services") %>%
#  ggplot(aes(Industry, Employees)) + geom_boxplot(aes(color = Industry), alpha =1 / 2) +
#  ggtitle("NY Average employment by Industry")
  

ggplot(us_invest_ny, aes(Industry,avg_emp)) + geom_point(aes(color=Industry,size=avg_emp),alpha=1) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1),legend.position="none") + ggtitle("NY Average employment by Industry") + 
  +ggsave("Figure2_1.png",path="Images")



ggplot(us_invest_ny, aes(Industry,avg_emp)) + geom_bar( stat = "sum", position = "stack") + coord_flip() + 
  theme(legend.position="none") +ggtitle("NY Average employment by Industry")  +ggsave("Figure2_2.png",path="Images",width=10,height=6)


#3. Now imagine you work for an investor and want to see which industries generate the most revenue per employee. Create a chart makes this information clear.


us_invest_emp_summary <- us_invest[complete.cases(us_invest),] %>%  group_by(Industry) %>%  summarize(revenue=sum(Revenue),employees=sum(Employees)) %>% 
  mutate(revenue_employee = revenue/employees) %>% mutate(percentage = revenue_employee/sum(revenue_employee)) %>% ungroup(Industry)


us_invest_emp_state <- us_invest[complete.cases(us_invest),] %>%  group_by(State,Industry) %>%  summarize(revenue=sum(Revenue),employees=sum(Employees)) %>% 
  mutate(revenue_employee = revenue/employees) %>% mutate(percentage = revenue_employee/sum(revenue_employee)) %>% ungroup(State,Industry)

ggplot(us_invest_emp,aes(Industry,revenue_employee)) +geom_bar( stat = "sum", position = "stack") + theme(axis.text.x=element_text(angle=90,hjust=1),legend.position="none") + 
  ggtitle("Industry average revenue per employee")   +ggsave("Figure3_1.png",path="Images")


ggplot(data = us_invest_emp_state, aes(x = State, y = Industry)) +geom_raster(aes(fill =percentage,color=revenue_employee))  + 
  ggtitle("Industry average revenue per employee")  +ggsave("Figure3_2.png",path="Images",width=13,height=6)


