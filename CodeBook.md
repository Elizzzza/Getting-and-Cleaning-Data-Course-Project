# CodeBook

The `run_analysis.R` script performs the following data preparation and transformation to generate tidy dataset `TidyData.txt`

Preparation step: 
- Download the dataset
  - UCI HAR Dataset is downloaded, unzipped, and extracted from the website

- Assign each data to variables

  - `features_names <- features.txt` 
  - `activities_labels` <- activity_labels.txt`
  - `subject_test <- test/subject_test.txt`
  - `features_test <- test/X_test.txt`
  - `activity_test <- test/y_test.txt`
  - `subject_train <- test/subject_train.txt`
  - `features_train <- test/X_train.txt`
  - `activity_train <- test/y_train.txt`

1. Merges the training and the test sets to create one data set

- `features` is created by merging `features_train` and `features_test` using rbind() function
- `activity` is created by merging `activity_train` and `activity_test` using rbind() function
- `subject` is created by merging `subject_train` and `subject_test` using rbind() function
- Using colnames to rename the column names of `features`, `activity`, and `subject` with `Features`, `Activity`, and `Subject`
- `df` is created by merging `features`, `activity`, and `subject` using cbind() function

2. Extracts only the measurements on the mean and standard deviation for each measurement
- `sub_df` is created by subsetting `df`, selecting only columns: feactures and the measurements on the `mean()` and `std()` for each measurement

3. Uses descriptive activity names to name the activities in the data set
- First change the type of Activity to character
- Then, with a for loop, replaced the numbers in code column of the sub_df with corresponding activity 
- Note: activity names are taken from second column of the `activity_labels` 

4. Appropriately labels the data set with descriptive variable names
- Renamed comlumn name by replacing phrases
  - Replace `Acc` with `Accelerometer`
  - Replace `Gyro` with `Gyroscope`
  - Replace `BodyBody` with `Body`
  - Replace `Mag` with `Magnitude`
  - Replace `^t` with `Time`
  - Replace `^f` with `Frequency`
  - Replace `tBody` with `TimeBody`

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
- `TidyData` is created with average for each activity and subject and arranged according to subject and activity
- Export `TidyData.txt` file as the output
