# Getting and cleaning UCI HAR dataset
This readme file describes how the script run_analysis.R works as well as give quick overview of the data used in the current project.
##Data
The data collected from experiment for Human Activity Recognition Using Smartphones. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
##Attributes
For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
##Objectives
The script accomplishes the following steps:
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##Script Description
###Preliminary Steps
Starts with loading libraries required for certain operation. Namely data.table and dplyr.
Then the dataset in zip file is unzipped. Following this we get the files path and store it in a varibles so we access the files required for future the next steps.
Next script extracts metadata from files included in data folder for features names and activity labels.
Before processing the data we need to read it and store in variables.
We read test and train data for:
-activity(Y)
-features(X)
-subject identifiers
Now that data is loaded we can start processing it.
###Step 1.
First step: we merge the training and the test sets to create one data set. For this we first bind rows of training and test data. Then we give names for columns and combine all columns in one dataset name the columns(note that from feature names we take second column since it's the one that contains names). Then the script binds features, activities and subject data by columns in one dataset.
###Step 2
Now that data is combined in one set we can get to next step, which is extracting only the measurements on the mean and standard deviation for each measurement. We use regular expression to find columns with names containing std and mean. Then the script subsets data with selected columns but first adds activities and subject columns, so they are included in our exctracted data set.
###Step 3
Now we uses descriptive activity names to name the activities in the data set. In order to do this we first change activity field to numeric and then get activity names from variable activityLabels with metadata on activities by looping through all 6 different activity names. After completing this the script factorizes variable Activity.
###Step 4
Now we appropriately label the data set with descriptive variable names. For this we use gsub function which lets ass substituted one string with a different one. We substitute:
- prefix 't' with time,
- prefix 'f' with frequency,
- "Acc" with "Accelerometer", 
- "Gyro" with "Gyroscope", 
- "Mag" with "Magnitude", 
- "BodyBody" with "Body".
Then script runs a line which displays the names so the user can check if names are set appropriately.
###Step 5
Finally from the data set in step 4 we create a second independent tidy data set with the average of each variable for each activity and each subject. We use aggregate function from dplyr package to collapse data by variables Subject and Activity and defined function mean.
Then before storing data we order it by subject and activity. Finally we write the tidy data on disk in a text file named tidy_UCIHAR. This completed the script.






