rm(list=ls())
install.packages("foreign") #once we install it, it is installed forever
install.packages("dplyr")
install.packages("car")
install.packages("tidyr")
install.packages("psych")  
install.packages("DescTools")
install.packages("pscl")
install.packages("lmtest")
library(pscl)
library(DescTools)
library(psych)
library(foreign)
library(dplyr)
library(car)
library(tidyr)
library(lmtest)
setwd("/Users/jimenagomezmatzui/Documents/Jimena/1_MasterLeipzig/SoSe25/QuantitativeMethods") #set working directory
ds <- read.spss("ZA7901_v2-0-0.sav", to.data.frame = T) #importing data set
View(ds)
data2 <- select(ds, country, qa11, qc14ab_corr, qa1_1, qa12_1, qa12_2, qa12_3)
data_AU <- data2 %>% filter(country== "AT - Austria")
View(data_AU)

#Checking for na's
sum(is.na(data_AU$country)) 
sum(is.na(data_AU$qa11)) #Mode of transport- typically most often used
sum(is.na(data_AU$qc14ab_corr)) #Household income deciles - all countries 
sum(is.na(data_AU$qa1_1)) #Personal responsibility to limit climate change
sum(is.na(data_AU$qa12_1)) #Quality of public transport in the area - availability
sum(is.na(data_AU$qa12_2)) #Quality of public transport in the area - affordability
sum(is.na(data_AU$qa12_3)) #Quality of public transport in the area - quality 

#overview of the variables
table(data_AU$qa11)
table(data_AU$qc14ab_corr)
table(data_AU$qa1_1)
table(data_AU$qa12_1)
table(data_AU$qa12_2)
table(data_AU$qa12_3)

#Mutating variable "qa11 Mode of transport- typically most often used"
#make use (1) or not use (0) public transportation binary
data_AU<- data_AU %>%
  mutate(PT_bin = case_when(qa11 == "Public transport (bus, metro, tram, ferry, urban rail, etc.)" ~ 1,  #use public transport is 1
                            qa11 != "Public transport (bus, metro, tram, ferry, urban rail, etc.)" ~ 0. 
  ))
data_AU$PT_bin <- as.numeric(data_AU$PT_bin)
table(data_AU$PT_bin) # 1:194 0:817 

#Mutate the other variables 
#qc14ab_corr ordinal values to numeric
levels(data_AU$qc14ab_corr)
length(levels(data_AU$qc14ab_corr)) #272
length(unique(data_AU$qc14ab_corr)) #12
#qc14ab_corr- Household income deciles - all countries"
#delete the "don't know and refusal" answers converting them to NA from the Income variable
data_AU$qc14ab_corr <- dplyr::recode(data_AU$qc14ab_corr,
                                     "Don't know (SPONTANEOUS)" = NA_character_,
                                     "Refusal (SPONTANEOUS)" = NA_character_)

#droping NAs of this variable 
sum(is.na(data_AU$qc14ab_corr)) #243
data_AU <- data_AU %>%
  drop_na(qc14ab_corr)


#mutate the income to ordinal  SHOULD WE DIVIDE IT INTO 5 CATHEGORIES?** #try that the ranges                               
data_AU<- data_AU %>%
  mutate(Income_cat = case_when(qc14ab_corr == "Less than 1,300 (NATIONAL CURRENCY)" ~ 1,  
                                qc14ab_corr == "Between 1,300 and 1,800 (NATIONAL CURRENCY)" ~ 2,
                                qc14ab_corr == "Between 1,801 and 2,300 (NATIONAL CURRENCY)" ~ 3,
                                qc14ab_corr == "Between 2,301 and 2,800 (NATIONAL CURRENCY)" ~ 4,
                                qc14ab_corr == "Between 2,801 and 3,300 (NATIONAL CURRENCY)" ~ 5, 
                                qc14ab_corr == "Between 3,301 and 3,900 (NATIONAL CURRENCY)" ~ 6, 
                                qc14ab_corr == "Between 3,901 and 4,600 (NATIONAL CURRENCY)" ~ 7, 
                                qc14ab_corr == "Between 4,601 and 5,400 (NATIONAL CURRENCY)" ~ 8, 
                                qc14ab_corr == "Between 5,401 and 6,800 (NATIONAL CURRENCY)" ~ 9,
                                qc14ab_corr == "More than 6,800 (NATIONAL CURRENCY)" ~ 10.
  ))


sum(is.na(data_AU$Income_cat)) #0 NA removed
table(data_AU$Income_cat) #now there is 768 data points
class(data_AU$Income_cat) #numeric
levels(as.factor(data_AU$Income_cat)) #nature order: "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10"
is.ordered(data_AU$Income_cat) 

#treatment of variable qa1_1 Personal responsibility to limit climate change
table(data_AU$qa1_1)
#transforming "Don't know (SPONTANEUOUS)" to NA
data_AU$qa1_1 <- dplyr::recode(data_AU$qa1_1,
                                     "Don't know (SPONTANEOUS)" = NA_character_)

#droping NAs of this variable 
sum(is.na(data_AU$qa1_1)) #16
data_AU <- data_AU %>%
  drop_na(qa1_1)
#transforming variable to numeric 
data_AU$qa1_1 <- as.numeric(data_AU$qa1_1)
#reversed linkert scale 
data_AU$qa1_1 <- 5-data_AU$qa1_1
#check variable status
table(data_AU$qa1_1)
class(data_AU$qa1_1) #numeric 
levels(as.factor(data_AU$qa1_1)) #nature order: "1" "2" "3" "4"

##treatment of variable qa12_1, qa12_2, qa12_3
#looking at the levels overview
table(data_AU$qa12_1)
table(data_AU$qa12_2)
table(data_AU$qa12_3)

#removing "Don't know (SPONTANEOUS)" from each variable
data_AU$qa12_1<- dplyr::recode(data_AU$qa12_1,
                               "Don't know (SPONTANEOUS)" = NA_character_)
data_AU$qa12_2 <- dplyr::recode(data_AU$qa12_2,
                               "Don't know (SPONTANEOUS)" = NA_character_)
data_AU$qa12_3 <- dplyr::recode(data_AU$qa12_3,
                               "Don't know (SPONTANEOUS)" = NA_character_)

#droping NAs of this variable 
sum(is.na(data_AU$qa12_1)) #9
sum(is.na(data_AU$qa12_2)) #12
sum(is.na(data_AU$qa12_3)) #12
data_AU <- data_AU %>%
  drop_na(qa12_1)
data_AU <- data_AU %>%
  drop_na(qa12_2)
data_AU <- data_AU %>%
  drop_na(qa12_3)


#transforming to numeric 
data_AU$qa12_1 <- as.numeric(data_AU$qa12_1)
data_AU$qa12_2 <- as.numeric(data_AU$qa12_2)
data_AU$qa12_3 <- as.numeric(data_AU$qa12_3)
View(data_AU)


data_AU$qa12_1 <- 5-data_AU$qa12_1
data_AU$qa12_2 <- 5-data_AU$qa12_2
data_AU$qa12_3 <- 5-data_AU$qa12_3

#checking final status of the variables 
table(data_AU$qa12_1)
table(data_AU$qa12_2)
table(data_AU$qa12_3)
class(data_AU$qa12_1) #numeric
class(data_AU$qa12_2) #numeric
class(data_AU$qa12_3) #numeric
levels(as.factor(data_AU$qa12_3)) "1" "2" "3" "4"

### computing likert scales to see if the variables can be mixed
alpha(data_AU[,c("qa12_1", "qa12_2", "qa12_3")]) #0.67

#calculate the average of the 3 rows of public transportation perception
data_AU$PT_perception <- rowMeans(data_AU[c("qa12_1", "qa12_2", "qa12_3")])
View(data_AU)
##########################################

##statistical analysis
prop.table(table(data_AU$PT_bin)) #0- 0.7739726 1- 0.2260274
table(data_AU$PT_bin) #0-565. 1-165
prop.table(table(data_AU$Income_cat)) #1-0.08219178 2-0.14246575 3-0.11917808 4-0.12465753 5-0.11643836 6-0.13013699 7-0.14657534 8-0.07945205 9-0.03698630 10-0.02191781
table(data_AU$PT_perception) # 1-20    1.333-5  1.667-10  2-61  2.333-73  2.667-147  3-201  3.333-86   3.667-60   4-67
summary(data_AU$PT_perception)         
Mode(data_AU$PT_perception) # 3- 201
sd(data_AU$PT_perception) #0.6571824
table(data_AU$qa1_1) # 1-41  2-128  3-353  4-208
summary(data_AU$qa1_1)         
Mode(data_AU$qa1_1). #3-  353
sd(data_AU$qa1_1) #0.8281688

##ploting income distribution
install.packages("ggplot2")
library(ggplot2)
# Define income category labels
income_labels <- c(
  "1: < 1,300", "2: 1,300–1,800", "3: 1,801–2,300", "4: 2,301–2,800",
  "5: 2,801–3,300", "6: 3,301–3,900", "7: 3,901–4,600", "8: 4,601–5,400",
  "9: 5,401–6,800", "10: > 6,800"
)

# Create a bar plot
ggplot(data_AU, aes(x = factor(Income_cat))) +
  geom_bar(fill = "#A8E6A3") +
  labs(
    title = "Distribution of Household Income Categories in Austria",
    x = "Income Category (€)",
    y = "Number of Respondents"
  ) +
  scale_x_discrete(labels = income_labels) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#build the model
model <- glm(PT_bin ~ Income_cat + qa1_1 + PT_perception, data = data_AU, family = binomial) 
summary(model) #estimate for 1 unit change, depends on the units , significance (p-value) *** -> 0, ' ' outcomes are not significant, so they are valid for the sample but not for the population.  

anova(model) #likelihood test, see the one of session 8

#odds ratios - easier to report 
coefs <- coef(model)
slope.idx <- !grepl("\\|", names(coefs))
OR  <- exp(coefs[slope.idx])

CI  <- confint(model, type = "Wald")
CI  <- exp(CI[slope.idx, ]) 
round(cbind(OR, CI), 3)

#multicollinearity 
mc <- lm(as.numeric(PT_bin ) ~ Income_cat + qa1_1 + PT_perception, data = data_AU)
vif(mc)


