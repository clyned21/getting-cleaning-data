###### This is my project for the getting and cleaning data course  #############
###### Deirdre Clyne, September, 2015   #########################################


###### STEP-1 merge the 2 datasets ##############################################
###### set the working directory to d:\proj     #################################
###### This is where my r code is and where I download and unzip data ###########
setwd("d:\\proj")
library(dplyr)

###### download the project data file, phonedata.zip into my working directory ##
download.file("https://d396qusza40orc.
              cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "d:\\proj\\phonedata.zip",mode="wb")

###### unzip phonedata.zip into the working directory (d:\proj\) ################
unzip("phonedata.zip", overwrite=TRUE, exdir="d:\\proj")

###### use read.table to read in the x_train.txt file  ##########################
X_train <- read.table("d:\\proj\\UCI HAR Dataset\\train\\X_train.txt")

###### use read.table to read in the features.txt file which contains ###########
###### the column header names for X_train   ####################################
col_header <- read.table("d:\\proj\\UCI HAR Dataset\\features.txt")

###### fix column names using make.names against the 2nd column in ##############
###### col_header where the names exist. Make sure all names are unique  ########
col_header2 <- make.names(col_header$V2,unique = TRUE)

###### apply fixed column names to the X_train data from col_header2  ###########
colnames(X_train) <- col_header2

###### read in the subject_train.txt file which contains subject ids   ##########
###### for the X_train data  ####################################################
subject_train <- scan("d:\\proj\\UCI HAR Dataset\\train\\subject_train.txt")

###### use read.table to read in the y_train.txt file which contains ############
###### the activity numbers for X_train    ######################################
y_train <- read.table("d:\\proj\\UCI HAR Dataset\\train\\y_train.txt")

###### add subjects and activity numbers to X_train    ##########################
###### (from the subject_train.txt file and the y_train.txt file)   #############
X_train2 <- cbind(y_train,subject_train, X_train)

######  apply column name to new columns    #####################################
colnames(X_train2)[2] <- "Subject_id"
colnames(X_train2)[1] <- "Activity_id"

###### now X_train2 has column names,subject_ids and activity_ids   #############
###### X_train2 contains 7352 rows and 563 cols         #########################

##### Now we read in an prepare the x_test.txt file in the same way #############
##### as we did for the x_train.txt file ########################################
##### use read.table to read in the x_test.txt file    ##########################
X_test <- read.table("d:\\proj\\UCI HAR Dataset\\test\\X_test.txt")

###### apply column names to X_test from col_header   ###########################
colnames(X_test) <- col_header2

######  read in the subject_test.txt file    ####################################
subject_test <- scan("d:\\proj\\UCI HAR Dataset\\test\\subject_test.txt")

##### read in y_test.txt which contains the activity numbers for X_test  ########
y_test <- read.table("d:\\proj\\UCI HAR Dataset\\test\\y_test.txt")

###### add 2 new columns to X_test containing the subject_id and activity_id ####
X_test2 <- cbind(y_test,subject_test, X_test)

###### apply column name to new columns     ######################################
colnames(X_test2)[2] <- "Subject_id"
colnames(X_test2)[1] <- "Activity_id"

###### now X_test2 has column names and a column with subject numbers  ###########
###### X_test2 contains 2947 rows and 563 cols    ################################

###### now, join the two datasets    #############################################
###### append X_test2 to X_train2 and call it X-combined  ########################
X_combined <- rbind(X_train2,X_test2, make.row.names=FALSE)

###### X_combined is the dataframe containing the full set of both the train #####
###### and test observations and contains 10299 rows and 563 columns  ############
###### end of STEP-1   ###########################################################

###### STEP-2 extract measurements for mean ans std deviation   ##################

###### start with the combined dataframe from step 1: x_combined   ###############
###### select columns who's names contain either the string "mean" or "std" ######
###### also preserve the activity and subject columns that we appended ###########
X_combined2 <- select(X_combined, matches('mean|std|Activity|Subject',ignore.case=TRUE))

###### Save this version of the file to run against summaries ####################
###### once we do step 3, we add a character field that does not summarize #######
X_comb_numeric <- X_combined2
###### X_combined3 now contains 10299 rows and 88 columns     ####################
###### end of step 2 #############################################################

###### Step-3 Use descriptive activity names #####################################
###### use read.table to read in the activity_labels.txt file   ##################
activitylabels <- read.table("d:\\proj\\UCI HAR Dataset\\activity_labels.txt",
                             stringsAsFactors = FALSE)

###### for each acitivity number from 1-6 in activitylables$V1, ##################
###### store the activity name from activitylabels$v2 in the #####################
###### X_combined2$activity_label field ##########################################
for (i in activitylabels$V1)
  X_combined2$activity_labels[X_combined2$Activity == i] <- 
  activitylabels$V2[activitylabels$V1==i]

###### end of Step-3, we now have descriptive activity names #####################
###### and an extra column in X_combined2 for 10299 rows and 89 cols #############
###### I also retained activity numbers for validation  ##########################

###### Step-4 label the data set with descriptive names      #####################
###### improve variable names by removing the periods                #############
names(X_combined2) <- gsub("\\.","",names(X_combined2))

###### The next steps are just to provide a readable file with   #################
###### subject_ids, activity labels and dropping the activity id #################

###### Optional - swap position of the activity_id and activity_label column #####
###### to make the dataset easier to read ########################################
###### X_combined3 <-select(X_combined2,Subject_id, activity_labels, everything())

###### optionally, drop activty_id ###############################################
###### X_combined4 <-select(X_combined3,-Activity_id)


###### Step-5 From the data set in step 4, creates a second, independent  ########
###### tidy data set with the average of each variable for each activity #########
###### and each subject. Group the data in the data2 dataset by the ##############
######subject id and the activity id #############################################
grouped_data <- group_by(X_comb_numeric,Subject_id,Activity_id)

###### summarize all the variables for the subject_id and activity_id groups #####
summary <- summarize_each(grouped_data,funs(mean))
write.table(summary, file=".\\summary.txt",row.names = FALSE)
###### now we have 180 rows (30 subjects x 6 activities) for 88 observations #####
###### end of step-5   ###########################################################
