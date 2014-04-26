### CodeBook - Getting and Cleaning Data Peer Assignment
========================================================

### Variable Descriptions

The Human Activity Recognition data was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
* More information on the data collected can be obtained at the following url
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

The compiled data contains 10,299 observations with 561 attributes that when subset to just measurements on mean and standard deviation are 10,299 observations of 88 attributes.

#### 6 activity classes are labeled in the data:
* 1 WALKING
* 2 WALKING_UPSTAIRS
* 3 WALKING_DOWNSTAIRS
* 4 SITTING
* 5 STANDING
* 6 LAYING


A list of the features summarized in the tidy dataset are below. The mean annotated as **mean()** and the and standard deviation annotated as **std()** for each of the following features is in the tidy dataset.


```
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag
gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean
```

### R Code Description

The run_analysis.R file contains code to transform the dataset described above into a tidy dataset that contains
the mean value for each feature in every class and activity.

In order to run the script without it breaking 
* 1. The current working directory should be set to the **"UCI HAR Dataset"** folder.
* 2. The **"data.table"** and **"reshape2"** packages should be installed.

The script is broken into 5 sections. Their descriptions follow:

#### Part 1 - Merges the training and the test sets to create one data set.
The "X_train.txt" and "X_test.txt" datasets are appended to one another to create a complete dataset and the "Y_train.txt" and "Y_test.txt" files are used to append class information. The column names are set with the features description. 

#### Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement

All feature classes are set to lowercase and subset from the dataset by the text pattern "mean" and "std".

#### Part 3 and Part 4 - Appends descriptive activity names to name the activities in the data set. Labels the data set with descriptive activity names.

These steps are conducted together by appending the "activity_labels.txt" file in the same way as the "X_train.txt" and "X_test.txt" datasets were appended. Then merging them together.  

#### Part 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The **reshape2** package is used to melt and recast the data and obtain the mean value for each feature and class in the dataset.There will be three objects remaining in memory when the scrip is completed. 
* **mydata** <- A non-aggregated data frame that is a subset of just mean and standard deviation features.

* **wide.tidy.data** <- An aggregated mean calculation of the data for each feature class and activity in the data.

* **tall.tidy.data** <- A tall version of the "tidy" data that users may prefer.

