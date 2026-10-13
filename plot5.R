#!/usr/bin/env Rscript

## Explanatory Data Analysis
## Course Project 2

## plot5.R
## by Mark Chang

#library("data.table")
library("ggplot2")


# Windows
#setwd("C:\\Users\\mchang\\Projects\\ProgrammingAssignment6")

# Mac
setwd("/Users/mchang/Projects/ProgrammingAssignment6")

path <- getwd()
datasetpath <- file.path(path,"dataset")
datafilename <- "dataFiles.zip"

#if ( !dir.exists(datasetpath))
#{
#    dir.create(datasetpath)
#} else
#{
#   unlink(datasetpath, recursive = TRUE)
#}

# Download file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(url, file.path(path, datafilename))
#unzip(zipfile = datafilename, exdir = datasetpath)

# Read in RDS files (R data frame files)
NEI <- readRDS("dataset/summarySCC_PM25.rds")
SCC <- readRDS("dataset/Source_Classification_Code.rds")

# We need to get motor vehicle sources from Baltimore City
# First get Baltimore then get motor vehicle
# Baltimore is fips = 24510
# Motor vehicle is probably type = onroad
NEIbaltveh1 <- subset(NEI, fips == "24510" & type == "ON-ROAD")

NEIagg1 <- aggregate(Emissions ~ year, data=NEIbaltveh1, FUN=sum)

png(filename="plot5-1.png",width=480,height=480)

NEIplot1 <- ggplot(NEIagg1,aes(x=factor(year),y=Emissions / 10^5)) + 
  geom_bar(stat="identity",linewidth = 0.75) +
  labs(title="Motor Vehicle Emissions in Baltimore City over Years",
       x = "Years",
       y = "Emissions / 10^5 Tons"
  )

print(NEIplot1)

dev.off()

# The other way is to subset the SCC for any criteria that corresponds
# to vehicles using the same method in plot4
# from inspection, the vehicle specs seem to be in Level 2
vehicle <- grepl("vehicle",SCC$SCC.Level.Two,ignore.case = TRUE)
SCCveh <- SCC[vehicle,]$SCC
NEIveh2 <- NEI[NEI$SCC %in% SCCveh,]

NEIbaltveh2 <- subset(NEIveh2, fips == "24510")

NEIagg2 <- aggregate(Emissions ~ year, data=NEIbaltveh2, FUN=sum)

png(filename="plot5-2.png",width=480,height=480)

NEIplot2 <- ggplot(NEIagg2,aes(x=factor(year),y=Emissions / 10^5)) + 
  geom_bar(stat="identity",linewidth = 0.75) +
  labs(title="Motor Vehicle Emissions in Baltimore City over Years",
       x = "Years",
       y = "Emissions / 10^5 Tons"
  )

print(NEIplot2)

dev.off()