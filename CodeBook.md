# Getting and cleaning data

## Source data description 
Original experiment description and data codebook is given at [1] and inside archive with data (files README.txt, features_info.txt)

## Data transformation
1. Training and testing datasets were united to single dataset
2. From united dataset only variables with mean and standard deviation of measurements were extracted
3. Actitivity names were joined to dataset
4. Variables were named with proper names (feature name without parenthesis inside)
5. Dataset was grouped by activity name, subject code and mean value of each variable was taken

## Resulting dataset description
**activityName**: the name of activity. One of [WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING]

**subjectCode**: code of subject, who generated these activities, numeric

Other variables have the same units as in the original datasource and named in the next manner:
```
tBodyAcc-<mean|std>-<X|Y|Z>
tGravityAcc-<mean|std>-<X|Y|Z>
tBodyAccJerk-<mean|std>-<X|Y|Z>
tBodyGyro-<mean|std>-<X|Y|Z>
tBodyGyroJerk-<mean|std>-<X|Y|Z>
tBodyAccMag-<mean|std>
tGravityAccMag-<mean|std>
tBodyAccJerkMag-<mean|std>
tBodyGyroMag-<mean|std>
tBodyGyroJerkMag-<mean|std>
fBodyAcc-<mean|std>-<X|Y|Z>
fBodyAccJerk-<mean|std>-<X|Y|Z>
fBodyGyro-<mean|std>-<X|Y|Z>
fBodyAccMag-<mean|std>
fBodyAccJerkMag-<mean|std>
fBodyGyroMag-<mean|std>
fBodyGyroJerkMag-<mean|std>
```
## References
[1] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
