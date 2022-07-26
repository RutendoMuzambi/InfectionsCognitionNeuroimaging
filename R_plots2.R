
.libPaths("C:/Users/lsh1802273/Documents/R")
library(haven)
library(tidyverse)
library(ggplot2)

age <- read_excel("J:\\EHR-Working\\Rutendo\\Infections_cognition_UKB\\Data\\R_Datafiles\\baseline_age.xlsx")

###############Cognitive decline###############


age$Cohort <- haven::as_factor(age$Cohort)

age$age_cat <- haven::as_factor(age$age_cat)


legend_title <- "Infection category"

ggplot(data = age, aes(fill=Infection, y=Percentage, x=age_cat)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(x="Age Category (5 year age category)",y="Percentage of participants") +
  ggtitle("Percentage of participants with and without infections stratified by age in each cohort") +
  facet_wrap(~Cohort, nrow=1) +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold")) +
  theme (axis.text.x = element_text(size = 8)) +
  theme(axis.title.y = element_text(size = rel(0.8), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(0.8), angle = 00)) +
theme(legend.position = "bottom") +
  scale_fill_brewer(palette = 'Set2') +
  
  
  scale_colour_hue(name = "Infection category")

  scale_color_manual(name="Cylinders")

theme(legend.title = "Infection category") +

  

age_bar

###############Neuroimaging###############

age <- read_dta("J:\\EHR-Working\\Rutendo\\Infections_cognition_UKB\\Data\\R_Datafiles\\age.dta")

age$Timepoint <- haven::as_factor(age$Timepoint)

age$age_cat <- haven::as_factor(age$age_cat)

age_bar <-  ggplot(data = age, aes(fill=Infection_cat, y=Percentage, x=age_cat)) + 
  geom_bar(position="dodge", stat="identity") +
  ggtitle("Neuroimaging") +
  facet_wrap(~infection_cat, nrow=1) +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold")) +
  theme (axis.text.x = element_text(size = 8)) +
  scale_fill_brewer(palette = 'Set2') +
  theme(axis.title.y = element_text(size = rel(0.8), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(0.8), angle = 00)) +
