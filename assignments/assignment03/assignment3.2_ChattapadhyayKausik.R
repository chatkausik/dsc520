# Assignment: ASSIGNMENT 3.2
# Name: Chattapadhyay, Kausik
# Date: 2022-09-13

## Load the ggplot2 package
library(ggplot2)
library(qqplotr)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Users/kausik/desktop/MS Data Science/DSC 520/dsc520-stats-r-assignments")

## Load the "data/acs-14-1yr-s0201.csv" to
survey_df <- read.csv("data/acs-14-1yr-s0201.csv")
head(survey_df)

## i. List the name of each field and what you believe the data type and 
## intent is of the data included in each field (Example: Id - Data Type: 
## varchar (contains text and numbers) Intent: unique identifier for each row).

# Id  - Data Type: character (contains text and numbers) Intent: unique identifier for each row
# Id2 - Data Type: integer (contains whole integer) Intent: Unique integer identifier for each row
# Geography - Data Type: character (contains characters) Intent: Location name
# PopGroupID - Data Type: Integer (contains integer value) Intent: Population group id.
# POPGROUP.display.label - Data Type: Character (contain characters) Intent: population group label
# RacesReported - Data Type: integer (contains integer number) Intent: Total Population
# HSDegree - Data Type: float (contains numbers with decimals) Intent: Percentage of HS pass
# BachDegree - Data Type: float (contains numbers with decimals) Intent: Percentage of Bachelors degree

## ii. Run the following functions and provide the results: str(); nrow(); ncol()
str(survey_df)
nrow(survey_df)
ncol(survey_df)

## iii. Create a Histogram of the HSDegree variable using the ggplot2 package.
##      1. Set a bin size for the Histogram that you think best visuals the data 
##          (the bin size will determine how many bars display and how wide they are)
##      2. Include a Title and and appropriate X/Y axis labels on your Histogram Plot.

ggplot(data=survey_df, aes(x=HSDegree)) + geom_histogram(bins=25, binwidth = 2) +
    labs(title="HS Degree Distribution 2014", x = "High School Degree Percentage",
         y= "Frequency")

## iv. Answer the following questions based on the Histogram produced:
##      1. Based on what you see in this histogram, is the data distribution unimodal?
names(table(survey_df$HSDegree))[table(survey_df$HSDegree) == max(table(survey_df$HSDegree))]

# Multimodal as there are 4 occurences of "84.9" "85.5" "86.8" "89.1" "90.3" "92.3".

##      2. Is it approximately symmetrical?
mean(survey_df$HSDegree)
median(survey_df$HSDegree)
# Mean is 87.63 and median is 88.7 so it is not symmetrical.

##      3. Is it approximately bell-shaped?
sd(survey_df$HSDegree)
# Not bell-shaped.

##      4. Is it approximately normal?
y <- dnorm(survey_df$HSDegree, mean = mean(survey_df$HSDegree), 
           sd = sd(survey_df$HSDegree))
plot(survey_df$HSDegree, y)
# Not normal distribution.

##      5. If not normal, is the distribution skewed? If so, in which direction?
# Negatively skewed distribution

##      6. Include a normal curve to the Histogram that you plotted.
ggplot(survey_df, aes(x=HSDegree)) + geom_histogram(aes(y=..density.., bins=25)) +
    labs(title="HS Degree Distribution 2014", x = "High School Degree Percentage",
         y= "Frequency") + stat_function(fun=dnorm, color="red", 
        args=list(mean = mean(survey_df$HSDegree), sd = sd(survey_df$HSDegree)))

## Explain whether a normal distribution can accurately be used as a model for this data. 
# Since it is a negatively skewed distribution, normal distribution can not be used.

## v. Create a Probability Plot of the HSDegree variable.
ggplot(survey_df, aes(sample=HSDegree)) + stat_qq_point(color="red") +
    stat_qq_line(color="blue")

## vi. Answer the following questions based on the Probability Plot:
##      1. Based on what you see in this probability plot, is the distribution 
##          approximately normal? Explain how you know.
#          It is not a normal distribution as it is not a straight line and curved.
##      2. If not normal, is the distribution skewed? If so, in which direction? 
##          Explain how you know.
#           This is a negatively skewed distribution as the plot bends down and 
#           to the right of normal line.

## vii. Now that you have looked at this data visually for normality, you will 
## now quantify normality with numbers using the stat.desc() function. Include a 
## screen capture of the results produced.
library(pastecs)
stat.desc(survey_df$HSDegree)

## viii. In several sentences provide an explanation of the result produced for skew, 
## kurtosis, and z-scores. In addition, explain how a change in the sample size 
## may change your explanation?
#           skew - Negative
#           kurtosis - Platykurtic
#           z-scores - Positive Value
#           When the sample is changed to add new values in the lower side of the 
#           curve then we can get a normal distribution.