#
# Author: Wayne E. Seguin <wayneeseguin@gmail.com>
#

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

# Read in the data set
df <- read.csv("hpc.csv", header=TRUE, sep=';', na.strings='?')

df$datetime <- strptime(paste(df$Date,df$Time), "%d/%m/%Y %H:%M")

# Plot the Data!
png("plot4.png",width=480,height=480,units="px",bg="transparent")

# Multiple Plots
par(mfrow=c(2,2))

message("Global Active Power Plot ( top left )")
plot(df$datetime,df$Global_active_power,xlab ="", ylab = "Global Active Power", type ="l")

message("Voltage Plot ( top right )")
plot(df$datetime,df$Voltage,xlab ="datetime", ylab = "Voltage", type ="l")

message("Energy Sub Metering Plot ( bottom left )")
plot(df$datetime, df$Sub_metering_1,xlab ="", ylab = "Energy sub metering", type ="l",col = 'black')
lines(df$datetime, df$Sub_metering_2, col = "red")
lines(df$datetime, df$Sub_metering_3, col = "blue")
legend('topright', c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c('black','red','blue'), lty = 1, lwd = 3)

message("Global Reactive Power Plot ( bottom right )")
plot(df$datetime,df$Global_reactive_power,xlab ="datetime", ylab = "Global_reactive_power", type ="l")

dev.off() # Close the PNG device!
