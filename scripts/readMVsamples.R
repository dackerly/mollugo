require(RCurl)
setwd('/Users/david/Documents/Projects/BerkeleyLab/Postdocs/Hereford/climate_data_2015/mollugo_git')

x='https://raw.githubusercontent.com/dackerly/mollugo/master/data/Mverticillata_20150630_exp.csv'
mv <- read.csv(text=getURL(x, followlocation = TRUE, cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
head(mv)


# make spatial points object
mpts <- SpatialPoints(mv[,c('long.aea','lat.aea')])
proj4string(mpts) <- CRS('+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000')
plot(mpts)

# load soil thickness
st <- raster('rasters/soil_thick.asc')
plot(st)
plot(mpts,add=T)

#extract soil thickness
mv$soil_thick <- extract(st,mpts)
head(mv)
