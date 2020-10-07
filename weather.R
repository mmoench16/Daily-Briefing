library(httr)
library(jsonlite)
library(tidyverse)

apiKey <- "apikey"
baseURL <- "http://datapoint.metoffice.gov.uk/public/data/{resource}?key={APIkey}"

create_query <- function(params = "") {
  paste0("http://datapoint.metoffice.gov.uk/public/data/", params, "?key=apikey")
}

sitelist <- GET(create_query("val/wxfcs/all/json/sitelist"))
sitelist <- content(sitelist, "text")
sitelist <- fromJSON(sitelist, flatten = TRUE)
sitelist <- as.data.frame(sitelist)
SouthAyrshireLocations <- sitelist %>% 
  filter(Locations.Location.unitaryAuthArea == "South Ayrshire")

# Troon Location ID: 353990

# Get all regions eligible for text forecase
regions <- GET(create_query("txt/wxfcs/regionalforecast/json/sitelist"))
regions <- content(regions, "text")
regions <- fromJSON(regions, flatten = T)
regions <- as.data.frame(regions)

# Strathclyde region: 503

regionalFC <- GET(create_query("txt/wxfcs/regionalforecast/json/503")) %>% 
  content(., "text") %>% 
  fromJSON(., flatten = TRUE) %>% 
  as.data.frame(.)

test <- as.data.frame(regionalFC$RegionalFcst.FcstPeriods.Period.Paragraph)
