# extract climate data for a point in a given year and month, for one or more
xMonthly <- function(ll,fac=c('ppt','tmn','tmx'),cdir='/Volumes/DAckerly_B/BCM/CA_2014/HST/monthly/Rdata/') {
    ## ll is a dataframe that includes 'long', 'lat', and 'year_nm'
    require(sp)
    require(rgeos)
    dem <- raster('/Users/Shared/gisdata/climate_layers/BCM/CA_topography/ca_270m_t6.asc')
    good.extent <- extent(dem)
    llSP <- ll
    coordinates(llSP) <- ll[,c('long','lat')]
    projection(llSP) <- CRS('+proj=longlat +datum=WGS84')
    #class(llSP)
    llSP.aea <- spTransform(llSP,CRS('+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000'))
    if (FALSE) plot(llSP.aea)
    
    lfac <- length(fac)
    climvals <- matrix(NA,nrow=nrow(ll),ncol=lfac)
    i=3
    for (i in 1:lfac) {
        fname <- paste(cdir,fac[i],'/CA_BCM_HST_Monthly_',fac[i],'_',ll$year_nm[1],'.Rdata',sep='')
        ras <- readRDS(fname)[[1]]
        extent(ras) <- good.extent
        vals <- extract(ras,llSP.aea)
        climvals[,i] <- vals
    }
    climvals <- data.frame(climvals)
    names(climvals) <- fac
    #ll <- data.frame(ll,climvals)
    return(climvals)
}

xMonthlyRand <- function(nRand=10,year_mn='2000_01',fac=c('ppt','tmn','tmx'),cdir='/Volumes/DAckerly_B/BCM/CA_2014/HST/monthly/Rdata/') {
    ## ll is a dataframe that includes 'long', 'lat', and 'year_nm'
    require(raster)
    dem <- raster('/Users/Shared/gisdata/climate_layers/BCM/CA_topography/ca_270m_t6.asc')
    good.extent <- extent(dem)
    
    lfac <- length(fac)
    climvals <- matrix(NA,nrow=nrow(ll),ncol=lfac)
    fname <- paste(cdir,fac[1],'/CA_BCM_HST_Monthly_',fac[1],'_',year_mn,'.Rdata',sep='')
    ras <- readRDS(fname)[[1]]
    extent(ras) <- good.extent
    rass <- stack(ras)
    i=2
    if (lfac>1) {
        for (i in 2:lfac) {
            fname <- paste(cdir,fac[i],'/CA_BCM_HST_Monthly_',fac[i],'_',year_mn,'.Rdata',sep='')
            ras <- readRDS(fname)[[1]]
            extent(ras) <- good.extent
            rass <- addLayer(rass,ras)
        }
    }
    vals <- getValues(rass)
    rsel <- which(complete.cases(vals))
    vals <- vals[rsel,]
    rSamp <- sample(nrow(vals),nRand)
    climvals <- vals[rSamp,]
    
    xy <- xyFromCell(rass,1:length(rass[[1]]))
    xy <- xy[rsel,]
    xy <- xy[rSamp,]
    climvals <- data.frame(xy,climvals)
    names(climvals) <- c('long.aea','lat.aea',fac)
    return(climvals)
}