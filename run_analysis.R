# Coursera/JHS - Getting and Cleaning Data Course Project
# Download sample data with measurements taken from smartphones and 
# process it to return two data frames, the first combining the training and test measurements
# in one data frame only with the mean and standard deviation measurements, the second with
# the average of each measurement of the first data frame aggregate by subject and activity.
#
# Author: Carlos Barboza
#
# December, 20th 2014

# Get sample data from the internet and unzip it locally
dataUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataUrl, "project_data.zip", method="curl")
unzip("project_data.zip")
file.remove("project_data.zip")
rm(dataUrl)

# Read the name of the measured features into a vector called colNames
colNames <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)$V2

# Load the test set into a data frame called dt_test
dt_test <- read.table("UCI HAR Dataset/test/X_test.txt")

# Load the training set into a data frame called dt_train
dt_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# Bind both data frames into a new data frame called measures and remove the
# previously created data frames from memory

measures <- rbind(dt_test, dt_train)
rm(dt_test,dt_train)

# Rename the columns on measures for the feature names stored under colNames and remove colNames
# vector

names(measures) <- colNames
rm(colNames)

# Keep on the data frame just the measurements of mean and standard deviation of each measurement
# based on the column names

measures <- measures[, grepl("mean()", names(measures)) | grepl("std()", names(measures))]

# Read the subject and activities to bind in the measures data frame
# name the column with the subject information to subject_id and the
# column with the activity information to activity

subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject,read.table("UCI HAR Dataset/train/subject_train.txt"))
names(subject) <- c("subject_id")


activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("id","activity")

activities <- read.table("UCI HAR Dataset/test/y_test.txt")
activities <- rbind(activities,read.table("UCI HAR Dataset/train/y_train.txt"))
names(activities) <- c("id")

# merge activities and activity_labels to translate the id into the real activity name.
activities <- merge(activities,activity_labels,sort=FALSE)
activity <- activities[,2]

# add activity and subject_id columns to the measures data frame and
# rename it to measures_mean_std
measures <- cbind(activity,measures)
measurements_mean_std <- cbind(subject,measures)

# remove unused data from memory
rm(activity,activity_labels,activities,subject,measures)

# Create a second data frame with the average of the average and average of the std. deviation 
# for every activity/subject and name it to avg_mean_std_per_subject_activity

avg_mean_std_per_subject_activity <- aggregate(measurements_mean_std[, 3:81], 
                                               list(measurements_mean_std$subject_id, measurements_mean_std$activity), 
                                               mean)

# rename the first to columns to subject_id and activity
names(avg_mean_std_per_subject_activity) <- paste("average",names(avg_mean_std_per_subject_activity))
names(avg_mean_std_per_subject_activity)[1] <- "subject_id"
names(avg_mean_std_per_subject_activity)[2] <- "activity"

# save data frames to local csv files
write.table(measurements_mean_std, "measurements_mean_std.txt", row.names = FALSE)
write.table(avg_mean_std_per_subject_activity, "avg_mean_std_per_subject_activity.txt", row.names = FALSE)