
# Require packages used in the analysis
library(data.table,quietly=TRUE)
library(reshape2,quietly=TRUE)

#### PART 1 - Merge the training and the test sets to create one data set ####

# The current working directory should be pointing to the
# "UCI HAR Dataset" folder to run this analysis

# ~~~ Wrangle the Training Data ~~~ #

# Get Current Working Directory
mydir <- getwd()

# Read in the features file
features <- read.table("features.txt", header=FALSE)

# Read in the activity labels and set column names
activity.labels <- read.table("activity_labels.txt")
    colnames(activity.labels) <- c("Class", "Activity")

# Set the directory to read in the training datasets
new.dir <- paste(getwd(),'/',"train",sep="")
    setwd(new.dir) 

# Read in the Training Dataset
training.set <- read.table("X_train.txt", header=FALSE)

# Read in training description labels
train.description <- read.table("subject_train.txt",header=FALSE)

# Read in participant data and set the column names
train.participant <- read.table("y_train.txt",header=FALSE)
    setnames(train.participant,old="V1",new="Class")

# ~~~ Wrangle the Test Data ~~~ #

# Set working directory for test data
new.dir <- paste(mydir,'/',"test",sep="") # Add New WD extension
    setwd(new.dir) # Set working directory for test data

# Read in test dataset
test.set <- read.table("X_test.txt", header=FALSE)

# Read in test description labels
test.description <- read.table("subject_test.txt", header=FALSE)

# Read in participant data and set column names
test.participant <- read.table("y_test.txt",header=FALSE)
    setnames(test.participant,old="V1",new="Class")

# Set working directory back to home
setwd(mydir)

# ~~~ Merge Test and Training Data ~~~ #

# Append the data since it is of the same dimensions and order
mydata <- rbind(training.set,test.set)
    rm(training.set,test.set)

# convert to lower and add features "column names" to mydata
features$V2 <- tolower(features$V2)
    colnames(mydata) <- features$V2


#### PART 2 - Extract only the measurements on the mean and 
#    standard deviation for each measurement ####


# Define the desired pattern to subset on
pattern <- 'mean|std'

# Create a vector to index on the desired names
mynames <- grep(pattern, names(mydata))
    rm(pattern)

# Subset the data with the index vector
mydata <- mydata[,mynames]
    rm(mynames,features)


#### PART 3 - Uses descriptive activity names to name the activities in the data set
#### PART 4 - Appropriately labels the data set with descriptive activity names.


# Merge activity labels onto the training participants data
train.participant <- merge(train.participant,activity.labels, by="Class", all=TRUE)

# Merge activity labels onto the test participants data
test.participant <- merge(test.participant,activity.labels, by="Class", all=TRUE)

# Combine the training and test data in the same order as before
decriptive.labels <- rbind(train.participant,test.participant)
    rm(activity.labels,test.description,test.participant,train.description,train.participant)

# Add the descriptive activity labels onto the combined dataset
mydata <- cbind(decriptive.labels, mydata)
    rm(decriptive.labels)


#### PART 5 - Create a second, independent tidy data set with the
####  average of each variable for each activity and each subject.


# Melt merged dataset with reshape2 package
molten.data <- melt(mydata, id="Activity")

# Cast the dataset in a tidy format using the mean function as
#   an argument in the dcast function of the reshape2 package
wide.tidy.data <- dcast(molten.data, Activity ~ variable, mean)
    
# Order the wide tidy dataset
wide.tidy.data <- wide.tidy.data[order(wide.tidy.data$Class),]
    rm(molten.data)

# Create a second tall tidy dataset for the user
tall.tidy.data <- melt(wide.tidy.data, id=c("Activity","Class"))
    
# Add intuitive column names
colnames(tall.tidy.data) <- c("Activity","Class","Feature","Mean.Value")
    rm(mydir,new.dir)


# There are now 3 datasets in memory
# mydata <- unagragated dataframe that is a subet of features
# wide.tidy.data <- a mean calculation of the data for each 
#   feature class and activity in the data.
# tall.tidy.data <- a tall version that users may prefer

