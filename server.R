
library(shiny)
library(DT)
library(leaflet)
library(shinyjs)


shinyServer(function(input, output, session) {
  
  dis_sport<- readRDS("dis_sport.rds")
  
  GYA <- readRDS("GYA.rds")
  
  GYA_Icon <- makeIcon("GYA.png",25,25)
  
  dis_sport2 = dis_sport[, c('regno',
                             'main',
                             'name',
                             'area_of_benefit',
                             'district',
                             'region',
                             'address',
                             'phone',
                             'web',
                             'longitude',
                             'latitude',
                             'any_disability',
                             'any_sport',
                             'both_cats',
                             'disability',
                             'people_with_disabilities',
                             'amateur_sport',      
                             'recreation',
                             'category_1',
                             'category_2',
                             'category_3',
                             'category_4',
                             'category_type')]
  
  output$ds_dt = renderDataTable(
    datatable(
      dis_sport2, 
      filter = 'top',
      extensions = c('FixedHeader','Buttons'),
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
                   'Recreation' ='recreation'),
      
      options = list(
        lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),
        pageLength = 5, 
        fixedHeader = TRUE,
        server = TRUE, 
        autoWidth = TRUE,
        columnDefs = list(list(visible=FALSE, targets=list(10,11,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23))),
        dom = 'Blfrtip',
        buttons = c(list(list(extend = 'colvis', columns = c(4,5,6,7,8,9,15,16,17,18),visible=FALSE)),
                    list(list(extend = 'collection',
                              buttons = c('copy', 'print', 'csv', 'excel', 'pdf'),
                              text = 'Download Data'
                    )))
      )))
  
  
  
  filteredData <- reactive({
    s2 = input$ds_dt_rows_all
    dis_sport2[s2, , drop = FALSE]
  })
  
  
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -2.547855, lat = 54.00366, zoom = 5)%>%
      addMarkers(data=GYA, ~Longitude, ~Latitude,
                 popup=~as.character(paste("Get Yourself Active Partner", "<br>",
                                           "Name: ", GYA$name)),
                 icon=GYA_Icon,
                 group="GYA")
  })
  
  observe({
    leafletProxy("mymap", data = filteredData()) %>%
      clearGroup(group="charities") %>%
      #removeMarkerCluster(layerId="charities") %>%
      addMarkers(~longitude, ~latitude,
                 popup=~as.character(paste("Name: ", name, "<br>",
                                           "Area of Focus 1: ", category_1,"<br>",
                                           "Area of Focus 2: ",category_2, "<br>",
                                           "Area of Focus 3: ",category_3, "<br>",
                                           "Area of Focus 4: ",category_4)),
                 group="charities",
                 clusterOptions = markerClusterOptions())
  })
  
  
})
