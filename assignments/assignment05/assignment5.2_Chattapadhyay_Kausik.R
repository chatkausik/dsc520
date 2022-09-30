# Assignment: ASSIGNMENT 5.2
# Name: Chattapadhyay, Kausik
# Date: 2022-09-29

## Load the ggplot2 package
library(ggplot2)
library(plyr)
library(dplyr)
library(readxl)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Users/kausik/desktop/MS Data Science/DSC 520/dsc520-stats-r-assignments")

## Load the Housing Dataset
housingDF <- read_excel("data/week-7-housing.xlsx", sheet="Sheet2") 
# Renamimg the field names
colnames(housingDF)[2] <- "Sale_Price"
colnames(housingDF)[1] <- "Sale_Date"
str(housingDF)

### a.Using the dplyr package, use the 6 different operations to analyze/transform 
### the data - GroupBy, Summarize, Mutate, Filter, Select, and Arrange – Remember 
### this isn’t just modifying data, you are learning about your data also – so play 
### around and start to understand your dataset in more detail.

housingDF %>% 
    # Select few important fields from housing dataset
    select(Sale_Date, Sale_Price, zip5, lon, lat, square_feet_total_living:year_built) %>%
    # Calculate new field bath_total
    mutate(bath_total = bath_full_count + bath_half_count + bath_3qtr_count) %>%
    # Remove unnecessary bath related fields.
    select(-bath_full_count, -bath_half_count, -bath_3qtr_count)  %>%
    # Filter the records from Jan 2015 having sale price 100K and living area > 1500 SQFT
    filter(Sale_Date >= "2015-01-01", Sale_Price > 100000, 
           square_feet_total_living > 1500) %>%
    # Grouping the data by year_built and zip codes
    group_by(year_built, zip5)  %>%
    # Summarize the data by calculating median sales price and average square feet
    summarize(median_sales_price = median(Sale_Price), 
              avg_sqft = mean(square_feet_total_living))  %>%
    # Sort the data by median sales price in descending order
    arrange(desc(median_sales_price))


### b. Using the purrr package – perform 2 functions on your dataset.  You could 
### use zip_n, keep, discard, compact, etc.
library(purrr)

housingDF   %>% 
    select(Sale_Date, Sale_Price, zip5, square_feet_total_living:year_built) %>%
    split(.$zip5) %>%
    map(summary)  

## keep() and discard() allow you to filter a vector based on a predicate function.
housingDF %>%
    select(Sale_Date, Sale_Price, zip5, square_feet_total_living:year_built) %>%
    keep(function(x) mean(x) >  200000)

housingDF %>%
    select(Sale_Date, Sale_Price, zip5, square_feet_total_living:year_built) %>%
    discard(function(x) mean(x) >  200000)

## compact() is a helpful wrapper that throws away empty elements of a list.
housingDF %>%
    select(Sale_Date, Sale_Price, zip5, square_feet_total_living:year_built) %>%
    compact()

### c. Use the cbind and rbind function on your dataset

## Splitting the data frame in two data frames.
housingDF1 <- housingDF %>%
    select(Sale_Date, Sale_Price, zip5)

housingDF2 <- housingDF %>%
    select(square_feet_total_living:year_built)

## cbind() function to join two sets of columns together into a single dataframe.
housingDF3 <- cbind(housingDF1, housingDF2)
head(housingDF3)

## rbind() to combine dataframes by rows.
housingDFX <- housingDF %>%
    select(Sale_Date, Sale_Price, zip5, square_feet_total_living:year_built) %>%
    filter(Sale_Date > "2016-01-01")
tail(housingDFX)

housingDFY <- housingDF %>%
    select(Sale_Date, Sale_Price, zip5, square_feet_total_living:year_built) %>%
    filter(Sale_Date > "2015-01-01", Sale_Date < "2016-01-01")
tail(housingDFY)

housingDFXY <- rbind(housingDFX, housingDFY)
tail(housingDFXY)

### d. Split a string, then concatenate the results back together
library(stringr)

addrList <- str_split(housingDF$addr_full, pattern=" ")
addrMatrix <- data.frame(Reduce(rbind, addrList))
names(addrMatrix) <- c("House_Number", "Street_Addr_1", "Street_Addr_2", "Sreet_Addr_3")
housingDFA <- housingDF %>%
    select(Sale_Date, Sale_Price, zip5, addr_full)

housingDFA <- cbind(housingDFA, addrMatrix)

housingDFA$full_addr_2 <- paste(housingDFA$House_Number, housingDFA$Street_Addr_1,
                            housingDFA$Street_Addr_2, housingDFA$Street_Addr_3)

head(housingDFA)
