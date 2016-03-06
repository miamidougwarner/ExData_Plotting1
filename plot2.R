# plot2.R

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
      png("plot2.png", width = 480, height = 480)
      with(my.household.range, 
           plot(event.datetime, 
                Global_active_power, col = "black", 
                type = "l", 
                pch = ".", 
                xlab = "",
                ylab = "Global Active Power (kilowatts)"))
      dev.off()

