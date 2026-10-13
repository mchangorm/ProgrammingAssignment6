#!/usr/bin/env Rscript

## Explanatory Data Analysis
## Course Project 2

## plot6.R
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

NEIveh <- subset(NEI, type == "ON-ROAD")
NEIvehcnt <- subset(NEIveh, fips %in% c("06037","24510"))

NEIagg1 <- aggregate(Emissions~fips + year, data=NEIvehcnt, FUN=sum)

# Let's attempt to relabel the fips factors
new_city_labels <- c( "06037" = "Los Angeles County",
                      "24510" = "Baltimore City"
                    )

png(filename="plot6.png",width=480,height=480)

NEIplot1 <- ggplot(NEIagg1,aes(x=factor(year),y=Emissions/10^3)) + 
  geom_bar(stat="identity",linewidth = 0.75) +
#  geom_line(linewidth = 1) +
#  geom_point(size = 1) +
#  geom_text(aes(label=Emissions),size=1,nudge_x=0.1) +
  facet_grid(.~fips,scales="free") +
#  facet_grid(~fips,labeller=as_labeller(fips)) +
  labs(title="Motor Vehicle Emissions over Years",
       x = "Years",
       y = "Emissions / 10^3 Tons"
  )

print(NEIplot1)

dev.off()
