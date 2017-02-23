

library(plyr)
library(dplyr)
library(DBI)
library(data.table)

rm(list=ls())

connection <-src_postgres(dbname = "charity",  options="-c search_path=charity") ## This data is stored in a local database. For a guide to setting up a database yourself, please see: https://data.ncvo.org.uk/a/almanac16/how-to-create-a-database-for-charity-commission-data/

gya_table <- tbl(connection, "gya_prospects")

dis_sport <- as.data.frame(gya_table)

##summary(dis_sport)

names(dis_sport)[names(dis_sport)=="string_agg"] <- "object"

names(dis_sport)[names(dis_sport)=="aob"] <- "area_of_benefit"

dis_sport$main <- ifelse(dis_sport$subno == 0, "TRUE", "FALSE")#Identifying main charities

##Turning categories to factors
cols1 <- c("category_1","category_2", "category_3", "category_4")

dis_sport[cols1] <- lapply(dis_sport[cols1], factor)

rm(cols1)

dis_sport$disability <- ifelse(dis_sport$category_1 == "104" |
                               dis_sport$category_2 == "104" |
                               dis_sport$category_3 == "104" |
                               dis_sport$category_4 == "104", 
                               "TRUE", "FALSE")

dis_sport$disability[is.na(dis_sport$disability )] <- "FALSE"

dis_sport$people_with_disabilities <- ifelse(dis_sport$category_1 == "203" |
                                             dis_sport$category_2 == "203" |
                                             dis_sport$category_3 == "203" |
                                             dis_sport$category_4 == "203",
                                             "TRUE", "FALSE")

dis_sport$people_with_disabilities[is.na(dis_sport$people_with_disabilities )] <- "FALSE"

dis_sport$amateur_sport <- ifelse(dis_sport$category_1 == "110" |
                                  dis_sport$category_2 == "110" |
                                  dis_sport$category_3 == "110" |
                                  dis_sport$category_4 == "110",
                                  "TRUE", "FALSE")

dis_sport$amateur_sport[is.na(dis_sport$amateur_sport )] <- "FALSE"

dis_sport$recreation <- ifelse(dis_sport$category_1 == "116" |
                               dis_sport$category_2 == "116" |
                               dis_sport$category_3 == "116" |
                               dis_sport$category_4 == "116",
                               "TRUE", "FALSE")

dis_sport$recreation[is.na(dis_sport$recreation )] <- "FALSE"

dis_sport$any_disability <- ifelse(dis_sport$people_with_disabilities == "TRUE" |
                                   dis_sport$disability == "TRUE",
                                   "TRUE", "FALSE")

dis_sport$any_disability[is.na(dis_sport$any_disability )] <- "FALSE"

dis_sport$any_sport <- ifelse(dis_sport$amateur_sport == "TRUE" |
                              dis_sport$recreation == "TRUE",
                              "TRUE", "FALSE")

dis_sport$any_sport[is.na(dis_sport$any_sport )] <- "FALSE"

dis_sport$both_cats <- ifelse(dis_sport$any_disability == "TRUE" &
                              dis_sport$any_sport == "TRUE",
                              "TRUE", "FALSE")

dis_sport$both_cats[is.na(dis_sport$both_cats )] <- "FALSE"

dis_sport$category <- NA
dis_sport$category[dis_sport$any_disability == "TRUE" & dis_sport$both_cats=="FALSE"] <- 'Disability'
dis_sport$category[dis_sport$both_cats == "TRUE"] <- 'Disability and Sport'
dis_sport$category[dis_sport$any_sport == "TRUE" & dis_sport$both_cats=="FALSE"] <- 'Sport'

dis_sport$web <- paste0("<a href='", dis_sport$web, "'>", dis_sport$web, "</a>")

dis_sport$web <- gsub("<a href='NA'>NA</a>", "", dis_sport$web)

dis_sport$address <- paste(dis_sport$add1, dis_sport$add2, dis_sport$add3,
                           dis_sport$add4, dis_sport$add5)

#Turning to title case
dis_sport$object <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(dis_sport$object), perl=TRUE)
dis_sport$address <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(dis_sport$address), perl=TRUE)
dis_sport$area_of_benefit <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(dis_sport$area_of_benefit), perl=TRUE)
dis_sport$name <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(dis_sport$name), perl=TRUE)

dis_sport$address <- gsub(" Na","",dis_sport$address)

dis_sport <- subset(dis_sport, is.na(latitude)==FALSE)

dis_sport$incomedate <- as.Date(dis_sport$incomedate)

#summary(dis_sport)

dis_sport <- dis_sport[rev(order(dis_sport$incomedate)),]

dis_sport <- dis_sport[!duplicated(dis_sport[,c('regno', 'subno')]),]

dis_sport <- dis_sport[,c("regno", "name","category","district", "subno", "main",
                          "area_of_benefit","object","region", "address", "phone",
                          "web", "disability","people_with_disabilities",
                          "amateur_sport", "recreation","latitude", "longitude")]

dis_sport$latitude <- as.numeric(dis_sport$latitude)

dis_sport$longitude <- as.numeric(dis_sport$longitude)

cols2 <- c("category","main", "region", "disability","people_with_disabilities","amateur_sport", "recreation")

dis_sport[cols2] <- lapply(dis_sport[cols2], factor)

dis_sport <- data.table(dis_sport)

write_rds(dis_sport, "./data/dis_sport.rds")


