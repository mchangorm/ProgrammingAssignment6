#!/usr/bin/env Rscript

## Explanatory Data Analysis
## Course Project 2

## plot1.R
## by Mark Chang

#library("data.table")
#library("ggplot2")


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

# Agregate emissions by year
NEIagg <- aggregate(Emissions ~ year, data=NEI, FUN=sum)

# Scale emissions by million for cleaner axis

png(filename="plot1.png",width=480,height=480)

barplot(height = NEIagg$Emissions / 1000000,
        width = 2,
        names = NEIagg$year,
        xlab = "Years",
        ylab = "Emissions (Millions of Tons)",
        main = "Emissions over the years"
        )

dev.off()
