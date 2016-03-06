# plot4.R

library(lubridate)
library(dplyr)

        download.file <- "household_power_consumption.zip"
        project.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

        setwd("/home/doug/Documents/Education/Coursera/04_Exploratory Data Analysis/Week_1/project")

        if(!file.exists(download.file)) {
                download.file(project.url, download.file, "auto")
                date.downloaded <- date()
    
                unzip(download.file, exdir = "./", junkpaths = TRUE)
        }

      household.df <- read.csv("household_power_consumption.txt", 
                               header = TRUE, 
                               sep=";", 
                               stringsAsFactors = FALSE, 
                               na.strings = c("?", "NA")
                               )
      
      household.df <- mutate(household.df, event.datetime = dmy(household.df$Date) + hms(household.df$Time))
      my.arranged.household.df <- select(household.df, event.datetime, 1:9)
      tm.low <- as.POSIXct("2007-02-01 00:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
      tm.high <- as.POSIXct("2007-02-02 23:59:59", format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

      my.household.range <- filter(my.arranged.household.df, event.datetime >= tm.low & event.datetime <= tm.high) ## 2007-02-01 and 2007-02-02
      
      # free up memory
      rm(household.df)

      
      plot.new()
      png("plot4.png", width = 480, height = 480)
      
      # Set up the canvas to be 2 rows and 2 columns
      par(mfrow = c(2,2))
      
      # Global Active Power over time
      with(my.household.range, 
           plot(event.datetime, 
                Global_active_power, col = "black", 
                type = "l", 
                pch = ".", 
                xlab = "",
                ylab = "Global Active Power (kilowatts)"))

      # Voltage over time
      with(my.household.range, plot(event.datetime, Voltage, col = "black", pch = ".", type = "l", ylab = "Voltage", xlab = "datetime"))
      
      # Multiple Sub Metering over time
      with(my.household.range, plot(event.datetime, Sub_metering_1, col = "black", pch = ".", type = "l", ylab = "Energy Sub Metering", xlab = ""))
      par(new = TRUE)
      with(my.household.range, plot(event.datetime, Sub_metering_2, col = "red", pch = ".", type = "l", ylab = "", xlab = "", ylim = c(0, max(Sub_metering_1))))
      par(new = TRUE)
      with(my.household.range, plot(event.datetime, Sub_metering_3, col = "blue", pch = ".", type = "l", ylab = "", xlab = "", ylim = c(0, max(Sub_metering_1))))
      legend("topright", col = c("black", "red", "blue"), pch = 46, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, bty = "n")


      # Global Reactive Power over time
      with(my.household.range, plot(event.datetime, Global_reactive_power, col = "black", pch = ".", type = "l", ylab = "Global Reactive Power", xlab = "datetime"))

      dev.off()

##
##