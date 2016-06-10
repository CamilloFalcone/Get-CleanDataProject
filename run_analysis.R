CreateTmpFiles<-function(root){
	#merge the training and test data set files into unique files of features, activities identifiers and subject identifiers
TestFile<-paste(root, "/test/X_test.txt", sep="")
TrainFile <-paste(root, "/train/X_train.txt", sep="")
TestActivityFile<-paste(root, "/test/y_test.txt", sep ="")
TrainActivityFile<-paste(root, "/train/y_train.txt", sep ="")
TestSubjectFile<-paste(root, "/test/subject_test.txt", sep="")
TrainSubjectFile<- paste(root, "/train/subject_train.txt", sep="")

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
	#remove all temporary files 
	file.remove("Merge.txt", "Activity.txt", "Subject.txt")
}

Read_FormatDataSet1<-function(){
	#returns the data frame containing the first tidy set
	#
	features<-read.table("features.txt", sep=" ") #the list of features
	index<-grepl("mean|std|Mean", features[,2]) #the index of the names of the features which contains mean or standard dev values
	labels<-read.table("activity_labels.txt", sep = " ") #the list of the activity names
	RawActivities<-read.table("Activity.txt") # the entire set of activities performed by subjects in the experiment
	Activities <-merge(RawActivities, labels, by.x="V1", by.y="V1") # the set of activities is labelles with the proper name
	dimnames(Activities)[[2]]<-c("V1", "Activity") # fix the name of the activity column to a understandable label
	Measures <-scan("Merge.txt") #the entire set of measurements is read as a numeric vector
	k<-matrix(Measures, ncol=561) #the flat list of measure is transformed in a matrix of observation ( 561 columns)
	mydata<-data.frame(k) # the complete measurement data frame
	mydata1<-mydata[,index] #from the complete data set only 86 variables are extracted, the features which contain mean or sd values
	features1<-features[,2][index] #the name of the 86 variables is extracted from the entire set of feature names
	rowname<-c(1:dim(mydata[1])) # the array to use for fix the name of the rows
#set the name for the variable...
	dimnames(mydata1)<-list(rowname, features1)
	mydata1<- cbind(Activities[2], mydata1) #THIS IS THE FIRST TIDY SET: it contains the subset of the 86 variables in the original complete data set and a new column with the variable Activity with a proper name
return(mydata1)
}

RenameVar<-function(x){
	# to rename the variable for the second data set adding an "avg" prefix
		#if x == Subject or x == Activity skip the renaming..
		if(x =="Subject" | x == "Activity") {
			return(x)
		}
		else {
	return (paste("avg[", x, "]", sep = ""))
	}
}

Read_FormatDataSet2<-function(ds){
	#create a 2nd indipendent data set with the average for each activity and each subject
mysubjects<-read.table("Subject.txt")
dimnames(mysubjects)[[2]]<-c("Subject")
mydata2<-cbind(mysubjects, ds) # this is the 2nd data set to summarize
n1<-names(mydata2) # the array of original variable names to convert into avg[<varname>]
n2<-sapply(n1, RenameVar) #n2 is the vector of new names used to rename the data set
dimnames(mydata2)[[2]]<-n2
library(dplyr)

#group_by and then summarize...
grouped <- group_by(mydata2, Subject, Activity)
k<-summarize_each (grouped, funs(mean)) # the summarize_each function allows to summarize the entire set of variabile
return(k)
	
}

AskRawDataReference<-function(){
#ask the user for the path of the root folder where raw data are available
# check for the existance of the provided path
# if exists returns the Root Folder otherwise returns the "0" char
	RootFolder <-readline("Provide the path to the root of the raw data folders: ")
	if (!file.exists(RootFolder)) {
	
	return("0")
	
} else
{
return(RootFolder)
}
}




Main<-function() {
	# this is the core of the script, see the ReadMe for a description of the steps
wd<-getwd() #the initial working directory is stored in order to reset it at the end of the script
RootFolder<- AskRawDataReference()
if( RootFolder == "0") {
	cat ("Root folder not found")
}
else {	
#RootFolder<-"/DataScienceFolder/UCI HAR Dataset" <--this is the value of my root folder (Mac syntax)
setwd(RootFolder)
CreateTmpFiles(RootFolder)
ds1<-Read_FormatDataSet1()
write.table(ds1, "tidyset1.txt", row.names=FALSE)
ds2<- Read_FormatDataSet2(ds1)
write.table(ds2, "tidyset2.txt", row.names=FALSE)
RemoveTmpObjects()
setwd(wd)
}
}

Main()






