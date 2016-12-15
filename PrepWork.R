
library(readr)
dis_sport <- read_csv("~/GYAMaps/dis-sport/dis_sport.csv", col_types = cols(incomedate = col_date(format = "%d/%m/%Y")))
View(dis_sport)


dis_sport$governing_documents <- dis_sport$gd
dis_sport$LLSOA <- NULL

names(dis_sport)[4] <- "name"

dis_sport$Amateur_Sport <- 1
dis_sport$Disability <- 2
dis_sport$People_With_Disabilities <- 3
dis_sport$Recreation <- 4


dis_sport <- subset(dis_sport, is.na(Latitude) == FALSE)

dis_sport <- as.data.frame(dis_sport)

saveRDS(dis_sport, "dis_sport.rds")

dis_sport <- readRDS("dis_sport.rds")

write.csv(dis_sport, "dis_sport.csv", row.names = FALSE)

dis_sport$category_type <- as.factor(dis_sport$category_type)


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

