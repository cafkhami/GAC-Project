## Getting and Cleaning data course project

#set the wd
setwd("~")
setwd("~/Coursera/Data Science/GAC/GAC-Project/data/UCI HAR Dataset")
basedir <- getwd()

#load dplyr and tidyr
library(dplyr)
library(tidyr)

#read in the files
act.labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

setwd("train")
subj.train <- read.table("subject_train.txt")
y.train <- read.table("y_train.txt")
x.train <- read.table("x_train.txt")

setwd(basedir)
setwd("test")
subj.test <- read.table("subject_test.txt")
y.test <- read.table("y_test.txt")
x.test <- read.table("x_test.txt")

#Give descriptive names
names(x.train) <- features[,2]
names(x.test) <- features[,2]

#combine the tables
test <- cbind(subj.test, y.test, x.test)
train <- cbind(subj.train, y.train, x.train)

combined <- rbind(test,train)

#finish naming
names(combined)[c(1,2)] <- c("Subject", "Activity")

#Filter to only the mean and std
mean <- grep("mean\\(\\)$",names(combined))
std <- grep("std\\(\\)$",names(combined))

filter.comb <- combined[,c(1,2,mean,std)]

#give descriptive values to the activity
filter.comb[,2] <- act.labels[filter.comb[,2],2]

#Give the variables descriptive names
names(filter.comb) <- gsub("-mean\\(\\)","MEAN",names(filter.comb))
names(filter.comb) <- gsub("-std\\(\\)","STD",names(filter.comb))

#Make a Tidy Dataset
TF <- tbl_df(filter.comb)

by_subj_act <- TF %>%
  group_by(Subject,Activity)

tidy <- by_subj_act %>%
  summarise_all(funs(mean)) %>%
  gather(Variable, Value, 3:20)

#write to a file
setwd("~/Coursera/Data Science/GAC/GAC-Project")
write.table(tidy,file = "Tidy.txt", row.names = FALSE)