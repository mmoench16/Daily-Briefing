library(tidyRSS)
library(dplyr)
library(stringr)

#BBC <- tidyfeed("http://feeds.bbci.co.uk/news/rss.xml")
#BBCWeather <- tidyfeed("https://weather-broker-cdn.api.bbci.co.uk/en/forecast/rss/3day/2635442")
#DW <- tidyfeed("https://rss.dw.com/rdf/rss-en-all")
#Guardian <- tidyfeed("https://www.theguardian.com/uk/rss")
#PoliticoEU <- tidyfeed("https://www.politico.eu/feed")



# test <- BBCWeather %>% 
#   select(-c(feed_description, feed_language, item_guid)) %>% 
#   mutate(weather_forecast = sapply(strsplit(item_title, ","), getElement, 1) %>% 
#            paste0(", ", item_description)) %>%
#   mutate(weather_forecast = stringr::str_remove_all(weather_forecast, regex("\\(\\d{2}°F\\)")),
#          weather_forecast = stringr::str_replace(weather_forecast, regex("\\w+:"), paste0("<b>", str_extract(weather_forecast, "\\w+:"), "</b>")))
  
# getWeatherData retrieves weather information from the BBC weather feed and returns a list with a 3-day forecast
getWeatherData <- function() {
  BBCWeather <- tidyfeed("https://weather-broker-cdn.api.bbci.co.uk/en/forecast/rss/3day/2635442") %>% 
    select(-c(feed_description, feed_language, item_guid)) %>% 
    mutate(weather_forecast = sapply(strsplit(item_title, ","), getElement, 1) %>% 
             paste0(", ", item_description)) %>%
    mutate(weather_forecast = stringr::str_remove_all(weather_forecast, regex("\\(\\d{2}°F\\)")),
           weather_forecast = stringr::str_replace(weather_forecast, regex("\\w+:"), paste0("<b>", str_extract(weather_forecast, "\\w+:"), "</b>")))
  
  weatherData <- as.list(BBCWeather$weather_forecast)
  names(weatherData) <- c("weather1", "weather2", "weather3")
  
  rm(BBCWeather)
  
  weatherData
}

getCyclingNews <- function() {
  cyclingNews <- tidyfeed("https://www.cyclingweekly.com/news/rss") %>% 
    slice(1:5) %>% 
    select(item_title, item_guid) %>% 
    mutate(item_title = trimws(item_title, which = ("right")),
           headlineHTML = paste0(item_title, " [<a href='", item_guid , "'>read</a>]"))
  
  cyclingNewsData <- as.list(cyclingNews$headlineHTML)
  names(cyclingNewsData) <- c("cycling1", "cycling2", "cycling3", "cycling4", "cycling5")
  
  rm(cyclingNews)
  
  cyclingNewsData
} 

getDWNews <- function() {
  newsDW <- tidyfeed("https://rss.dw.com/rdf/rss-en-all") %>% 
    slice(1:3) %>% 
    select(item_title, item_link) %>% 
    mutate(headlineHTML = paste0(item_title, " [<a href='", item_link , "'>read</a>]"))
  
  newsDWData <- as.list(newsDW$headlineHTML)
  names(newsDWData) <- c("dw1", "dw2", "dw3")
  
  rm(newsDW)
  
  newsDWData
}

getGuardianNews <- function() {
  newsGuardian <- tidyfeed("https://www.theguardian.com/uk/rss") %>% 
    slice(1:3) %>% 
    select(item_title, item_link) %>% 
    mutate(headlineHTML = paste0(item_title, " [<a href='", item_link , "'>read</a>]"))
  
  newsGuardianData <- as.list(newsGuardian$headlineHTML)
  names(newsGuardianData) <- c("guardian1", "guardian2", "guardian3")
  
  rm(newsGuardian)
  
  newsGuardianData
}

getQuote <- function() {
  qod <- tidyfeed("http://feeds.feedburner.com/theysaidso/qod") %>% 
    slice(1:1) %>% 
    select(item_description)
  
  quote_of_day <- as.list(qod$item_description)
  names(quote_of_day) <- c("quote1")
  
  rm(qod)
  quote_of_day
}