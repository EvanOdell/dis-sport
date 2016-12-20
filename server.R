
library(shiny)
library(DT)
library(leaflet)

shinyServer(function(input, output, session) {
  
  dis_sport<- readRDS("dis_sport.rds")
  
  GYA <- readRDS("GYA.rds")
  
  GYA_Icon <- makeIcon("./GYA.PNG","./GYA.PNG",25,25)
  
  typeIcons <- iconList(
    Disability = makeIcon("./disability.PNG", "./disability.PNG",30,30),
    "Disability and Sport" = makeIcon("./disSport.PNG", "./disSport.PNG",30,30),
    Sport = makeIcon("./sport.png", "./sport.png",30,30)
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
    
    dataSet<-dis_sport[dis_sport$category == input$category_input
                        & dis_sport$latitude >= latRng[1] 
                        & dis_sport$latitude <= latRng[2]
                        & dis_sport$longitude >= lngRng[1] 
                        & dis_sport$longitude <= lngRng[2]
                        & dis_sport$income_percentile >= input$income_input[1]
                        & dis_sport$income_percentile <= input$income_input[2],]

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
                     'Category' = 'category'),
      extensions = c('FixedHeader','Buttons'),
      
      options = list(
        lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),
        pageLength = 5, 
        fixedHeader = TRUE,
        server = TRUE, 
        autoWidth = FALSE,
        columnDefs = list(list(visible=FALSE, targets=list(1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,23,24,25,26,27,28,29,30,31,32,33,35))),
        dom = 'Blfrtip',
        buttons = c(list(list(extend = 'colvis', columns = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35),visible=FALSE)),
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
                       icon = ~typeIcons[category],
                 popup=~as.character(paste("<strong>Name:</strong> ", name, "<br>",
                                           "<strong>Area of Focus:</strong> ", category, "<br>",
                                           "<br>",
                                           "<strong>Contact</strong>", "<br>",
                                           "Address: ", address,"<br>",
                                           "Phone: ", phone,"<br>",
                                           "Web: ", web)),
                 group="charities",
                 clusterOptions = markerClusterOptions())
  })
  
})
