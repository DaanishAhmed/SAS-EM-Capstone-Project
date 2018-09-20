# DATA 670 Capstone Project
# Written by Daanish Ahmed
# Semester Summer 2018
# Professor Steve Knode
# June 16, 2018

# This R script involves analyzing 3 datasets on storm data collected across 
# the U.S. during 2017 by NOAA and the NWS.  My analysis involves predicting 
# whether a given storm will result in deaths.  This component of the project 
# consists of importing the data into R, cleaning the datasets, combining 
# them into a single data frame, and exporting the cleaned datasets.  Finally,
# it will involve a text mining analysis to study keywords in the storm event
# narratives and determine which terms are commonly used to describe dangerous
# storms.  This part of the script will involve data processing on the texts 
# and creating a word cloud that shows the 60 most frequent terms.




# This section involves opening the dataset and initializing the packages 
# that are used in this script.

# Sets the working directory for this project.  Please change this directory 
# to whichever directory you are using, and make sure that all files are placed 
# in that location.
setwd("~/Class Documents/2017-18 Summer/DATA 670/Capstone Project/data")

# Installs the required packages (please only install packages that have not 
# been installed yet, and only install them once).

# Remove the # symbol to install the packages.
# install.packages("tm")
# install.packages("SnowballC")
# install.packages("wordcloud")

# Loads the packages we need for this project.
library(tm)                 # Used for text mining
library(SnowballC)          # Used for text mining
library(wordcloud)          # Used for word clouds

# Loads the three datasets used in the analysis.
storm_details <- read.csv("StormEvents_details-ftp_v1.0_d2017_c20180525.csv", 
                          head=TRUE, sep=",", na.strings = c("", "NA"))
fatalities <- read.csv("StormEvents_fatalities-ftp_v1.0_d2017_c20180525.csv", 
                       head=TRUE, sep=",", na.strings = c("", "NA"))
locations <- read.csv("StormEvents_locations-ftp_v1.0_d2017_c20180525.csv", 
                      head=TRUE, sep=",", na.strings = c("", "NA"))

# End of initializing the data.




# This section of code covers data preprocessing.

# Displays the descriptive statistics in each dataset.
summary(storm_details)
summary(fatalities)
summary(locations)

# The following commands create the target variable "casualties," which indicates 
# whether a given storm resulted in any deaths (direct or indirect).
storm_details$casualties <- "no"
storm_details$casualties[storm_details$DEATHS_DIRECT > 0 | storm_details$DEATHS_INDIRECT > 0] <- "yes"
storm_details$casualties <- as.factor(storm_details$casualties)

# The following commands create another feature "injuries," which is used to represent 
# whether a storm resulted in any direct or indirect injuries.
storm_details$injuries <- "no"
storm_details$injuries[storm_details$INJURIES_DIRECT > 0 | storm_details$INJURIES_INDIRECT > 0] <- "yes"
storm_details$injuries <- as.factor(storm_details$injuries)

# Removes correlated variables such that the remaining variables are no longer 
# correlated to any other feature.
storm_details$BEGIN_YEARMONTH <- NULL
storm_details$STATE_FIPS <- NULL
storm_details$CZ_NAME <- NULL

# Removes unnecessary variables from the analysis.
storm_details$END_YEARMONTH <- NULL
storm_details$YEAR <- NULL
storm_details$DATA_SOURCE <- NULL
fatalities$FAT_TIME <- NULL

# Checks to see the number of missing values in each variable per data frame.
apply(storm_details, 2, function(storm_details) sum(is.na(storm_details)))
apply(fatalities, 2, function(fatalities) sum(is.na(fatalities)))
apply(locations, 2, function(locations) sum(is.na(locations)))

# The following commands handle missing values in the "storm details" dataset.

# For beginning and ending range, azimuth, location, latitude, and longitude, I will remove the rows
# with missing values.  This is because their missing values are all in the same rows.
storm_details <- storm_details[complete.cases(storm_details$BEGIN_RANGE),]

# Variables that are missing more than 20,000 cases will be removed from the analysis.
storm_details$MAGNITUDE <- NULL
storm_details$MAGNITUDE_TYPE <- NULL
storm_details$FLOOD_CAUSE <- NULL
storm_details$CATEGORY <- NULL
storm_details$TOR_F_SCALE <- NULL
storm_details$TOR_LENGTH <- NULL
storm_details$TOR_WIDTH <- NULL
storm_details$TOR_OTHER_WFO <- NULL
storm_details$TOR_OTHER_CZ_STATE <- NULL
storm_details$TOR_OTHER_CZ_FIPS <- NULL
storm_details$TOR_OTHER_CZ_NAME <- NULL

# The following commands handle missing values in the "fatalities" dataset.

# Replaces the missing values for "fatality age" with the mean age.
fatalities$FATALITY_AGE[is.na(fatalities$FATALITY_AGE)] <- mean(fatalities$FATALITY_AGE, na.rm=TRUE)

# Removes the rows with missing values for fatality sex.
fatalities <- fatalities[complete.cases(fatalities$FATALITY_SEX),]

# Merges datasets into a single data frame.  Uses the "event ID" variable to 
# link all three datasets together.
storms <- merge(storm_details, fatalities, by="EVENT_ID", all.x = TRUE)
storms <- merge(storms, locations, by="EVENT_ID", all.x = TRUE)

# Exports the data files in .csv format.
write.csv(storm_details, "StormDetails_new.csv", row.names=F)
write.csv(fatalities, "Fatalities_new.csv", row.names=F)
write.csv(locations, "Locations_new.csv", row.names=F)
write.csv(storms, "Storms_Complete_2017.csv", row.names=F)

# End of data preprocessing.




# This section involves text mining preprocessing to analyze the content of the storm 
# event narratives.

# Removes missing values from the event narrative.
storm_details2 <- storm_details[complete.cases(storm_details$EVENT_NARRATIVE),]

# Removes all data for storms that had no casualties.
storm_details2 <- subset(storm_details2, storm_details2$casualties != "no")

# Builds the corpus.
descriptions <- VectorSource(storm_details2$EVENT_NARRATIVE)
descriptions <- Corpus(descriptions)

# Examines one of the storm event narratives.
inspect(descriptions[[10]])

# These commands remove any URLs that may exist in these documents.
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
descriptions <- tm_map(descriptions, content_transformer(removeURL))

# Removes all numbers and punctuation.
descriptions = tm_map(descriptions, removeNumbers)
descriptions = tm_map(descriptions, removePunctuation)

# This is a list of additional stop words and unnecessary words that were not included 
# in the default stopwords lists.
stop = c("just", "good", "watch", "time", "join", "get", "big", "going", "much", "said", 
         "like", "will", "now", "new", "can", "ass", "doesnt", "gave", "means", "one", 
         "mr", "less", "from", "looking", "ago", "come", "sat", "cut", "must", "full", 
         "im", "make", "fuck", "next", "give", "let", "shit", "thing", "weve", "back", "dont", 
         "let", "meet", "begin", "bring", "make", "set", "stay", "send", "step", "stop", 
         "open", "ask", "hold", "come", "wont", "run", "seek", "hear", "lot", "theyre", 
         "their", "i", "ive", "put", "didnt", "try", "tri", "claritin", "amp", "becaus", 
         "lol", "gonna", "wanna", "alway", "isnt", "suck", "damn", "smh", "happen", "made", 
         "ani", "probabl", "aint", "suppos", "realli", "noth", "befor", "jonathanrknight", 
         "whi", "alreadi", "onli", "anymor", "sinc", "caus", "exit", "result", "due", "report", 
         "estim", "yearold", "produc", "continu", "move", "storm", "occur")

# Removes stop words and unimportant words.  It identifies stop words from the English 
# and Smart stopwords lists, as well as words included in the 'stop' variable.
descriptions = tm_map(descriptions, removeWords, c("the", "and", stop, stopwords("english"), 
                                       stopwords("SMART")))

#Removes special characters such as @, â, and the Euro symbol.
toSpace <- content_transformer(function (x, pattern) gsub(pattern, " ", x))
descriptions <- tm_map(descriptions, toSpace, "@")
descriptions <- tm_map(descriptions, toSpace, "â")
descriptions <- tm_map(descriptions, toSpace, "/")
descriptions <- tm_map(descriptions, toSpace, "\\|")            # Removes the "|" character
descriptions <- tm_map(descriptions, toSpace, "\n")             # Removes new line character
descriptions <- tm_map(descriptions, toSpace, "\u20ac")         # Removes the Euro symbol
descriptions <- tm_map(descriptions, toSpace, "\u201d")         # Removes the " symbol

# Removes non-ASCII characters.
removeInvalid <- function(x) gsub("[^\x01-\x7F]", "", x)
descriptions <- tm_map(descriptions, content_transformer(removeInvalid))

# Performs stemming on each word, reducing it to its root word.
descriptions <- tm_map(descriptions, stemDocument)

# Changes all letters to lowercase.
descriptions = tm_map(descriptions, content_transformer(tolower))

# Removes stop words again, since some stop words may appear after stemming.
descriptions = tm_map(descriptions, removeWords, c("the", "and", stop, stopwords("english"), 
                                       stopwords("SMART")))

# Removes all extra whitespace between words.
descriptions =  tm_map(descriptions, stripWhitespace)

# Verifies that the tweet content has been preprocessed.
inspect(descriptions[10])

# Builds the Document Term Matrix (DTM) using the tweet content.
text_dtm <- DocumentTermMatrix(descriptions)

# Removes terms from the DTM that appear in less than 50% of the documents.
text_dtm <- removeSparseTerms(text_dtm, 0.95)

# End of text preprocessing.




# This section covers the creation of word clouds to visualize the most frequent 
# terms appearing in the storm event narratives.

# Creates a list of all unique words and their frequency counts.
freq <- colSums(as.matrix(text_dtm))

# Color scheme using up to 6 different colors for words depending on their frequency.
dark2 <- brewer.pal(6, "Dark2")

# Builds a word cloud that colors terms according to their frequency.  It has a 
# maximum of 60 words.
set.seed(12345)           # Random seed to reproduce the results.
wordcloud(names(freq), freq, max.words=60, rot.per=0.2, colors=dark2)

# End of generating word clouds.

# End of script.