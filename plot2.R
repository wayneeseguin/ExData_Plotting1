#
# Author: Wayne E. Seguin <wayneeseguin@gmail.com>
#
# NOTE: This code will only execute on Linux/OSX not Windows as it uses 
# the `grep` and `head` CLI system tools

# Download Data File Archive
fileName <- "household_power_consumption.zip"
if(! file.exists(fileName)) {
	 message("Downloading the data set archive...")
	 fileURL="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
	 download.file(url=fileURL,destfile=fileName,method="curl")
}
# Extract Data File
if(! file.exists("household_power_consumption.txt")) {
	 message("Extracting the data set files from the archive...")
	unzip(zipfile=fileName, exdir="./")
}

# Extract a subset of the data for the dates 2007-02-01 and 2007-02-02
system("(head -1 household_power_consumption.txt ; grep '^[1|2]/2/2007' household_power_consumption.txt ) > hpc.csv")

# Compute timestamp field
df$datetime <- strptime(paste(df$Date,df$Time), "%d/%m/%Y %H:%M")

# Read in the data set
df <- read.csv("hpc.csv", header=TRUE, sep=';', na.strings='?')

# Compute the timestamp field
df$datetime <- strptime(paste(df$Date,df$Time), "%d/%m/%Y %H:%M")

# Plot the Data!
png("plot2.png",width=480,height=480,units="px",bg="transparent")

message("Global Active Power Plot")

plot(
	df$datetime,
	df$Global_active_power,
	xlab ="",
	ylab = "Global Active Power",
	type ="l"
)

dev.off() # Close the PNG device!
