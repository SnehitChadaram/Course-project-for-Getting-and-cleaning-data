#Please run this file from the directory in which the "UCI HAR Dataset" is present

labels<-read.table("UCI HAR Dataset/activity_labels.txt")
labels[,2]<- as.character(labels[,2])

features<- read.table("UCI HAR Dataset/features.txt")
features[,2]<- as.character(features[,2])
featuresreq<- grep(".*mean.*|.*std.*", features[,2])    #Task2: Taking only req data

x_train<- read.table("UCI HAR Dataset/train/X_train.txt")[featuresreq]
y_train<- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("UCI HAR Dataset/train/subject_train.txt")
train_data<- cbind(x_train, y_train, subject_train)
x_test<- read.table("UCI HAR Dataset/test/X_test.txt")[featuresreq]
y_test<- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test<- read.table("UCI HAR Dataset/test/subject_test.txt")
test_data<- cbind(x_test, y_test, subject_test)
sample<- rbind(train_data, test_data)         #Task1: Merging into one dataset

names<-features$V2[featuresreq]
colnames(sample)<- c(names, "Activity", "Subject")  #Task4: Naming the variables

sample$Activity <- factor(sample$Activity, levels = labels[,1], labels = labels[,2])
                                              #Task3: Giving Descriptive Activity names      

sample.melted <- melt(sample, id = c("Subject", "Activity"))
sample.mean <- dcast(sample.melted, Subject + Activity ~ variable, mean)
                                              #Task5: Taking averages
write.table(sample.mean, "final.txt", row.names = FALSE)
