# Load the data and libraries

library(ggplot2)
library(dplyr)
library(tidyr)

df <- read.csv("pseudo_facebook (1).tsv", sep = "\t")


# Many interesting variables are derived from two or more others. For example, we might wonder how much of a person's network on
# a service like Facebook the user actively initiated. Two users with the same degree (or number of friends) might be very
# different if one initiated most of those connections on the service, while the other initiated very few. So it could be
# useful to consider this proportion of existing friendships that the user initiated. This might be a good predictor of how active
# a user is compared with their peers, or other traits, such as personality (i.e., is this person an extrovert?).

# Your task is to create a new variable called 'prop_initiated' in the Pseudo-Facebook data set. The variable should contain
# the proportion of friendships that the user initiated.

# Filter out people with no friends then add new variable 'prop_initiated'
dfPropInit <- df %>% filter(friend_count > 0) 
              %>% mutate(prop_initiated = friendships_initiated/friend_count)

# Create a line graph of the median proportion of friendships initiated ('prop_initiated') vs.
# tenure and color the line segment by year_joined.bucket.

# Recall, we created year_joined.bucket in Lesson 5 by first creating year_joined from the variable tenure.
# Then, we used the cut function on year_joined to create four bins or cohorts of users.

# (2004, 2009]
# (2009, 2011]
# (2011, 2012]
# (2012, 2014]

# Create year_joined variable
dfPropInit <- mutate(dfPropInit, year_joined = floor(2014 - tenure/365))

# Cut year_joined into 4 bins
dfPropInit <- mutate(dfPropInit, year_joined.bucket = cut(dfPropInit$year_joined, breaks = c(2004,2009,2011,2012,2014)))

# Plot line graph
ggplot(aes(x = tenure, y = prop_initiated), data = dfPropInit) + 
  geom_line(aes(color = year_joined.bucket), stat = "summary", fun.y = median) +
  labs(title = "Friendships Initiated by Tenure on Facebook", x = "Tenure", 
       y = "Proportion of Friendships Initiated")

# Smooth the last plot you created of prop_initiated vs tenure colored by
# year_joined.bucket. You can bin together ranges of tenure or add a smoother to the plot.
ggplot(aes(x = tenure, y = prop_initiated), data = dfPropInit) + 
  geom_line(aes(color = year_joined.bucket), stat = "summary", fun.y = median) +
  stat_smooth() +
  labs(title = "Friendships Initiated by Tenure on Facebook", x = "Tenure", 
       y = "Proportion of Friendships Initiated")


