if (!file.exists("exdata_data_household_power_consumption.zip")) {
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="exdata_data_household_power_consumption.zip", mode="wb")
}

# unzip archive if not unzipped
if (!file.exists("household_power_consumption.txt")) {
    unzip("exdata_data_household_power_consumption.zip", overwrite=FALSE)
}

# superficial file analisis
data <- readLines("household_power_consumption.txt", 5)
data
rm(data)

# creating tidy dataset dataframe_electricity.R if not existing
if (!file.exists("dataframe_electricity.R")) {
    data <- read.table("household_power_consumption.txt", sep=";", nrows=2075260, na.strings="?", header=TRUE, colClasses=c("character", "character", "numeric", "numeric", "numeric",  "numeric", "numeric", "numeric", "numeric"))
    data <- data[data$Date == "1/2/2007" | data$Date == "2/2/2007", ]
    data$Time <- paste(data$Date, " ", data$Time)
    data$Date <- as.Date(data$Date, format="%d/%m/%Y")
    data$Time <- strptime(data$Time, format="%d/%m/%Y %H:%M:%S")
    rownames(data) = 1:length(data$Date)
    dump("data", file="dataframe_electricity.R")
    rm(data)
}

source("dataframe_electricity.R")

# make graph
png("plot2.png", width=480, height=480)
with(data, plot(Time, Global_active_power, type="n", ylab="Global Active Power (kilowatts)", xlab=" "))
with(data, lines(Time, Global_active_power))
dev.off()
