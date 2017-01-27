
library(readr)
dis_sport <- read_csv("~/GYAMaps/dis-sport/dis_sport.csv", col_types = cols(incomedate = col_date(format = "%d/%m/%Y")))
View(dis_sport)


##or, if already loaded

dis_sport<- readRDS("dis_sport.rds")

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



dis_sport$category_1 <- as.factor(dis_sport$category_1)

dis_sport$category_2 <- as.factor(dis_sport$category_2)

dis_sport$category_3 <- as.factor(dis_sport$category_3)

dis_sport$category_4 <- as.factor(dis_sport$category_4)

dis_sport$disability <- as.factor(dis_sport$disability)

dis_sport$people_with_disabilities <- as.factor(dis_sport$people_with_disabilities)

dis_sport$amateur_sport <- as.factor(dis_sport$amateur_sport)

dis_sport$recreation <- as.factor(dis_sport$recreation)

dis_sport$any_disability <- as.factor(dis_sport$any_disability)

dis_sport$any_sport <- as.factor(dis_sport$any_sport)

dis_sport$both_cats <- as.factor(dis_sport$both_cats)

dis_sport$country <- as.factor(dis_sport$country)

dis_sport$main <- as.factor(dis_sport$main)

dis_sport$category_type <- as.factor(dis_sport$category_type)

dis_sport$district <- as.factor(dis_sport$district)



dis_sport$income_percentile <- NULL
dis_sport$category_type <- NULL

summary(dis_sport)

## Recoding dis_sport$category_type into dis_sport$category
dis_sport$category <- as.character(dis_sport$category_type)
dis_sport$category <- factor(dis_sport$category)


saveRDS(dis_sport, "./data/dis_sport.rds")

dis_sport$regno <- as.character(dis_sport$regno)

dis_sport$corr <- NULL

test <- paste0('<href=', dis_sport$web[270],'>')

dis_sport$web <- paste0("<a href='",dis_sport$web,"'>",dis_sport$web,"</a>")


dis_sport$web <- gsub("<a href='NA'>NA</a>", "", dis_sport$web)

GYA$web <- paste0("<a href='",GYA$web,"'>",GYA$web,"</a>")

saveRDS(GYA, "./data/GYA.rds")

library(shiny)
library(DT)
library(leaflet)

shinyServer(function(input, output, session) {
  
  dis_sport<- readRDS("dis_sport.rds")
  
  GYA <- readRDS("GYA.rds")
  
  GYA_Icon <- makeIcon("GYA.PNG",25,25)
  
  typeIcons <- iconList(
    Disability = makeIcon("disability.PNG", "disability.PNG",30,30),
    "Disability and Sport" = makeIcon("disSport.PNG", "disSport.PNG",30,30),
    Sport = makeIcon("sport.png", "sport.png",30,30)
  )
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -2.547855, lat = 54.00366, zoom = 5)%>%
      addMarkers(data=GYA, ~Longitude, ~Latitude,
                 icon=GYA_Icon,
                 popup=~as.character(paste("Get Yourself Active Partner", "<br>",
                                           "Name: ", GYA$name)),
                 
                 group="GYA")
  })
  
  getDataSet<-reactive({
    
    if (is.null(input$mymap_bounds))
      return(dis_sport[FALSE,])
    
    bounds <- input$mymap_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    dataSet<-dis_sport[dis_sport$category_type == input$category_input
                       & dis_sport$latitude >= latRng[1] 
                       & dis_sport$latitude <= latRng[2]
                       & dis_sport$longitude >= lngRng[1] 
                       & dis_sport$longitude <= lngRng[2]
                       #& dis_sport$income_percentile >= input$income_input[1]
                       #& dis_sport$income_percentile <= input$income_input[2]
                       ,]
    
  })
  
  output$ds_dt = renderDataTable(datatable({
    dataSet<-getDataSet()
    dataSet
    
  },filter = 'top',
  colnames = c('Registration Number'='regno',
               'Primary Charity' = 'main',
               'Name' ='name',
               'Area of Benefit' ='area_of_benefit',
               'District' ='district',
               'Region' ='region',
               'Address' ='address',
               'Phone' ='phone',
               'Web' ='web',
               'Any Disability'='any_disability',
               'Any Sport' ='any_sport',
               'Sport and Disability'='both_cats',
               'Disability' ='disability',
               'People with Disabilities'='people_with_disabilities',
               'Amateur Sport'='amateur_sport',          
               'Recreation' ='recreation',
               'Category' = 'category_type'),
  extensions = c('FixedHeader','Buttons'),
  
  options = list(
    lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),
    pageLength = 5, 
    fixedHeader = TRUE,
    server = TRUE, 
    autoWidth = FALSE,
    columnDefs = list(list(visible=FALSE, targets=list(1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,23,24,25,26,27,28,29,30,31,32,33,35,36))),
    dom = 'Blfrtip',
    buttons = c(list(list(extend = 'colvis', columns = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36),visible=FALSE)),
                list(list(extend = 'collection',
                          buttons = c('copy', 'print', 'csv', 'excel', 'pdf'),
                          text = 'Download Data'
                )))
  )))
  
  observe({
    
    dataSet<-getDataSet() 
    
    filteredData <- reactive({
      s2 = input$ds_dt_rows_all
      dataSet[s2, , drop = FALSE]
    })
    
    leafletProxy("mymap", data = filteredData()) %>%
      clearGroup(group="charities") %>%
      #removeMarkerCluster(layerId="charities") %>%
      addMarkers(~longitude, ~latitude,
                 icon = ~typeIcons[category_type],
                 popup=~as.character(paste("<strong>Name:</strong> ", name, "<br>",
                                           "<strong>Area of Focus:</strong> ", category_type, "<br>",
                                           "<br>",
                                           "<strong>Contact</strong>", "<br>",
                                           "Address: ", address,"<br>",
                                           "Phone: ", phone,"<br>",
                                           "Web: ", web)),
                 group="charities",
                 clusterOptions = markerClusterOptions())
  })
  
})


