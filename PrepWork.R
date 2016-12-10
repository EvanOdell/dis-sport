dis_sport$governing_documents <- dis_sport$gd
dis_sport$LLSOA <- NULL

names(dis_sport)[4] <- "name"

dis_sport$Amateur_Sport <- 1
dis_sport$Disability <- 2
dis_sport$People_With_Disabilities <- 3
dis_sport$Recreation <- 4


dis_sport <- subset(dis_sport, is.na(Latitude)==FALSE)

dis_sport <- as.data.frame(dis_sport)

saveRDS(dis_sport, "dis_sport.rds")


