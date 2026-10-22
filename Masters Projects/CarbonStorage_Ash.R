#CarbonStorage_Ash (Fra_exc)

#Recent Mortality
#Quantify recent mortality for ash for the two canopy layers using data from ‘Lebendige Luppe’ project

rm(list=ls())

install.packages('tidyverse')
install.packages('readxl')
install.packages('dplyr')
install.packages('tidyr')

library(tidyverse)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

setwd("/Users/jimenagomezmatzui/Documents/Jimena/1_MasterLeipzig/WiSe25/Interdisciplinary/carbonstorage") #set working directory
LLF <- read_xlsx("LLF_Rohdaten_Canopy_zugeordnet.xlsx", sheet= 1) #importing data set
ETS <- read_xlsx("ETS_tree_inventory_2016-2024_long-format.xlsx", sheet= 2)
DGL <- read_xlsx("DGL.xlsx", sheet= 1)
View(LLF)
length(unique(LLF$treeID))
table(LLF$sp)
View(ETS)
length(unique(ETS$Tree_ID))
table(ETS$Year)
View(DGL)
#select only the columns of interest and filter for ash
LLF_ash <- (select(filter(LLF, sp == "Fra_exc"), treeID, sp, cl))
View(LLF_ash)
length(LLF_ash$treeID)
table(LLF_ash$cl) #20 "NA"
table(LLF_ash$sp) 
table(LLF$subplot) 
#there is not information about the canopy layer of some trees, so we need to remove them before filtering 
sum(is.na(LLF_ash$cl))  
#convert "NA" in real NAs
LLF_ash$cl <- dplyr::recode(LLF_ash$cl,"NA" = NA_character_) 
sum(is.na(LLF_ash$cl)) 
#delete NAs
LLF_ash <- LLF_ash %>%
  drop_na(cl)  #from 1039 to 1019

#filter ETS with LLF
#ETS_ash <- ETS %>%
#  filter(Tree_ID %in% LLF_ash$treeID)

#View(ETS_ash)
#length(unique(ETS_ash$Tree_ID))



#join tables
ETS_ash_cl <-
  ETS %>%
  dplyr::left_join(LLF_ash, by = c("Tree_ID" = "treeID")) %>%
  dplyr::left_join(DGL,     by = c("PLOTID"  = "plot_no"))

View(ETS_ash_cl)
table(ETS_ash_cl$sp, useNA = "ifany") #8853, no NAS
table(ETS_ash_cl$cl, useNA = "ifany") #1= 7804, 2=1049
table(ETS_ash_cl$PLOTID, useNA = "ifany") 
table(ETS_ash_cl$Year) #2016-2024

#Delete NAs
table(ETS_ash_cl$ETS) #0-43, 1-433, 2-1467, 3-3342, 4-1026, 5-708, 6-1834
table(ETS_ash_cl$ETS, useNA = "ifany") #273
ETS_ash_cl$ETS[ETS_ash_cl$ETS == "NA"] <- NA 
ETS_ash_cl$ETS <- as.numeric(ETS_ash_cl$ETS)
sum(is.na(ETS_ash_cl$ETS)) #273
ETS_ash_cl <- ETS_ash_cl %>%
  drop_na(ETS)#from 10089 to 9495
table(ETS_ash_cl$cl, useNA = "ifany")
ETS_ash_cl$cl[ETS_ash_cl$cl == "NA"] <- NA 
ETS_ash_cl$cl <- as.numeric(ETS_ash_cl$cl)
sum(is.na(ETS_ash_cl$cl)) #642
ETS_ash_cl <- ETS_ash_cl %>%
  drop_na(cl) #from 9495 to 8853


table(ETS_ash_cl$gwl, useNA = "ifany") #dry: 2535, intermediate: 2422, moist: 3896


length(unique(ETS_ash_cl$Tree_ID)) #1014

#Mutate death vs alive trees
ETS_ash_cl<- ETS_ash_cl%>%
  mutate(ETS_bin = case_when(ETS == 5 ~ 0,  #death
                            ETS == 6 ~ 0, #death
                            ETS == 0 ~ 1, 
                            ETS == 1 ~ 1,
                            ETS == 2 ~ 1, 
                            ETS == 3 ~ 1, 
                            ETS == 4 ~ 1. 
  ))
ETS_ash_cl$ETS_bin <- as.numeric(ETS_ash_cl$ETS_bin)
table(ETS_ash_cl$ETS_bin) #0= 2542, 1 = 6311
View(ETS_ash_cl)

#creating a function to extract alive trees each year
alive_trees <- function(data, cl_value, gw_level) {
  years <- sort(unique(data$Year))
  
  result <- lapply(years, function(y) {
    data %>%
      filter(Year == y, cl == cl_value, gwl == gw_level) %>%
      summarise(n_ones = sum(ETS_bin == 1, na.rm = TRUE)) %>%
      pull(n_ones)
  })
  
  names(result) <- years
  return(result)
}


alive_trees2 <- function(data, cl_value,gw_level) {
  
  # Filter only the cluster of interest
  df <- data %>%
    filter(cl == cl_value, gwl == gw_level) %>%
    arrange(Year)
  
  years <- sort(unique(df$Year))
  surviving_ids <- NULL
  results <- list()
  
  for (y in years) {
    df_year <- df %>% filter(Year == y)
    
    if (is.null(surviving_ids)) {
      # First year: take all trees that are alive
      surviving_ids <- df_year %>%
        filter(ETS_bin == 1) %>%
        pull(Tree_ID)
    } else {
      # Later years: keep only previous-year survivors
      surviving_ids <- df_year %>%
        filter(Tree_ID %in% surviving_ids, ETS_bin == 1) %>%
        pull(Tree_ID)
    }
    
    results[[as.character(y)]] <- length(surviving_ids)
  }
  
  return(results)
}

#function for annual_mortality
annual_mortality <- function(alive_trees2) {
  
  years <- as.numeric(names(alive_trees2))
  alive <- unlist(alive_trees2)
  
  # Mortality proportion between consecutive years
  mort_prop <- (alive[-length(alive)] - alive[-1]) / alive[-length(alive)]
  
  # Annual mortality (1-year interval)
  annual_mort <- -log(1 - mort_prop) * 100
  
  # Return only the requested columns
  df <- data.frame(
    Year_start = years[-length(years)],
    annual_mortality_percent = annual_mort
  )
  
  return(df)
}

#function for plotting 
plot_mortality <- function(data,
                           color,
                           mean_value,
                           max_value,
                           max_year,
                           title_text = "Annual Tree Mortality Rate",
                           y_label = "Annual Mortality (%)") {
  
  ggplot(data, aes(x = Year_start, y = annual_mortality_percent)) +
    geom_point(color =  color, size = 3) +
    geom_line(color = color, size = 1) +
    
    # Mean line
    geom_hline(
      yintercept = mean_value,
      linetype = "dashed",
      linewidth = 0.9,
      color = "grey50"
    ) +
    
    # Mean label
    annotate(
      "text",
      x = min(data$Year_start),
      y = mean_value,
      label = paste0("Mean = ", round(mean_value, 2), "%"),
      vjust = -1,
      hjust = 0,
      color = "grey20",
      size = 5
    ) +
    
    labs(
      title = title_text,
      x = "Year",
      y = y_label
    ) +
    
    theme_classic() +
    
    scale_x_continuous(breaks = data$Year_start)
}


## UNDERSTORY

###dry

alive_by_year_cl1_dry <- alive_trees2(ETS_ash_cl, cl_value= 1, gw_level= "dry")
annual_mortality_cl1_dry <- annual_mortality(alive_by_year_cl1_dry)
annual_mortality_cl1_dry
mean_cl1_dry <- mean(annual_mortality_cl1_dry$annual_mortality_percent)
max_cl1_dry <- max(annual_mortality_cl1_dry$annual_mortality_percent)
max_year1_dry <- annual_mortality_cl1_dry$Year_start[
  which.max(annual_mortality_cl1_dry$annual_mortality_percent)
]
plot_mortality(
  data = annual_mortality_cl1_dry,
  color= "blue",
  mean_value = mean_cl1_dry,
  max_value = max_cl1_dry,
  max_year = max_year1_dry,
  title_text = "Annual Tree Mortality Rate - Understory, Dry"
)


### intermediate

alive_by_year_cl1_int <- alive_trees2(ETS_ash_cl, cl_value= 1, gw_level= "intermediate")
annual_mortality_cl1_int <- annual_mortality(alive_by_year_cl1_int)
mean_cl1_int <- mean(annual_mortality_cl1_int$annual_mortality_percent)
plot_mortality(
  data = annual_mortality_cl1_int,
  color = "blue",
  mean_value = mean_cl1_int,
  max_value = max_cl1_int,
  max_year = max_year1_int,
  title_text = "Annual Tree Mortality Rate - Understory, Intermediate"
)

### moist

alive_by_year_cl1_moi <- alive_trees2(ETS_ash_cl, cl_value= 1, gw_level= "moist")
annual_mortality_cl1_moi <- annual_mortality(alive_by_year_cl1_moi)
mean_cl1_moi <- mean(annual_mortality_cl1_moi$annual_mortality_percent)
plot_mortality(
  data = annual_mortality_cl1_moi,
  color = "blue",
  mean_value = mean_cl1_moi,
  max_value = max_cl1_moi,
  max_year = max_year1_moi,
  title_text = "Annual Tree Mortality Rate - Understory, Moist"
)



## OVERSTORY

###dry

alive_by_year_cl2_dry <- alive_trees2(ETS_ash_cl, cl_value= 2, gw_level= "dry")
annual_mortality_cl2_dry <- annual_mortality(alive_by_year_cl2_dry)
annual_mortality_cl2_dry
mean_cl2_dry <- mean(annual_mortality_cl2_dry$annual_mortality_percent)
max_cl2_dry <- max(annual_mortality_cl2_dry$annual_mortality_percent)
max_year2_dry <- annual_mortality_cl2_dry$Year_start[
  which.max(annual_mortality_cl2_dry$annual_mortality_percent)
]
plot_mortality(
  data = annual_mortality_cl2_dry,
  color= "purple",
  mean_value = mean_cl2_dry,
  max_value = max_cl2_dry,
  max_year = max_year2_dry,
  title_text = "Annual Tree Mortality Rate - Overstory, Dry"
)


### intermediate

alive_by_year_cl2_int <- alive_trees2(ETS_ash_cl, cl_value= 2, gw_level= "intermediate")
annual_mortality_cl2_int <- annual_mortality(alive_by_year_cl2_int)
mean_cl2_int <- mean(annual_mortality_cl2_int$annual_mortality_percent)
plot_mortality(
  data = annual_mortality_cl2_int,
  color = "purple",
  mean_value = mean_cl2_int,
  max_value = max_cl2_int,
  max_year = max_year2_int,
  title_text = "Annual Tree Mortality Rate - Overstory, Intermediate"
)

### moist

alive_by_year_cl2_moi <- alive_trees2(ETS_ash_cl, cl_value= 2, gw_level= "moist")
annual_mortality_cl2_moi <- annual_mortality(alive_by_year_cl2_moi)
mean_cl2_moi <- mean(annual_mortality_cl2_moi$annual_mortality_percent)
plot_mortality(
  data = annual_mortality_cl2_moi,
  color = "purple",
  mean_value = mean_cl2_moi,
  max_value = max_cl2_moi,
  max_year = max_year2_moi,
  title_text = "Annual Tree Mortality Rate - Overstory, Moist"
)





## Create summary Tables---

# Understory (CL1)
cl1_dry  <- annual_mortality_cl1_dry
cl1_int  <- annual_mortality_cl1_int
cl1_moist <- annual_mortality_cl1_moi

# Overstory (CL2)
cl2_dry  <- annual_mortality_cl2_dry
cl2_int  <- annual_mortality_cl2_int
cl2_moist <- annual_mortality_cl2_moi




mortality_summary <- bind_rows(
  
  # Understory (CL1)
  compute_means(annual_mortality_cl1_dry)   %>% 
    mutate(Layer = "Understory", Ground_level = "Dry"),
  
  compute_means(annual_mortality_cl1_int)   %>% 
    mutate(Layer = "Understory", Ground_level = "Intermediate"),
  
  compute_means(annual_mortality_cl1_moi) %>% 
    mutate(Layer = "Understory", Ground_level = "Moist"),
  
  # Overstory (CL2)
  compute_means(annual_mortality_cl2_dry)   %>% 
    mutate(Layer = "Overstory", Ground_level = "Dry"),
  
  compute_means(annual_mortality_cl2_int)   %>% 
    mutate(Layer = "Overstory", Ground_level = "Intermediate"),
  
  compute_means(annual_mortality_cl2_moi) %>% 
    mutate(Layer = "Overstory", Ground_level = "Moist")
  
) %>%
  select(Layer, Ground_level, Mean_all_years, Mean_2019_2024) %>%
  mutate(
    Mean_all_years  = round(Mean_all_years, 2),
    Mean_2019_2024 = round(Mean_2019_2024, 2)
  )


library(knitr)
kable(mortality_summary, caption = "Mortality Means by Canopy layer and Ground Level")

install.packages('kableExtra')
library(kableExtra)

mortality_summary %>%
  kable("html", caption = "Mortality Summary by Canopy layer and Ground Level") %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = FALSE,
    font_size = 13
  ) %>%
  column_spec(1, bold = TRUE) %>%
  row_spec(0, bold = TRUE, background = "lightgray")










#### codigo viejo

#annual mortality for overstory
alive_by_year_cl2 <- alive_trees2(ETS_ash_cl, cl_value= 2)
alive_by_year_cl2 
annual_mortality_cl2 <- annual_mortality(alive_by_year_cl2)
annual_mortality_cl2
mean_cl2 <-mean(annual_mortality_cl2$annual_mortality_percent)
mean_cl2
max_cl2 <- max(annual_mortality_cl2$annual_mortality_percent)
max_year2 <- annual_mortality_cl2$Year_start[
  which.max(annual_mortality_cl2$annual_mortality_percent)
]

#ploting for oversty
ggplot(annual_mortality_cl2, aes(x = Year_start, y = annual_mortality_percent)) +
  geom_point(color = "green", size = 3) +
  geom_line(color = "green", size = 1) +
  geom_hline(
    yintercept = mean_cl2,
    linetype = "dashed",
    linewidth = 0.9,
    color = "grey50"
  ) +
  
  # Mean label
  annotate(
    "text",
    x = min(annual_mortality_cl2$Year_start),
    y = mean_cl2,
    label = paste0("Mean = ", round(mean_cl2, 2), "%"),
    vjust = -0.5,
    hjust = 0,
    color = "grey20",
    size = 3
  ) +
  
  # Max label (now guaranteed to work)
  annotate(
    "text",
    x = max_year2,
    y = max_cl2,
    label = paste0("Max = ", round(max_cl2, 2), "%"),
    vjust = -1,
    color = "grey20",
    size = 3
  ) +
  
  labs(
    title = "Annual Tree Mortality Rate-Overstory",
    x = "Year",
    y = "Annual Mortality (%)"
  ) +
  theme_classic() +
  scale_x_continuous(
    breaks = annual_mortality_cl2$Year_start
  )


#### Calculate mortality proportion understory
#mort_16_24_us <- (alive_ash_2016_us - alive_ash_2024_us) / alive_ash_2016_us

# Calculate annual mortality (%)
#annual_mortality_16_24_us <- -log(1 - mort_16_24_us) / 8 * 100

# Print result
#annual_mortality_16_24_us #10.0822

#alive_ash_2020_us <- ETS_ash_cl %>% 
#  filter(Year == 2020, cl == 1) %>% 
#  summarise(n_ones = sum(ETS_bin == 1)) %>% 
#  mutate(n_ones = as.numeric(n_ones)) %>%
#  pull(n_ones)

#### Calculate mortality proportion overstory
#mort_16_24_os <- (alive_ash_2016_os - alive_ash_2024_os) / alive_ash_2016_os

# Calculate annual mortality (%)
#annual_mortality_16_24_os <- -log(1 - mort_16_24_os) / 8 * 100

# Print result
#annual_mortality_16_24_os #9.093

