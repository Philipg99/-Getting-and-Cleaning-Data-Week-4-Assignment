library('dplyr')

setwd('/home/philip/Desktop/UCI HAR Dataset')


#read data
X_train <- read.table("train/X_train.txt")
X_test <- read.table("test/X_test.txt")
Y_train <- read.table("train/y_train.txt")
Y_test <- read.table("test/y_test.txt")
sub_train <- read.table("train/subject_train.txt")
sub_test <- read.table("test/subject_test.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
  

#Merges the training and the test sets to create one data set.

X_all <- rbind(X_train, X_test)
Y_all <- rbind(Y_train, Y_test)
sub_all <- rbind(sub_train, sub_test)


#Extracts only the measurements on the mean and standard deviation for each measurement.

features_col_num <- grep("mean|std",features[,2])
X_all <- X_all[,features_col_num]

# Uses descriptive activity names to name the activities in the data set
colnames(Y_all) <- "label"
Y_all$label <- factor(Y_all$label, labels = as.character(activity_labels[,2]))


# Appropriately labels the data set with descriptive variable names
colnames(X_all) <- features[features_col_num,2]

#From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

colnames(sub_all) <- "subject"
combined <- cbind(X_all, Y_all, sub_all)

tidy <- combined %>% group_by(subject,label) %>% summarise_all(funs(mean))

write.table(tidy, file = "./tidy.txt", row.names = FALSE, col.names = TRUE)
