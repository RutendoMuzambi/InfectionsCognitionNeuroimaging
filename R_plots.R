

library(haven)
library(tidyverse)
library(ggplot2)


###############REACTION TIME###############

RT <- read_dta("J:\\EHR-Working\\Rutendo\\Infections_cognition_UKB\\Data\\R_Datafiles\\reaction_time.dta")

RT$Timepoint <- haven::as_factor(RT$Timepoint)

RT$age_cat <- haven::as_factor(RT$age_cat)


RT_bar <- ggplot(data = RT, aes(fill=Timepoint, y=mean_reaction_time, x=age_cat)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(x="Age Category (5 year age category)",y="Mean reaction time (milliseconds)") +
  ggtitle("Reaction time") +
  facet_wrap(~infection_cat, nrow=1) +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold")) +
  theme (axis.text.x = element_text(size = 8)) +
  theme(axis.title.y = element_text(size = rel(0.8), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(0.8), angle = 00)) +
  scale_fill_brewer(palette = 'Set2') +
theme(legend.position = "none")
RT_bar

###############PAIRS###############

pairs <- read_dta("J:\\EHR-Working\\Rutendo\\Infections_cognition_UKB\\Data\\R_Datafiles\\pairs.dta")

pairs$Timepoint <- haven::as_factor(pairs$Timepoint)

pairs$age_cat <- haven::as_factor(pairs$age_cat)

Pairs_bar <-  ggplot(data = pairs, aes(fill=Timepoint, y=pairs_match_score, x=age_cat)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(x="Age Category (5 year age category)",y="Mean errors on visual memory test") +
  ggtitle("Visual memory") +
  facet_wrap(~infection_cat, nrow=1) +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold")) +
  theme (axis.text.x = element_text(size = 8)) +
  scale_fill_brewer(palette = 'Set2') +
  theme(axis.title.y = element_text(size = rel(0.8), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(0.8), angle = 00)) +
 theme(legend.position = "none")
###############PAIRS###############
fluid <- read_dta("J:\\EHR-Working\\Rutendo\\Infections_cognition_UKB\\Data\\R_Datafiles\\fluid_intel.dta")

fluid$Timepoint <- haven::as_factor(fluid$Timepoint)

fluid$age_cat <- haven::as_factor(fluid$age_cat)


Fluid_bar <- ggplot(data = fluid, aes(fill=Timepoint, y=fluid_intel_rvscore, x=age_cat)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(x="Age Category (5 year age category)",y="Mean errors on fluid intelligence test") +
  ggtitle("Fluid intelligence") +
  facet_wrap(~infection_cat, nrow=1) +
  ###geom_text(aes(label = fluid_intel_rvscore), vjust = 1.5, colour = "white") +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold")) +
  theme (axis.text.x = element_text(size = 8)) +
  scale_fill_brewer(palette = 'Set2') +
  theme(axis.title.y = element_text(size = rel(0.8), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(0.8), angle = 00)) +
theme(legend.position = "none")


##p1 <- ggarrange(, D, ncol=2, common.legend = TRUE, legend = "bottom") 



prosp_mem <- read_dta("J:\\EHR-Working\\Rutendo\\Infections_cognition_UKB\\Data\\R_Datafiles\\prosp_mem.dta")

prosp_mem$Timepoint <- haven::as_factor(prosp_mem$Timepoint)

prosp_mem$age_cat <- haven::as_factor(prosp_mem$age_cat)

prosp_bars <-   ggplot(data = prosp_mem, aes(fill=Timepoint, y=percent, x=age_cat)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(x="Age Category (5 year age category)",y="Percentage of incorrect answers") +
  ggtitle("Prospective Memory") +
  facet_wrap(~infection_cat, nrow=1) +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold")) +
   theme (axis.text.x = element_text(size = 8)) +
  scale_fill_brewer(palette = 'Set2') +
  theme(axis.title.y = element_text(size = rel(0.8), angle = 90)) +
   theme(axis.title.x = element_text(size = rel(0.8), angle = 00)) +
  theme(legend.position = "none")

#install.packages("ggpubr")
library(ggpubr)
ggarrange(RT_bar, Pairs_bar, Fluid_bar, prosp_bars, ncol = 2, nrow = 2,
            common.legend = TRUE, legend = "bottom", labels = c("A", "B", "C", "D")) +
theme(plot.margin = unit(c(0.7,0.5,0.5,0.5), "cm"))
annotate_figure(figure,
                bottom = text_grob("Higher score represents poorer performance for all tests",
                                   face = "bold.italic", size = 11, x=0.4 ))

##figure + annotate("text", x = 4, y = 10, label = "Some text")


##rename(iris, petal_length = Petal.Length)
install.packages("expss")
library(expss)
fluid = apply_labels(fluid, Timepoint="Time point")
pairs = apply_labels(pairs, Timepoint="Time point")
prosp_mem = apply_labels(prosp_mem, Timepoint="Time point")
RT = apply_labels(RT, Timepoint="Time point")

