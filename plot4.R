###Load data from web
temp<-tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile=temp, mode="wb")
EX<-read.csv(unzip(temp), header=T, stringsAsFactors=F, sep=";", colClasses=c("character",rep("NULL",8)))


###Find corresponding rows for dates
first<-which(grepl("1/2/2007",EX$Date,fixed=T))
last<-which(grepl("2/2/2007",EX$Date,fixed=T))

firstrow<-first[1]
lastrow<-last[length(last)]

### Load dataset for specified dates

DT<-read.csv(unzip(temp), header=T, stringsAsFactors=F, sep=";",skip=firstrow-1,nrows=2880,na.strings="?", col.names=c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))
unlink(temp)

### Concatenate Date and Time Column
DT$Date<-paste(DT$Date,DT$Time, sep=" ")
DT<-DT[,-2]

### plot timeseries and save as *.png

DT$Date<-strptime(DT$Date,format="%d/%m/%Y %H:%M:%S")
png(filename="plot4.png", width = 480, height = 480, units = "px")
par(mfrow=c(2,2))
plot(DT$Date, DT$Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", col="black", type="l")
plot(DT$Date, DT$Voltage, ylab="Voltage", xlab="datetime", col="black", type="l")
plot(DT$Date, DT$Sub_metering_1, xlab="", ylab="Energy sub metering", col="black", type="l")
lines(DT$Date, DT$Sub_metering_2, col="red")
lines(DT$Date, DT$Sub_metering_3, col="blue")
legend(x="topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), cex=0.8, col=c("black","red","blue"), lty=1)
plot(DT$Date, DT$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", col="black", type="l", ylim=c(0.0,0.5))
dev.off()

