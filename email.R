library(emayili)
library(magrittr)
library(whisker)

source("rss.R")

htmlCode <- readLines("template.html")

BBCWeatherData <- getWeatherData()
CyclingNews <- getCyclingNews()
DWNews <- getDWNews()
GuardianNews <- getGuardianNews()
QuoteOfDay <- getQuote()
Date <- list(date1 = format(Sys.Date(), format = "%d %b %Y"))

htmlCode <- whisker.render(htmlCode, c(BBCWeatherData, DWNews, GuardianNews, CyclingNews, Date, QuoteOfDay))

email <- envelope() %>%
  from(Sys.getenv("USERNAME")) %>%
  to(Sys.getenv("RECIPIENT")) %>%
  subject(paste0("Daily Briefing - ", format(Sys.Date(), format = "%d %B %Y"))) %>%
  html(htmlCode)

smtp <- server(host = "smtp.mail.yahoo.com",
               port = 587,
               username = Sys.getenv("USERNAME"),
               password = Sys.getenv("PASSWORD"))

try(smtp(email), silent = T)
# smtp(email)
# email

