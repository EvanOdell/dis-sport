
library(shiny)
library(DT)
library(leaflet)
library(readr)

shinyServer(function(input, output, session) {
  
  dis_sport<- readRDS("./data/dis_sport.rds")
  
  GYA <- readRDS("./data/GYA.rds")
  
  GYA_Icon <- makeIcon("./img/GYA.png","./img/GYA.png",25,25)
  
  typeIcons <- iconList(
    Disability = makeIcon("./img/disability.png", "./img/disability.png",30,30),
    "Disability and Sport" = makeIcon("./img/disSport.png", "./img/disSport.png",30,30),
    Sport = makeIcon("./img/sport.png", "./img/sport.png",30,30)
  )
  
  observeEvent(input$reset,{
    
    shinyjs::reset("myapp")
    leafletProxy("mymap") %>% 
      setView(lng = -2.547855, lat = 54.00366, zoom = 5)
    
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -2.547855, lat = 54.00366, zoom = 5)
    
  })
  
  getDataSet <- reactive({
    if (is.null(input$mymap_bounds))
      return(dis_sport[FALSE,])
      
    bounds <- input$mymap_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    if(input$show_main==TRUE)
      dis_sport <- subset(dis_sport, main=="TRUE")

    dataSet <- dis_sport[dis_sport$category %in% input$category_input
                         & dis_sport$latitude >= latRng[1] 
                         & dis_sport$latitude <= latRng[2]
                         & dis_sport$longitude >= lngRng[1] 
                         & dis_sport$longitude <= lngRng[2],]
                         #& dis_sport$income >= input$min_income
                         #& dis_sport$income <= input$max_income,]
  })
  
  output$ds_dt = renderDataTable(datatable({
      dataSet <- getDataSet()
      
      #dataSet
    
    },
    filter = 'top',
    colnames = c('Registration Number'= 'regno',
               'Primary Charity' = 'main',
               'Name' = 'name',
               'Area of Benefit' = 'area_of_benefit',
               'Charitable Object' = 'object',
               'District' = 'district',
               'Region' = 'region',
               'Address' = 'address',
               'Phone' = 'phone',
               'Website' = 'web',
               'Disability' = 'disability',
               'People with Disabilities'= 'people_with_disabilities',
               'Amateur Sport'= 'amateur_sport',          
               'Recreation' = 'recreation',
               'Category' = 'category',
               'Subsidiary Number'= 'subno',
               'Latitude'= 'latitude',
               'Longitude'= 'longitude'),
    
    extensions = c('FixedHeader','Buttons'),
    escape = FALSE,
    options = list(
      lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),
      order = list(2, 'asc'),
      pageLength = 5, 
      fixedHeader = TRUE,
      server = TRUE, 
      autoWidth = FALSE,
      columnDefs = list(list(visible=FALSE, targets=list(0,5,6,7,8,9,10,
                                                        11,12,13,14,15,16,
                                                        17))),
      dom = 'Blfrtip',
      buttons = c(list(list(extend = 'colvis', columns = c(1,2,3,4,5,6,7,8,
                                                         9,10,11,12,13,14,
                                                         15,16,17),visible=FALSE))
    ))))
  
  observe({
    proxy <- leafletProxy("mymap", data = GYA)
    if (input$show_penguins==TRUE) {
      proxy %>% addMarkers(data = GYA, ~Longitude, ~Latitude,
                           icon=GYA_Icon,
                           popup=~as.character(paste("<strong>Get Yourself Active Partner</strong>", "<br>",
                                                     "Name: ", GYA$name, "<br>",
                                                     "<br>",
                                                     "<strong>Contact</strong>", "<br>",
                                                     "Address: ", address,"<br>",
                                                     "Phone: ", phone,"<br>",
                                                     "Website: ", web)),
                           group="GYA")
    } else {
      
      proxy %>% clearGroup(group="GYA")
    
      }
    
  })
  
  observe({
    
    dataSet<-getDataSet() 
    
    filteredData <- reactive({
      
      s2 <- input$ds_dt_rows_all
      
      dataSet[s2, , drop = FALSE]
    
      })
    
    leafletProxy("mymap", data = filteredData()) %>%
      clearGroup(group="charities") %>%
      #removeMarkerCluster(layerId="charities") %>%
      addMarkers(~longitude, ~latitude,
                 icon = ~typeIcons[category],
                 popup=~as.character(paste("<strong>Name:</strong> ", name, "<br>",
                                           "<strong>Area of Focus:</strong> ", category, "<br>",
                                           "<br>",
                                           "<strong>Contact</strong>", "<br>",
                                           "Address: ", address,"<br>",
                                           "Phone: ", phone,"<br>",
                                           "Website: ", web)),
                 group="charities",
                 clusterOptions = markerClusterOptions())
    
    
    

    output$download_data = downloadHandler(paste0('disability_sport_', Sys.Date(),".csv"), content = function(file) {
      
      s2 <- input$ds_dt_rows_all
      
      dataSet$web <- gsub("<a href= '", "", dataSet$web)
      
      dataSet$web <- gsub("'>.*", "", dataSet$web)
      
      #dataSet$web <- gsub("</a>*", "", dataSet$web)
      
      write_csv(dataSet[s2, , drop = FALSE], file)
      
    })
    
    
  })
  
})
