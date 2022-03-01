# Course Project: A R script called run_analysis.R and create a tidy dataset TidyData.txt

## Load packages
library(data.table)
library(dplyr)

## Download data
fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./UCI HAR Dataset.zip")){
        download.file(fileurl,"./UCI HAR Dataset.zip", mode = "wb")
        unzip("UCI HAR Dataset.zip", exdir = getwd())
}

## Read metadata
features_names <- read.table("UCI HAR Dataset/features.txt", header = FALSE, sep = "")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")

## Read training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
features_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")

## Read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
features_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")

## Merge the training and the test sets to create one data set

## Merge training data and test data by subject, activity, and features
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
features <- rbind(features_train, features_test)

## Name the columns of features_df with names from features dataset
colnames(features) <- t(features_names[2])

## Name the columns of subject and activity
colnames(subject) <- "Subject"
colnames(activity) <- "Activity"

## Merge the dataset
df <- cbind(features, activity, subject)

## Extracts only the measurements on the mean and standard deviation for each measurement

## Subset Names of Features with “mean()” or “std()”
sub_features <- features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]

## Subset the dataframe df by selected names of Features
selectedNames <- c(as.character(sub_features), "Subject", "Activity" )
sub_df <-subset(df, select = selectedNames)

## Uses descriptive activity names to name the activities in the data set

## Change type of Activity to character 
sub_df$Activity <- as.character(sub_df$Activity)

for (i in 1:6){
        sub_df$Activity[sub_df$Activity == i] <- as.character(activity_labels[i,2])
        }
sub_df$Activity <- as.factor(sub_df$Activity)

## Appropriately labels the data set with descriptive variable names 

## Replace Acc with Accelerometer
## Replace Gyro with Gyroscope
## Replace BodyBody with Body
## Replace Mag with Magnitude
## Replace ^t with Time
## Replace ^f with Frequency
## Replace tBody with TimeBody

names(sub_df)<-gsub("Acc", "Accelerometer", names(sub_df))
names(sub_df)<-gsub("Gyro", "Gyroscope", names(sub_df))
names(sub_df)<-gsub("BodyBody", "Body", names(sub_df))
names(sub_df)<-gsub("Mag", "Magnitude", names(sub_df))
names(sub_df)<-gsub("^t", "Time", names(sub_df))
names(sub_df)<-gsub("^f", "Frequency", names(sub_df))
names(sub_df)<-gsub("tBody", "TimeBody", names(sub_df))


## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject

## Set the subject variable in the data as a factor
sub_df$Subject <- as.factor(sub_df$Subject)
sub_df <- data.table(sub_df)

## Create tidydata with average for each activity and subject
tidydata <- aggregate(. ~Subject + Activity, sub_df, mean)

## Order tidyData according to subject and activity
tidyData <- tidydata[order(tidydata$Subject, tidydata$Activity),]

## Write tidydata into a text file
write.table(tidydata, file = "TidyData.txt", row.names = FALSE)