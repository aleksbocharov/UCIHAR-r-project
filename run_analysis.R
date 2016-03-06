# Load the libraries required
library(data.table)
library(dplyr)

#unzip the dataset to data subfolder
unzip(zipfile="./data/UCIHARDataset.zip",exdir="./data")

#Get the list of the files of UCI HAR Dataset
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

#store fatures and activities metadata in respectively named variables features.txt
featuresNames <- read.table(file.path(path_rf, "features.txt"))
activityLabels <-  read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#Before processing the data we need to read it and store in variables
#We read test and train data for:
#-activity(Y)
#-features(X)
#-subject identifiers
# the data has no headers so we set headers to False
testActivity  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
trainActivity <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
testSubject  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
trainSubject <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
testFeatures  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
trainFeatures <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#Step 1
#Now that data is loaded we can start processing it
#First step: we merge the training and the test sets to create one data set
#For this we first bind rows of training and test data
allActivity <- rbind(trainActivity,testActivity)
allFeatures <- rbind(trainFeatures,testFeatures)
allSubject <- rbind(trainSubject,testSubject)
#Then we give names for columns and combine all columns in one dataset
# name the columns(note that from feature names we take second column since it's the one that contains names)
tFeaturesNames <- t(featuresNames[2])#t transposes rows into columns
colnames(allFeatures) <- tFeaturesNames
colnames(allActivity) <- "Activity"
colnames(allSubject) <- "Subject"
#bind features, activities and subject data by columns in one dataset
allData <- cbind(allFeatures,allSubject,allActivity)

#Step 2
#Now that data is combined in one set we can get to next step 
#Which is extracting only the measurements on the mean and standard deviation for each measurement.
#We use regular expression to find columns with names containing std and mean 
findStdMeans <- tFeaturesNames[grep("mean\\(\\)|std\\(\\)", tFeaturesNames)]

#subset data with selected columns but  first add activities and subject columns
subsetNames<-c(as.character(findStdMeans), "Subject", "Activity")
requiredData<-subset(allData,select=subsetNames)
str(requiredData)
#Step 3
#Now we uses descriptive activity names to name the activities in the data set
#In order to do this we first change activity field to numeric 
#and then get activity names from variable activityLabels with metadata on activities
#by looping through all 6 different activity names
requiredData$Activity <- as.character(requiredData$Activity)
for (i in 1:6){requiredData$Activity[requiredData$Activity == i] <- as.character(activityLabels[i,2])}
#now we factorize variable activity
requiredData$Activity <- as.factor(requiredData$Activity)

#Step 4
#Now we appropriately label the data set with descriptive variable names.
#For this we use gsub function which lets ass substituted one string with a different one

names(requiredData)<-gsub("Acc", "Accelerometer", names(requiredData))
names(requiredData)<-gsub("Gyro", "Gyroscope", names(requiredData))
names(requiredData)<-gsub("Mag", "Magnitude", names(requiredData))
names(requiredData)<-gsub("BodyBody", "Body", names(requiredData))
names(requiredData)<-gsub("^t", "time", names(requiredData)) #prefix t always means time
names(requiredData)<-gsub("^f", "frequency", names(requiredData)) #prefix f always means freaquency

#Check if names are set appropriately
names(requiredData)

#Step 5
#Finally from the data set in step 4 we create a second 
#independent tidy data set with the average of each variable for each activity and each subject.

#We use aggregate function from dplyr package to collapse data by variables Subject and Activity
#and defined function mean
tidyData <- aggregate(. ~Subject+Activity,requiredData,mean) 
#before storing data we order it by subject and activity
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
#Finally we write data on disk in a text file named tidy_UCIHAR
write.table(x = tidyData,file = "tidy_UCIHAR.txt",row.names = FALSE)





















