# getting-cleaning-data

My project contains 3 files as required for this project.

1. This file (readme.md) describes the other two files and the input files used

2. The run_analysis.R file is heavily documented and outlines all the steps that I took to process 
the data and execute all the required steps

3. CodeBook.md describes the variables, the data, and transformations or work that I performed to clean up the data 

CodeBok.md contains:
- All the original metadata from the features_info file
- Activity labels from activity_labels
- descriptions of the columns added to the original datasets
- summary of the processing steps applied to the data

The files I processed in this project are:

*- 'features.txt': List of all features.

*- 'activity_labels.txt': Links the class labels with their activity name.

*- 'train/X_train.txt': Training set.

*- 'train/y_train.txt': Training labels.

*- 'test/X_test.txt': Test set.

*- 'test/y_test.txt': Test labels.

*- 'train/subject_train.txt': Each row identifies the subject who performed the training activity for each window sample. 

*- 'test/subject_test.txt': Each row identifies the subject who performed the test activity for each window sample. 


Steps taken to process the data:
================================
1. Download and unzip the zipped data file into the working directory (d:\proj)
2. Read in the training dataset (X_train.txt)
3. Read in the column headers (features.txt) and fix names to remove incorrect characters, then apply to the X_train dataset
4. Read in the subject file and activity file and apply to the X_train data set with column names
5. Repeat steps 2-4 for the test dataset (X_test.txt)
6. Join the two datasets that have observations, subjects and features. Both datasets have the same column names
7. Select the columns that we care about - just the columns that contain mean or standard deviation values. This is any column 
   where the column names contain the phrases "mean" or "std" and also retain subject and activity columns for identification
8. Apply descriptive activity names to the joined dataset
9. Fix column names by removing periods. I did not add any additional wording to column names to avoid introducing issues due to lack 
   of specific documentation on the exact column names
10. Group the data by subject and activity number and then summarize the observations.
11. This set of steps produced a dataset with 180 rows (30 subjects X 6 activities) with a range of summarized observations


