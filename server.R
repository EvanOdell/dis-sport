
library(shiny)
library(DT)
library(leaflet)
library(readr)

shinyServer(function(input, output, session) {
  
  dis_sport<- readRDS("./data/dis_sport.rds")
  
  GYA <- readRDS("./data/GYA.rds")
  
  GYA_Icon <- makeIcon("./images/GYA.png","./images/GYA.png",25,25)

  typeIcons <- iconList(
    Disability = makeIcon("./images/disability.png", "./images/disability.png",30,30),
    "Disability and Sport" = makeIcon("./images/disSport.png", "./images/disSport.png",30,30),
    Sport = makeIcon("./images/sport.png", "./images/sport.png",30,30)
  )
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -2.547855, lat = 54.00366, zoom = 5)
    
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
                        #& dis_sport$income_percentile >= input$income_input[1]
                        #& dis_sport$income_percentile <= input$income_input[2],
                        & dis_sport$income >= input$min_income
                        & dis_sport$income <= input$max_income,]
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
                   'Website' ='web',
                   'Any Disability'='any_disability',
                   'Any Sport' ='any_sport',
                   'Sport and Disability'='both_cats',
                   'Disability' ='disability',
                   'People with Disabilities'='people_with_disabilities',
                   'Amateur Sport'='amateur_sport',          
                   'Recreation' ='recreation',
                   'Category' = 'category',
                   'Postcode' = 'postcode',
                   'Subsidiary Number'='subno',
                   'Governing Documents'='governing_documents',
                   'Charitable Object'='object',
                   'Category 1'='category_1',
                   'Category 2'='category_2',
                   'Category 3'='category_3',
                   'Category 4'='category_4',
                   'Income'='income',
                   'Income Reporting Date'='incomedate',
                   'Latitude'='latitude',
                   'Longitude'='longitude',
                   'Constituency'='constituency',
                   'Country'='country',
                   'County'='county'),
      extensions = c('FixedHeader','Buttons'),
      escape = FALSE,
      options = list(
        lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),
        pageLength = 5, 
        fixedHeader = TRUE,
        server = TRUE, 
        autoWidth = FALSE,
        columnDefs = list(list(visible=FALSE, targets=list(1,3,4,6,7,8,9,10,
                                                           11,12,13,14,15,16,
                                                           17,18,19,20,22,23,
                                                           24,25,26,27,28,29,
                                                           30,31))),
        dom = 'Blfrtip',
        buttons = c(list(list(extend = 'colvis', columns = c(1,2,3,4,5,6,7,8,
                                                             9,10,11,12,13,14,
                                                             15,16,17,18,19,20,
                                                             21,22,23,24,25,26,
                                                             27,28,29,30,31,32),visible=FALSE))#,
                    #list(list(extend = 'collection',
                              #buttons = list(list(extend='csv',
                                                  #filename = 'disability_sport'),
                                             #list(extend='excel',
                                                  #filename = 'disability_sport'),
                                             #list(extend='pdf',
                                                  #filename= 'disability_sport')),
                              #text = 'Download Data',
                              #scrollX = TRUE,
                              #order=list(list(2,'desc'))))
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
                                           "Website: ", web)),
                 group="charities",
                 clusterOptions = markerClusterOptions())
  
  output$downloadData <- downloadHandler(
    filename = function() { paste('disability_sport', Sys.Date(), '.csv', sep='') },
    content = function(file) {
      write_csv(filteredData(), file)
    }
  )
  }) 
  
})
