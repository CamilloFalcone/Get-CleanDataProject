
args <- commandArgs(trailingOnly = TRUE)
wd<-getwd() #to reset at the end of the script
#RootFolder<-"/DataScienceFolder/UCI HAR Dataset"
RootFolder <- args[1]
# read the folder root as an input and check if it exists..
setwd(RootFolder)
TestFile<-paste(RootFolder, "/test/X_test.txt", sep="")
TrainFile <-paste(RootFolder, "/train/X_train.txt", sep="")
TestActivityFile<-paste(RootFolder, "/test/y_test.txt", sep ="")
TrainActivityFile<-paste(RootFolder, "/train/y_train.txt", sep ="")
TestSubjectFile<-paste(RootFolder, "/test/subject_test.txt", sep="")
TrainSubjectFile<- paste(RootFolder, "/train/subject_train.txt", sep="")


#merge training and test data set
file.create("Merge.txt")
file.append("Merge.txt", TestFile)
file.append("Merge.txt", TrainFile)
file.create("Activity.txt")
file.append("Activity.txt", TestActivityFile)
file.append("Activity.txt", TrainActivityFile)
file.create("Subject.txt")
file.append("Subject.txt", TestSubjectFile)
file.append("Subject.txt", TrainSubjectFile)



#extracts mean and sd from each measurement

# the position of features with a name with mean or std or Mean

features<-read.table("features.txt", sep=" ")
index<-grepl("mean|std|Mean", features[,2])

#replace with descriptive names the activities in the data set
#labels is the table to use..it contains the activity code and its description...
labels<-read.table("activity_labels.txt", sep = " ")
# leggere il file y_test e x_test e fare outer join con labels..
ytest<-read.table("Activity.txt")
outtest<-merge(ytest, labels, by.x="V1", by.y="V1")
dimnames(outtest)[[2]]<-c("V1", "Activity") # fix the name of the activity column


# USARE SCAN PER LEGGERE I DATI....
#ATTENZIONE..restituisce un vettore, bisogna trasformarlo in
#matrice/data frame
All<-scan("Merge.txt")
k<-matrix(All, ncol=561)
mydata<-data.frame(k)
## usare la seconda colonna di features per dare nome al data frame mydata
mydata1<-mydata[,index] #only 86 variables
features1<-features[,2][index] #only 86 names for columns
rowname<-c(1:10299)
#set the name for the variable...
dimnames(mydata1)<-list(rowname, features1)
mydata1<- cbind(mydata1, outtest[2]) #THIS IS THE FIRST TIDY SET...
write.table(mydata1, "tidyset1.txt")








#create a 2nd indipendente data set with the average for each activity and each subject
mysubjects<-read.table("Subject.txt")
dimnames(mysubjects)[[2]]<-c("Subject")
mydata2<-cbind(mydata1, mysubjects) # this is the 2nd data set to summarize

library(dplyr)

#group_by and then summarize...
grouped <- group_by(mydata2, Subject, Activity)
k<-summarize(grouped, mean(`tBodyAcc-mean()-X`))
# problema: come nominare tutte le variabili...
write.table(k, "tidyset2.txt")




setwd(wd)




