## moll data extract 2.0, after June 25 meeting with Joe and Annie
## extract monthly climate values for mollugo points and for all other months and years at each location

rm(list=ls())
setwd('/Users/david/Documents/Projects/BerkeleyLab/Postdocs/Hereford/climate_data_2015/')
require(raster)
#source('xMonthly.R')

## create character and numeric month vectors
smonths <- c('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec')
nmonths <- as.character(1:12)
nmonths[1:9] <- paste('0',nmonths[1:9],sep='')
cbind(nmonths,smonths)

# vector of number of days at start of each month (non-leap-year) to calcualte DOY
mstart <- c(0,31,28,31,30,31,30,31,31,30,31,30)
cmstart <- cumsum(mstart)

## load mollugo data
mv <- read.csv('sample_files/Mverticillata_20150625.csv',as.is=T)
head(mv)
dim(mv)

## convert months to 2 char numbers and integer value months as well
mv$ShortMonth <- tolower(mv$ShortMonth)
all(mv$ShortMonth%in%smonths)
mv$mon.char <- nmonths[match(mv$ShortMonth,smonths)]
mv$month <- match(mv$ShortMonth,smonths)
table(mv$month,mv$ShortMonth)
head(mv)

dnc <- nchar(mv$date)
mv$day.char <- substr(mv$date,1,dnc-4)
mv$day.char[nchar(mv$day.char)==1] <- paste('0',mv$day.char[nchar(mv$day.char)==1],sep='')
mv$day <- as.numeric(mv$day.char)
head(mv)

#create year/month as one value, to match with file names
mv$year_nm <- paste(mv$year,mv$mon.char,sep='_')
mv$ydate <- paste(mv$year,mv$mon.char,mv$day.char,sep='-')
head(mv)

table(mv$year_nm)
sum(table(mv$year_nm))

