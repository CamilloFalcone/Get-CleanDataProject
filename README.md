# Get-CleanDataProject
This repo includes a script to create two tidy date sets extracted from the raw data set resulted from a wearable computing experiment.
During such experiment, as described in activityrecognition@smartlab.ws, a set of measurement has been taken from 30 users using a wearable device.

The script is organized around a Main function which performs the following steps:
	asking the user for the path name where the original raw data files are available
	checking for the existence of the path provided
	set the working directory to the provided path
	merging the test and train files into a unique set of files of features, activities and subjects
	process the the data in order to produce the first data frame 
	save the data frame into a file located in the folder initially provided by the user (tidyset1.txt) 
	use the first data set to produce a second one, which is then saved into a file (tidyset2.txt), located in the same folder as the previous one

More details on the programming solutions are provided as comments in the script code.
Details on the data set provided are described in the CodeBook.
	
	
