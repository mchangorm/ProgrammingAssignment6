#!/usr/bin/env Rscript

## Explanatory Data Analysis
## Course Project 2

## plot4.R
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

# We need to get coal combustion related sources
# Information is located in SCC 
# combustion is in SCC$SCC.Level.One as "combustion"
# coal is in SCC$SCC.Level.Four as "coal"
# We form a logical vector for each and then combine them together
# The resultant logical vector would be an intersection of both criteria

combustion <- grepl("comb",SCC$SCC.Level.One,ignore.case = TRUE)
coal <- grepl("coal",SCC$SCC.Level.Four,ignore.case = TRUE)
combustioncoal <- (combustion & coal)

# Let's filter the SCC criteria now by the logical vector
# to get the SCC numbers
SCCcombcoal <- SCC[combustioncoal,]$SCC

# And now subset the NEI data
NEIcombcoal <- NEI[NEI$SCC %in% SCCcombcoal,]

NEIagg <- aggregate(Emissions ~ year, data=NEIcombcoal, FUN=sum)

#png(filename="plot4.png",width=480,height=480)

NEIplot <- ggplot(NEIagg,aes(x=factor(year),y=Emissions / 10^6)) + 
  geom_bar(stat="identity",linewidth = 0.75) +
  geom_point(size = 2) +
  labs(title="Emissions by SCC Coal Combustion Types over Years",
       x = "Years",
       y = "Emissions / 10^6 Tons"
  )

print(NEIplot)

#dev.off()
