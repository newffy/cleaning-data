require(readr)
require(dplyr)

# reading feature list, will be used for selecting *mean, *std variables and for renaming variables in dataset
featuresList <- read.table("features.txt", header = F, sep = " ", col.names = c("featureID", "featureName"), colClasses = c("numeric", "character"))

# redaing activity names
activityLabelNames <- read.table("activity_labels.txt", header = F, sep = " ", col.names = c("activityCode", "activityName"), colClasses = c("numeric", "character"))

# reading train and test activity codes
trainLabels <- read.table("train/y_train.txt", header = F, col.names = "activityCode", colClasses = "numeric")
testLabels <- read.table("test/y_test.txt", header = F, col.names = "activityCode", colClasses = "numeric")

# reading train and test subjects codes
subjectsTrain <- read.table("train/subject_train.txt", header = F, col.names = "subjectCode", colClasses = "numeric")
subjectsTest <- read.table("test/subject_test.txt", header = F, col.names = "subjectCode", colClasses = "numeric")

#reading train dataset using readr package for speed. Fixed-width format
trainDS <- readr::read_fwf("train/X_train.txt", col_positions = fwf_widths(rep(16, 561)), col_types = paste(rep("d", 561), sep = "", collapse = ""))
# appending subject and activity data to train dataset
trainDS <- cbind(trainLabels, subjectsTrain, trainDS)

#reading test dataset. Fixed-width format
testDS <- readr::read_fwf("test/X_test.txt", col_positions = fwf_widths(rep(16, 561)), col_types = paste(rep("d", 561), sep = "", collapse = ""))
# appending subject and activity data to test dataset
testDS <- cbind(testLabels, subjectsTest, testDS)

# merging train and test datasets
mergedDS <- rbind(trainDS, testDS)
rm(trainDS, testDS)

# selecting indexes of mean and std variables
colMeanIndexes <- grep("-mean()", featuresList[, "featureName"], fixed = T)
colStdIndexes <- grep("-std()", featuresList[, "featureName"], fixed = T)
allColIndexes <- sort(c(colMeanIndexes, colStdIndexes))

# preparing future variable names
allColNames <- featuresList[allColIndexes, "featureName"]
allColNames <- gsub("()", "", allColNames, fixed = T)

# selecting only activityCode, subjectCode + all *mean && *std variables
mergedDS <- mergedDS[, c(1, 2, allColIndexes + 2)]

# joining activityName
mergedDS <- merge(activityLabelNames, mergedDS, by.x = "activityCode", by.y = "activityCode")

# renaming variables in dataset using prepared earlier list
names(mergedDS) <- c("activityCode", "activityName", "subjectCode", allColNames)

# preparing final dataset with means of each variable grouped by activity and subject. 
tidyDS <- mergedDS[, -1] %>% group_by(activityName, subjectCode) %>% summarise_each(funs(mean))

write.table(tidyDS, "tidy_datasource.txt", row.names = F)
