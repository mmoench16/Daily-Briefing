library(emayili)
library(magrittr)
library(whisker)

source("rss.R")

htmlCode <- readLines("template.html")

BBCWeatherData <- getWeatherData()
CyclingNews <- getCyclingNews()
DWNews <- getDWNews()
GuardianNews <- getGuardianNews()

htmlCode <- whisker.render(htmlCode, c(BBCWeatherData, DWNews, GuardianNews, CyclingNews))

email <- envelope() %>%
  from(Sys.getenv("USERNAME")) %>%
  to(Sys.getenv("RECIPIENT")) %>%
  subject("Test") %>%
  html(htmlCode)

smtp <- server(host = "smtp.mail.yahoo.com",
               port = 587,
               username = Sys.getenv("USERNAME"),
               password = Sys.getenv("PASSWORD"))

# try(smtp(email), silent = T)
smtp(email)
# email
