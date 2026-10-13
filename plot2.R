#!/usr/bin/env Rscript

## Explanatory Data Analysis
## Course Project 2

## plot2.R
## by Mark Chang

#library("data.table")
#library("ggplot2")


# Windows
#setwd("C:\\Users\\mchang\\Projects\\ProgrammingAssignment5")

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

NEIbalt <- subset(NEI, fips == "24510")

# Agregate emissions by year
NEIagg <- aggregate(Emissions ~ year, data=NEIbalt, FUN=sum)

png(filename="plot2.png",width=480,height=480)

barplot(height = NEIagg$Emissions,
        width = 2,
        names = NEIagg$year,
        xlab = "Years",
        ylab = "Emissions",
        main = "Emissions of Baltimore City over the years"
)

dev.off()
