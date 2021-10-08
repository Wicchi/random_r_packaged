dta <- read.fwf(file = "https://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/01548500.dly",
                widths = c(8, rep(x = 10,
                                  times = 5)),
                col.names = c("DTM", "P", "E", "Q", "Tmax", "Tmin"))

head(x = dta)
str(object = dta)

dta$DTM <- as.Date(x = gsub(pattern = " ",
                            replacement = "0",
                            x = dta$DTM),
                   format = "%Y%m%d")

ids <- readLines(con = "https://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/")
ids <- substr(x = ids,
              start = 82,
              stop = 93)
ids <- ids[grep(pattern = ".dly",
                x = ids)]
ids <- gsub(pattern = ".dly",
            replacement = "",
            x = ids)
head(ids)

data_download <- function(id, 
                          save = FALSE, 
                          path = NULL, 
                          file_name = NULL) {
  
  dta <- lapply(
    X = id, 
    FUN = function(x) {
      
      message(paste("downloading", x))
      
      dl <- read.fwf(file = paste0("https://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/", 
                                   x,
                                   ".dly"),
                     widths = c(8, rep(x = 10,
                                       times = 5)),
                     col.names = c("DTM", "P", "E", "Q", "Tmax", "Tmin"))
      
      dl$DTM <- as.Date(x = gsub(pattern = " ",
                                 replacement = "0",
                                 x = dl$DTM),
                        format = "%Y%m%d")
      dl$ID <- x
      
      dl
    } 
  )
  
  dta_bind <- do.call(what = rbind,
                      args = dta)
  dta_bind$ID <- as.factor(x = dta_bind$ID)

  if (save) {
    
    if (any(is.null(x = path), 
            is.null(x = file_name))) {
      
      stop("path or filename was not supplied")
    }
    
    write.csv(x = dta_bind,
              file = file.path(path, file_name))
    
    if (file.exists(file.path(path, file_name))) {
      
      message("file created succesfully")
    }
  }
  
  dta_bind
}

test <- data_download(id = ids[5:10])

str(test)

test <- data_download(id = ids[1], 
                      save = TRUE)
test <- data_download(id = ids[1], 
                      save = TRUE,
                      path = getwd(),
                      file_name = "data.csv")
file.exists("data.csv")

