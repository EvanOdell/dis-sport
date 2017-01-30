
library(readr)
library(plyr)
library(dplyr)
dis_sport <- read_csv("~/GYAMaps/dis-sport/dis_sport.csv", col_types = cols(incomedate = col_date(format = "%d/%m/%Y")))
View(dis_sport)

summary(dis_sport)

dis_sport$main <- as.numeric(dis_sport$subno == 0)
summary(dis_sport$main)
dis_sport$main <- as.factor(dis_sport$main)
summary(dis_sport$main)
dis_sport$main <- as.numeric(dis_sport$subno != 0)
summary(dis_sport$main)
dis_sport$main <- as.numeric(dis_sport$subno == 0)
dis_sport$main <- as.factor(dis_sport$main)
questionr:::irec()
dis_sport$main <- as.character(dis_sport$main)
dis_sport$main[dis_sport$main == "0"] <- FALSE
dis_sport$main[dis_sport$main == "1"] <- TRUE
dis_sport$main <- as.factor(dis_sport$main)
summary(dis_sport$main)



dis_sport$category_1 <- as.factor(dis_sport$category_1)

dis_sport$category_2 <- as.factor(dis_sport$category_2)

dis_sport$category_3 <- as.factor(dis_sport$category_3)

dis_sport$category_4 <- as.factor(dis_sport$category_4)

dis_sport$disability <- ifelse(dis_sport$category_1 == "Disability" | dis_sport$category_2 == "Disability" | dis_sport$category_3 == 
                                 "Disability" | dis_sport$category_4 == "Disability", "TRUE", "FALSE")

dis_sport$people_with_disabilities <- ifelse(dis_sport$category_1 == "Disability" | dis_sport$category_2 == "Disability" | 
                                               dis_sport$category_3 == "Disability" | dis_sport$category_4 == "Disability", "TRUE", "FALSE")

dis_sport$amateur_sport <- ifelse(dis_sport$category_1 == "Disability" | dis_sport$category_2 == "Disability" | dis_sport$category_3 == 
                                    "Disability" | dis_sport$category_4 == "Disability", "TRUE", "FALSE")

dis_sport$recreation <- ifelse(dis_sport$category_1 == "Disability" | dis_sport$category_2 == "Disability" | dis_sport$category_3 == 
                                 "Disability" | dis_sport$category_4 == "Disability", "TRUE", "FALSE")

dis_sport$any_disability <- ifelse(dis_sport$people_with_disabilities == "TRUE" | dis_sport$disability == "TRUE", "TRUE", 
                                   "FALSE")

dis_sport$any_sport <- ifelse(dis_sport$amateur_sport == "TRUE" | dis_sport$recreation == "TRUE", "TRUE", "FALSE")

dis_sport$both_cats <- ifelse(dis_sport$any_disability == "TRUE" | dis_sport$any_sport == "TRUE", "TRUE", "FALSE")


dis_sport$disability <- as.factor(dis_sport$disability)

dis_sport$people_with_disabilities <- as.factor(dis_sport$people_with_disabilities)

dis_sport$amateur_sport <- as.factor(dis_sport$amateur_sport)

dis_sport$recreation <- as.factor(dis_sport$recreation)

dis_sport$any_disability <- as.factor(dis_sport$any_disability)

dis_sport$any_sport <- as.factor(dis_sport$any_sport)

dis_sport$both_cats <- as.factor(dis_sport$both_cats)

dis_sport$country <- as.factor(dis_sport$country)

dis_sport$category_type <- as.factor(dis_sport$category_type)

names(dis_sport)[names(dis_sport) == "category_type"] <- "category"

dis_sport$district <- as.factor(dis_sport$district)

summary(dis_sport)

dis_sport$regno <- as.character(dis_sport$regno)

dis_sport$corr <- NULL

dis_sport$web <- paste0("<a href='", dis_sport$web, "'>", dis_sport$web, "</a>")

dis_sport$web <- gsub("<a href='NA'>NA</a>", "", dis_sport$web)

dis_sport <- dis_sport[,c("regno", "subno", "main", "name", "area_of_benefit",
                          "district", "region", "address", "phone", "web",
                          "any_disability", "any_sport", "both_cats",
                          "people_with_disabilities", "amateur_sport", "recreation",
                          "category", "postcode", "object", "category_1",
                          "category_2", "category_3", "category_4", "income",
                          "incomedate", "latitude", "longitude", "constituency",
                          "country", "county")]

write_rds(dis_sport, "./data/dis_sport.rds")

# GYA$web <- paste0('<a href='',GYA$web,''>',GYA$web,'</a>')

# write_rds(GYA, './data/GYA.rds')




