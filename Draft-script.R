library(readr)
library(tidyr)
library(dplyr)
library(tibble)

## Load data set "training", add labels train, activities & subjects
trainingdata <- read.table("data/train/X_train.txt", header = FALSE)
trainsubjects <- read.table("data/train/subject_train.txt", header = FALSE)
trainactivities <- read.table("data/train/y_train.txt", header = FALSE)
trainactivities <- mutate(trainactivities, V1 = recode(V1, "1" = "walking", "2" = "walking_upstairs", "3" = "walking_downstairs", "4" = "sitting", "5" = "standing", "6" = "laying"))
trainingdata <- mutate(trainingdata, datatype = "train")
trainingdata <- mutate(trainingdata, activity = trainactivities)
trainingdata <- mutate(trainingdata, subject = trainsubjects)

## Load data set "testing", add labels test, activities & subjects
testdata <- read.table("data/test/X_test.txt", header = FALSE)
testsubjects <- read.table("data/test/subject_test.txt", header = FALSE)
testactivities <- read.table("data/test/y_test.txt", header = FALSE)
testactivities <- mutate(testactivities, V1 = recode(V1, "1" = "walking", "2" = "walking_upstairs", "3" = "walking_downstairs", "4" = "sitting", "5" = "standing", "6" = "laying"))
testdata <- mutate(testdata, datatype = "test")
testdata <- mutate(testdata, activity = testactivities)
testdata <- mutate(testdata, subject = testsubjects)

## combine both data sets
combinedata <- rbind(testdata, trainingdata)

## read column names and add to combined data set
columnames <- read.table("data/features.txt", header = FALSE)
columnames <- select(columnames, -V1)
columnames <- rbind(columnames, data.frame(V2 = c("datatype", "activity", "subject")))
colnames(combinedata) <- columnames$V2

## Create separate data set that only contains mean and standard deviation data
meanstdData <- select(combinedata, contains("-mean") | contains("-std") | matches("datatype") | contains("activity") | contains("subject"))
meanstdData <- as_tibble(meanstdData)
meanstdData <- group_by(meanstdData, activity, subject)

test <- summarise(meanstdData, mean(meanstdData, .groups = "keep"))