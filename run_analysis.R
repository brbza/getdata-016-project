# Read the name of the measured features into a vector called colNames
colNames <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)$V2

# Load the test set into a data frame called dt_test
dt_test <- read.table("UCI HAR Dataset/test/X_test.txt")

# Load the training set into a data frame called dt_train
dt_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# Bind both data frames into a new data frame called measures and remove the
# other data frames from memory

measures <- rbind(dt_test, dt_train)
rm(dt_test,dt_train)

# Rename the columns on measures for the feature names stored under colNames and remove colNames

names(measures) <- colNames
rm(colNames)

# Keep on the data frame just the measurements of meand and standard deviation of each measurement

measures <- measures[, grepl("mean()", names(measures)) | grepl("std()", names(measures))]

# Read the subject and activities to bind in the measures data frame

subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject,read.table("UCI HAR Dataset/train/subject_train.txt"))
names(subject) <- c("subject_id")


activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("id","activity")

activities <- read.table("UCI HAR Dataset/test/y_test.txt")
activities <- rbind(activities,read.table("UCI HAR Dataset/train/y_train.txt"))
names(activities) <- c("id")
activities <- merge(activities,activity_labels,sort=FALSE)
activity <- activities[,2]

measures <- cbind(activity,measures)
measurements_mean_std <- cbind(subject,measures)

rm(activity,activity_labels,activities,subject,measures)

# Create a second data set with the average of the average and average of the std. deviation 
# for every activity/subject.

avg_mean_std_per_subject_activity <- aggregate(measurements_mean_std[, 3:81], 
                                               list(measurements_mean_std$subject_id, measurements_mean_std$activity), 
                                               mean)

names(avg_mean_std_per_subject_activity)[1] <- "subject_id"
names(avg_mean_std_per_subject_activity)[2] <- "activity"