# Assignment: ASSIGNMENT 4.2
# Name: Chattapadhyay, Kausik
# Date: 2022-09-21

## Load the ggplot2 package
library(ggplot2)
library(plyr)
library(dplyr)
library(readxl)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Users/kausik/desktop/MS Data Science/DSC 520/dsc520-stats-r-assignments")

## Load the `2014 American Community Survey` to
survey_df <- read.csv("data/acs-14-1yr-s0201.csv")
head(survey_df)

## Load the `Housing dataset' to
housing_df <- read_excel("data/week-7-housing.xlsx", sheet="Sheet2") 

# Renamimg the field names
colnames(housing_df)[2] <- "Sale_Price"
colnames(housing_df)[1] <- "Sale_Date"
str(housing_df)

## A. Use the apply function on a variable in your dataset
# checking if any NAs on sale price.
any(is.na(housing_df$Sale_Price))

# apply() on sale price to get mean sale price.
apply(data.frame(housing_df$Sale_Price), 2, mean)

# Zip code wise average sale using ddply()
avg_sale <- function(data) {
    c(avg_sale = with(data, mean(Sale_Price)))
}
ddply(housing_df, .variables = "zip5", .fun = avg_sale)

# Date wise average sale using ddply()
abp <- ddply(housing_df, .variables = "Sale_Date", .fun = avg_sale)
head(abp)
abp <- abp[order(abp$avg_sale, decreasing = TRUE),]
head(abp, 10)

## B. Use the aggregate function on a variable in your dataset
# Aggregate sale price by zip codes.
aggregate(Sale_Price ~ zip5, housing_df, each(mean, median))

# Aggregate sale price by year built.
aggregate(cbind(Sale_Price, sq_ft_lot) ~ year_built, housing_df, each(mean, median))

# Aggregate sale price by lat, lon.
head(aggregate(Sale_Price ~ lat + lon, housing_df, each(mean, median)))

## C. Use the plyr function on a variable in your dataset – more specifically, 
## I want to see you split some data, perform a modification to the data, and 
## then bring it back together.
# Extracting only 2016 data
housing_df_2016 <- housing_df[housing_df$Sale_Date >= '2016-01-01',]
# Function to create per square ft sale price
avg_sale <- function(data) {
    c(avg_sale = with(data, mean(Sale_Price)))
}

# apply ddply() to split the data , perform action and return data frame
ddply(housing_df, .variables = "zip5", .fun = avg_sale)
## D. Check distributions of the data
#
ggplot(housing_df, aes(x=Sale_Price)) + 
    labs(x = "House Sale Price", y = "Density", title = "Sale Price distribution") + 
    geom_histogram(aes(y=..density..), color="black", fill="white", show.legend = F) +
    stat_function(fun=dnorm, args = list(mean = mean(housing_df$Sale_Price, na.rm = T), 
    sd = sd(housing_df$Sale_Price, na.rm = T)), color="black", size=1)

## E. Identify if there are any outliers
summary(housing_df$Sale_Price)
# Missing value analysis
any(is.na(housing_df$Sale_Price))
summary(is.na(housing_df$Sale_Price))
# From the above result, it is clear that the dataset sale price contains NO Missing Values.
housing_df$zip5 = as.factor(housing_df$zip5)
ggplot(housing_df, aes(y=Sale_Price, x=zip5, fill=zip5))  + 
    labs(x="Zip Code", y="House Sale Price", title="Sale_Price box plot") +
    geom_boxplot(outlier.colour="red", outlier.shape=8,
                 outlier.size=4) +
    stat_summary(fun.y=mean, geom="point", shape=23, size=4) +  theme_minimal()
                                                         
# Box plot clearly shows some outliers specially in 98052 and 98053 zip codes 
# with very low sale price and some out of range.

## F. Create at least 2 new variables
# Creating per square ft sale price
housing_df$sq_ft_lot_price <- housing_df$Sale_Price / housing_df$sq_ft_lot
housing_df$sq_ft_living_price <- housing_df$Sale_Price / housing_df$square_feet_total_living

# Creating total bath count variable
housing_df$total_bath_count <- housing_df$bath_full_count + 
    housing_df$bath_half_count + housing_df$bath_3qtr_count


