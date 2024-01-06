# Install required packages
install.packages("dplyr")

# Load required libraries
library(dplyr)

# Step 1: Merges the training and the test sets to create one data set.

# Assuming your data is in the "UCI HAR Dataset" folder
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")

# Combine training and test data
merged_data <- rbind(train_data, test_data)
merged_labels <- rbind(train_labels, test_labels)

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

# Load feature names
features <- read.table("UCI HAR Dataset/features.txt")
colnames(merged_data) <- features$V2

# Extract only mean and standard deviation columns
selected_features <- grepl("mean()|std()", features$V2)
selected_data <- merged_data[, selected_features]

# Step 3: Uses descriptive activity names to name the activities in the data set.

# Load activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
merged_labels$V1 <- factor(merged_labels$V1, levels = activity_labels$V1, labels = activity_labels$V2)

# Assign descriptive activity names
merged_data_with_labels <- cbind(merged_labels, selected_data)

# Step 4: Appropriately labels the data set with descriptive variable names.

# Clean up variable names
cleaned_names <- make.names(colnames(merged_data_with_labels))
colnames(merged_data_with_labels) <- cleaned_names

# Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Group by activity and subject, calculate means
tidy_data <- merged_data_with_labels %>%
  group_by(V1, V2) %>%
  summarise_all(mean)

# Write the tidy data to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
