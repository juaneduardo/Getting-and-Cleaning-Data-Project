# Create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.

require("data.table")
require("reshape2")

# Loads the Datasets

# Load X_test, y_test and subject_test data.
X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

# Load and X_train, y_train and subject_train data.
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")

subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

# Load: The complete list of variables of each feature vector from 'features.txt'
features <- read.table("./UCI_HAR_Dataset/features.txt")[,2]

#Load: 'activity_labels.txt': Links the class labels with their activity name
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")[,2]

# Acoording to features_info.txt 
# identify only the column names (variables) with the the measurements on the mean and standard deviation.
mean_std_columns <- grepl("mean|std", features)

#names the columns according the list of variables
names(X_test) = features
names(X_train) = features

# Extracts only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,mean_std_columns]
X_train = X_train[,mean_std_columns]

# Load: activity labels and rename columns
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")[,2]

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Merge test data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Merge train data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

#Appropriately labels the data set with descriptive variable names. 
labels_id   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), labels_id)
data_final      = melt(data, id = labels_id, measure.vars = data_labels)

# From the data set (data_final), creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject
tdata   = dcast(data_final, subject + Activity_Label ~ variable, mean)

write.table(tdata, file = "./tdata.txt",row.name=FALSE)



