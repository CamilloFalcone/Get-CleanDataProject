InitFileName<-function(root){
TestFile<-paste(root, "/test/X_test.txt", sep="")
TrainFile <-paste(root, "/train/X_train.txt", sep="")
TestActivityFile<-paste(root, "/test/y_test.txt", sep ="")
TrainActivityFile<-paste(root, "/train/y_train.txt", sep ="")
TestSubjectFile<-paste(root, "/test/subject_test.txt", sep="")
TrainSubjectFile<- paste(root, "/train/subject_train.txt", sep="")
	
}

CreateTmpFiles<-function(){
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
	
}

RemoveTmpObjects<-function(){
	#remove all temporary files and objects
	file.remove("Merge.txt", "Activity.txt", "Subject.txt")
	rm(All, k, mydata, mydata1)
}

Read_FormatDataSet1<-function(){
	features<-read.table("features.txt", sep=" ") #the list of features
	index<-grepl("mean|std|Mean", features[,2]) #the index of the names of the features which are mean or standard dev
	labels<-read.table("activity_labels.txt", sep = " ") #the list of the activity names
	activities<-read.table("Activity.txt") # the 
	outtest<-merge(activities, labels, by.x="V1", by.y="V1")
	dimnames(outtest)[[2]]<-c("V1", "Activity") # fix the name of the activity column
	All<-scan("Merge.txt") #the entire set of measurements as a numeric vector
	k<-matrix(All, ncol=561) #the 561 columns
	mydata<-data.frame(k) # the complete measurement data frame
	mydata1<-mydata[,index] #only 86 variables
	features1<-features[,2][index] #only 86 names for columns
	rowname<-c(1:10299)
#set the name for the variable...
dimnames(mydata1)<-list(rowname, features1)
mydata1<- cbind(mydata1, outtest[2]) #THIS IS THE FIRST TIDY SET...
return(mydata1)



}

Read_FormatDataSet2<-function(ds){
	#create a 2nd indipendent data set with the average for each activity and each subject
mysubjects<-read.table("Subject.txt")
dimnames(mysubjects)[[2]]<-c("Subject")
mydata2<-cbind(ds, mysubjects) # this is the 2nd data set to summarize

library(dplyr)

#group_by and then summarize...
grouped <- group_by(mydata2, Subject, Activity)
k<-summarize(grouped, mean(`tBodyAcc-mean()-X`))
# problema: come nominare tutte le variabili...
return(k)


	
}

Main<-function() {
wd<-getwd() #to reset at the end of the script
#RootFolder<-"/DataScienceFolder/UCI HAR Dataset"
RootFolder<-readline("Provide the path to the project data folder: ")
# read the folder root as an input and check if it exists..
if (!file.exists(RootFolder)) {
	cat ("Root folder not found")
	
} else
{
setwd(RootFolder)

InitFileName(RootFolder)
CreateTmpFiles()

ds1<-Read_FormatDataSet1()
write.table(ds1, "tidyset1.txt")

ds2<- Read_FormatDataSet2(ds1)
write.table(ds2, "tidyset2.txt")

#remove all environment variables and temporary files used 

RemoveTmpObjects()


setwd(wd)
}
}

Main()






