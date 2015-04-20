# Getting and Cleaning Data with R - course project
#
# You should create one R script called run_analysis.R that does the following.:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 
# From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.

# Install dependencies
if(!require("reshape2")) {{
  install.packages("reshape2")
}}

# Download the UCI HAR Dataset into ./data if necessary
if (!file.exists("./data")) {
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./data/getdata-projectfiles-UCI-HAR-Dataset.zip"
if(!file.exists(destFile)) {
  download.file(fileUrl, destfile = destFile, method="curl")
  dateDownloaded <- date()
  paste("Zip file downloaded on", dateDownloaded, sep = " ")
}

# Unzip the downloaded file if necessary
unzippedDir <- "./data/UCI HAR Dataset"
if (!file.exists(unzippedDir)) {
  unzip(destFile, exdir = "./data")
  paste("Extracted zip file")
}



# Read in the activity labels
labelsTable <- read.table(file.path(unzippedDir, "activity_labels.txt"), col.names=c("label-id", "label"))

# Use descriptive activity names to name the activities in the data set
labelsTable$label <- gsub("_", " ", tolower(labelsTable$label))



# Read in the features
featuresTable <- read.table(file.path(unzippedDir, "features.txt"), col.names=c("feature-id", "feature"))
features <- featuresTable$feature



# Extract only the measurements on the mean and standard deviation for each measurement.
importantFeaturesIndices <- grep("-mean\\(\\)|-std\\(\\)", features)



# Read in the test data set
testSubjects <- read.table(file.path(unzippedDir, "test/subject_test.txt"), col.names = c("subject"))

testData <- read.table(file.path(unzippedDir, "test/X_test.txt"))
# only keep the features we are interested in in the test data
testData <- testData[, importantFeaturesIndices]
names(testData) <- features[importantFeaturesIndices]

testLabels <- read.table(file.path(unzippedDir, "test/y_test.txt"), col.names = c("label-id"))

# add the activity name to the activity id
# i.e. we go from
# label-id
# 1       5
# to
# label-id       V2
# 1       5 standing
testLabels[,2] <- labelsTable$label[testLabels[,1]]
names(testLabels) <- c("activity-id", "activity")

# Bind the test data
allTestData <- cbind(testSubjects, testLabels, testData) 



# Read in the training data set
trainSubjects <- read.table(file.path(unzippedDir, "train/subject_train.txt"), col.names = c("subject"))

trainData <- read.table(file.path(unzippedDir, "train/X_train.txt"))
# only keep the features we are interested in in the train data
trainData <- trainData[, importantFeaturesIndices]
names(trainData) <- features[importantFeaturesIndices]

trainLabels <- read.table(file.path(unzippedDir, "train/y_train.txt"), col.names = c("label-id"))

trainLabels[,2] <- labelsTable$label[trainLabels[,1]]
names(trainLabels) <- c("activity-id", "activity")



# Bind the train data
allTrainData <- cbind(trainSubjects, trainLabels, trainData) 



# Merge the training and the test sets to create one data set
combinedDataSet <- rbind(allTestData, allTrainData)



# Appropriately labels the data set with descriptive activity names.
names(combinedDataSet) <- gsub("\\(|\\)", "", names(combinedDataSet))
names(combinedDataSet) <- tolower(names(combinedDataSet))

#dim(combinedDataSet)
#length(combinedDataSet)
#names(combinedDataSet)
#head(combinedDataSet)

# Save the data to a file 
#write.table(combinedDataSet, "combined-data.txt")

# reshape the array
library(reshape2)
molten <- melt(combinedDataSet, id = c("activity", "subject"))

# produce the tidy dataset with mean of each variable for each activity and each subject
tidy <- dcast(molten, activity + subject ~ variable, mean)
#dim(tidy)

# write tidy dataset to disk
write.table(tidy, file="tidy-data.txt", quote=FALSE, row.names=FALSE, sep="\t")

# write codebook to disk
write.table(paste("* ", names(tidy), sep=""), file="CodeBook.md",
            quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")

