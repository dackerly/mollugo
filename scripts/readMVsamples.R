## moll data extract 2.0, after June 25 meeting with Joe and Annie
## extract monthly climate values for mollugo points and for all other months and years at each location

rm(list=ls())
setwd('/Users/david/Documents/Projects/BerkeleyLab/Postdocs/Hereford/climate_data_2015/mollugo_git/')
require(raster)
require(sp)
require(rgeos)

## create character and numeric month vectors
smonths <- c('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec')
nmonths <- as.character(1:12)
nmonths[1:9] <- paste('0',nmonths[1:9],sep='')
cbind(nmonths,smonths)

# vector of number of days at start of each month (non-leap-year) to calcualte DOY
mstart <- c(0,31,28,31,30,31,30,31,31,30,31,30)
cmstart <- cumsum(mstart)

## load mollugo data
## EDIT TO READ RAW FROM GIT
mv <- read.csv('data/Mverticillata_20150625.csv',as.is=T)
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

#create year/month as one value, to match with file names
mv$year_nm <- paste(mv$year,mv$mon.char,sep='_')
mv$ydate <- paste(mv$year,mv$mon.char,mv$day.char,sep='-')
head(mv)

table(mv$year_nm)


# make spatial points object
mpts <- SpatialPoints(mv[,c('long','lat')])
proj4string(mpts) <- CRS('+proj=longlat +datum=WGS84')
mpts.aea <- spTransform(mpts,CRS('+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000'))
plot(mpts.aea)

# load soil thickness
## EDIT TO READ RAW FROM GIT IF POSSIBLE
st <- raster('rasters/soil_thick.asc')
plot(st)
plot(mpts.aea,add=T)

#extract soil thickness
mv$soil_thick <- extract(st,mpts.aea)
head(mv)

# which ones are missing soil thickness - these need to be checked if they are placed in the water
missing.soil <- which(is.na(mv$soil_thick))
mv$SPECIMEN[missing.soil]
