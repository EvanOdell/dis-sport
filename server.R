#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



library(shiny)
library(DT)
library(leaflet)
library(shinyjs)



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
 
  dis_sport<- readRDS("dis_sport.rds")
  
  GYA <- readRDS("GYA.rds")
  
  GYA_Icon <- makeIcon("GYA.png",25,25)
  
  dis_sport2 = dis_sport[, c('regno','name','area_of_benefit',
                             'District', 'address','phone',
                             'web','Longitude','Latitude')]
  
  # render the table (with row names)
  output$ds_dt = DT::renderDataTable(
    DT::datatable(
      dis_sport2, options = list(
        lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),
        pageLength = 5, server = TRUE, filter = 'top')))
  
  observeEvent(input$hideshow, {
    # every time the button is pressed, alternate between hiding and showing the plot
    toggle("ds_dt")
  })
  
  filteredData <- reactive({
    s2 = input$ds_dt_rows_all
    dis_sport2[s2, , drop = FALSE]
  })

  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -2.547855, lat = 54.00366, zoom = 5)%>%
      addMarkers(data=GYA, ~Longitude, ~Latitude,
                 popup=~as.character(paste("Type:", GYA$type, "<br>",
                                           "Name:", GYA$name)),
                 icon=GYA_Icon,
                 group="GYA")
  })
  
  observe({
    
    leafletProxy("mymap", data = filteredData()) %>%
      clearGroup(group="charities") %>%
      #removeMarkerCluster(layerId="charities") %>%
      addMarkers(~Longitude, ~Latitude,
                 popup=~as.character(name),
                 group="charities",
                 clusterOptions = markerClusterOptions())
  })
  

})
