# Getting and Cleaning Data ProjecT

## Files

- ```README.md``` - this file
- ```run_analysis.R``` - the R code to extract, build and tidy the data
- ```CodeBook.md``` - a markdown file that contains a listing of all the variables used in the output data set

## Original instructions

You should create one R script called ```run_analysis.R``` that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Main script and how to run it

From the command line, the script can be run as follows:

```Rscript run_analysis.R```

The script automatically

- creates a ```data``` directory (it will not try to create it again if it already exists)
- downloads the "data" file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  (it will not try to download it again if it already exists) and stores into the ```data``` directory
- unzips the zip file into the ```data/UCI HAR Dataset``` directory  (it will not try to unzip it if it already exists).
- loads the ```activity_labels.txt``` file to load the activity code labels
- loads the ```features.txt``` file to load the features
- determine the indices of desired features (those containing ```-mean()``` or ```-std()```)
- reads in the test data, and only keep the mean and standard deviation data (as per previous step)
- reads in the training data, and only keep the mean and standard deviation data (as per step before previous one)
- merge the test and training data sets and give the labels more meaningful names
- reshape the data set to use label and subject as identifiers
- creates an output file containing the tidied up data (with the average of each variable for each activity/subject combination; 180 rows) into a file called ```tidy-data.txt```. This files is created in the same directory as the script.
- creates a file called ```CodeBook.md```, a markdown file that contains a listing of all the variables used in the data set.

The script will automatically install the necessary dependencies for you. The only dependency is on the ```reshape2``` package.

For a description of the data types and how the data was collected, please take a look at the files included with the original data, such as ```README.txt``` and ```features_info.txt```.
