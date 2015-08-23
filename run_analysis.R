require(readr)
require(dplyr)

featuresList <- read.table("features.txt", header = F, sep = " ", col.names = c("featureID", "featureName"), colClasses = c("numeric", "character"))

activityLabelNames <- read.table("activity_labels.txt", header = F, sep = " ", col.names = c("activityCode", "activityName"), colClasses = c("numeric", "character"))
trainLabels <- read.table("train/y_train.txt", header = F, col.names = "activityCode", colClasses = "numeric")
testLabels <- read.table("test/y_test.txt", header = F, col.names = "activityCode", colClasses = "numeric")

subjectsTrain <- read.table("train/subject_train.txt", header = F, col.names = "subjectCode", colClasses = "numeric")
subjectsTest <- read.table("test/subject_test.txt", header = F, col.names = "subjectCode", colClasses = "numeric")

trainDS <- readr::read_fwf("train/X_train.txt", col_positions = fwf_widths(rep(16, 561)), col_types = paste(rep("d", 561), sep = "", collapse = ""))
trainDS <- cbind(trainLabels, subjectsTrain, trainDS)

testDS <- readr::read_fwf("test/X_test.txt", col_positions = fwf_widths(rep(16, 561)), col_types = paste(rep("d", 561), sep = "", collapse = ""))
testDS <- cbind(testLabels, subjectsTest, testDS)

mergedDS <- rbind(trainDS, testDS)
rm(trainDS, testDS)

colMeanIndexes <- grep("-mean()", featuresList[, "featureName"], fixed = T)
colStdIndexes <- grep("-std()", featuresList[, "featureName"], fixed = T)
allColIndexes <- sort(c(colMeanIndexes, colStdIndexes))

allColNames <- featuresList[allColIndexes, "featureName"]
allColNames <- gsub("()", "", allColNames, fixed = T)

mergedDS <- mergedDS[, c(1, 2, allColIndexes + 2)]

mergedDS <- merge(activityLabelNames, mergedDS, by.x = "activityCode", by.y = "activityCode")

names(mergedDS) <- c("activityCode", "activityName", "subjectCode", allColNames)

tidyDS <- mergedDS[, -1] %>% group_by(activityName, subjectCode) %>% summarise_each(funs(mean))

write.table(tidyDS, "tidy_datasource.txt", row.names = F)
