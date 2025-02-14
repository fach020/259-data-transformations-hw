#PSYC 259 Homework 2 - Data Transformation
#For full credit, provide answers for at least 7/10 (7/10)

#List names of students collaborating with: 

### SETUP: RUN THIS BEFORE STARTING ----------

#Load packages
library(tidyverse)
ds <- read_csv("data_raw/rolling_stone_500.csv")
  
### Question 1 ---------- 

#Use glimpse to check the type of "Year". 
#Then, convert it to a numeric, saving it back to 'ds'
#Use typeof to check that your conversion succeeded

glimpse(ds)
ds <- mutate(ds, Year = as.numeric(str_remove_all(Year, "[^0-9]")))
#Mcomment: you don't need the str_remove_all function, you can just do as.numeric(Year)

typeof(ds$Year)
is.numeric(ds$Year)


### Question 2 ---------- 

# Using a dplyr function,
# change ds so that all of the variables are lowercase

ds <- ds %>% rename_all(tolower)


### Question 3 ----------

# Use mutate to create a new variable in ds that has the decade of the year as a number
# For example, 1971 would become 1970, 2001 would become 2000
# Hint: read the documentation for ?floor

?floor
ds <- mutate(ds, decade = floor(year/10)*10)


### Question 4 ----------

# Sort the dataset by rank so that 1 is at the top

ds <- arrange(ds, rank)

#Mcomment: Remmeber you can also start with your data frame and then use pipes, this makes it easier when you want to string together functions
ds <- ds %>% arrange(rank) #you can leave data out of arrange(), since it's at the beginning of the function

### Question 5 ----------

# Use filter and select to create a new tibble called 'top10'
# That just has the artists and songs for the top 10 songs

top10 <- filter(ds, rank <= 10) %>% select(artist, song)

#Mcomment: Remmeber you can also start with your data frame and then use pipes, this makes it easier when you want to string together functions
top10 <- ds %>% filter(rank <= 10) %>% select(artist, song) #you can leave data out of filter(), since it's at the beginning of the function


### Question 6 ----------

# Use summarize to find the earliest, most recent, and average release year
# of all songs on the full list. Save it to a new tibble called "ds_sum"

ds_sum <- summarize(ds, earliest = min(year), most_recent = max(year), average = mean(year))
#Mcomment: The key also includes na.rm=T in the summarize commands, may not be relevant for this data but in general good to ignore NAs (or know how to)
ds_sum <- ds %>% summarize(min_yr = min(year, na.rm = T),
                 max_yr = max(year, na.rm = T),
                 mean_yr = mean(year, na.rm = T))

### Question 7 ----------

# Use filter to find out the artists/song titles for the earliest, most 
# recent, and average-ist years in the data set (the values obtained in Q6). 
# Use one filter command only, and sort the responses by year

filter(ds, year == 1879 | year == 2020 | year == 1980) %>% arrange(year)

#Mcomment: Perfect! You can also reference the names of the calculations if you didn't want to hardcode the year
ds %>% filter(year == round(ds_sum$min_yr) | 
                year == round(ds_sum$mean_yr) | 
                year == round(ds_sum$max_yr) ) %>% arrange(year)

### Question 8 ---------- 

# There's and error here. The oldest song "Brass in Pocket"
# is from 1979! Use mutate and ifelse to fix the error, 
# recalculate decade, and then
# recalculate the responses from Questions 6-7 to
# find the correct oldest, averag-ist, and most recent songs

#ANSWER

#Key
ds  <- ds %>% mutate(year = ifelse(song == "Brass in Pocket", 1979, year),
                     decade = floor(year/10)*10) 
ds %>% summarize(min_yr = min(year, na.rm = T),
                 max_yr = max(year, na.rm = T),
                 mean_yr = mean(year, na.rm = T))
ds %>% filter(year == 1937 | year == 1980 | year == 2020) %>% arrange(year)

### Question 9 ---------

# Use group_by and summarize to find the average rank and 
# number of songs on the list by decade. To make things easier
# filter out the NA values from decade before summarizing
# You don't need to save the results anywhere
# Use the pipe %>% to string the commands together

#ANSWER

#Key
ds %>% filter(!is.na(decade)) %>% 
  group_by(decade) %>% 
  summarize(mean_rank = mean(rank), n_songs = n())

### Question 10 --------

# Look up the dplyr "count" function
# Use it to count up the number of songs by decade
# Then use slice_max() to pull the row with the most songs
# Use the pipe %>% to string the commands together

#ANSWER

#Key
ds %>% count(decade) %>% slice_max(n)
  
