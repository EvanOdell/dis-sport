#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(readr)

header <- dashboardHeader(title='Disability Sport Charities Map',
                             titleWidth = 350)

shinyjs::useShinyjs()
tags$head(
  tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
)

body <- dashboardBody(
  h3(strong(a(icon("futbol-o"),"Return to getyourselfactive.org", href="http://getyourselfactive.org"))),
  h3(strong(a(icon("table"),"Check out this data as a table", href="https://disabilityrightsuk.shinyapps.io/dis-sport-table/"))),
  #h4(strong(a(icon("home"),"Return to evanodell.com", href="http://shiny.evanodell.com/"))),
  fluidRow(column(width = 8,offset = 1,
                  box(
                    width = NULL, solidHeader = TRUE,
                    leafletOutput("mymap")
                  ),
                  box(width=NULL,
                      dataTableOutput("ds_dt")
                  ),
               includeMarkdown("./assets/summary.Rmd")),
        column(width=2,
               box(width=NULL, 
                   checkboxGroupInput("category_input",
                                      "Category",c("Disability and Sport"='Disability and Sport',
                                                   "Just Disability"="Disability",
                                                   "Just Sport"="Sport"),
                                      selected = "Disability and Sport")),
               box(width=NULL, h5("Options"),
                   checkboxInput("show_penguins",
                                 "Show Get Yourself Active Partners",
                                 value = FALSE),
                   checkboxInput("map_style",
                                 "Use High Contrast Map",
                                 value = FALSE)),
               box(width=NULL, 
                   downloadButton('download_data',
                                  'Download Table')),
               
               
               box(width=NULL,
                   actionButton("reset", "Reset Search"))
        )
    )
  )

# Run the application 
shinyApp(
  ui = dashboardPage(
    header,
    dashboardSidebar(disable = TRUE),
    skin = "green",
    body
  ),

server <- function(input, output, session) {
    
    dis_sport<- read_rds("./data/dis_sport.rds")
    
    GYA <- read_rds("./data/GYA.rds")
    
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
        setView(lng = -2.547855, lat = 54.00366, zoom = 5)
      
    })
    
    getDataSet <- reactive({
      
      if (is.null(input$mymap_bounds))
        return(dis_sport[FALSE,])
      
      bounds <- input$mymap_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(dis_sport, category %in% input$category_input & 
               latitude >= latRng[1] & latitude <= latRng[2] &
               longitude >= lngRng[1] & longitude <= lngRng[2])
      
    })
    
    output$ds_dt = renderDataTable(datatable({
      dataSet <- getDataSet()
      
    },
    filter = 'top',
    colnames = c('Name' = 'name',
                 'Charitable Object' = 'object',
                 'Local Authority' = 'district',
                 'Region' = 'region',
                 'Address' = 'address',
                 'Phone' = 'phone',
                 'Website' = 'web',
                 'Category' = 'category',
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
      columnDefs = list(list(visible=FALSE, targets=list(0,2,3,4,5,6,7))),
      dom = 'Blfrtip',
      buttons = c(list(list(extend = 'colvis', columns = c(1,2,3,4,5,6,7,8,9,10),visible=FALSE))
      ))))
    
    
    observe({
      
      dataSet<-getDataSet() 
      
      filteredData <- reactive({
        
        s2 <- input$ds_dt_rows_all
        
        dataSet[s2, , drop = FALSE]
        
      })
      
      if(input$map_style==TRUE){
        provider <- providers$Stamen.Toner
      } else {
        provider <- providers$Esri.WorldStreetMap
      }
      
      if(nrow(filteredData())==0) { leafletProxy("mymap") %>% clearShapes()} 
      
      else {
        
        leafletProxy("mymap", data = filteredData()) %>%
          clearGroup(group="charities") %>% addProviderTiles(provider) %>%
          addMarkers(~longitude, 
                     ~latitude,
                     icon = ~typeIcons[category],
                     popup=~as.character(paste("<strong>Name:</strong> ", name, "<br>",
                                               "<strong>Area of Focus:</strong> ", category, "<br>",
                                               "<br>",
                                               "<strong>Contact</strong>", "<br>",
                                               "<em>Address:</em> ", address,"<br>",
                                               "<em>Phone:</em> ", phone,"<br>",
                                               "<em>Website:</em> ", web)),
                     group="charities",
                     clusterOptions = markerClusterOptions())
        
        if (input$show_penguins==TRUE) {
          leafletProxy("mymap", data = GYA) %>%
            addMarkers(~longitude, 
                       ~latitude, 
                       icon=GYA_Icon,
                       popup=~as.character(paste("<strong>Get Yourself Active Partner</strong>", "<br>",
                                                 "Name: ", GYA$name, "<br>",
                                                 "<br>",
                                                 "<strong>Contact</strong>", "<br>",
                                                 "<em>Address:</em> ", address,"<br>",
                                                 "<em>Phone:</em> ", phone,"<br>",
                                                 "<em>Website:</em> ", web)),
                       group="GYA")
        } else {
          
          leafletProxy("mymap") %>% clearGroup(group="GYA")
          
        }
        
      }
      
      output$download_data = downloadHandler(paste0('disability_sport_', Sys.Date(),".csv"), content = function(file) {
        
        s2 <- input$ds_dt_rows_all
        
        dataSet$web <- gsub("<a href= '", "", dataSet$web)
        
        dataSet$web <- gsub("'>.*", "", dataSet$web)
        
        #dataSet$web <- gsub("</a>*", "", dataSet$web)
        
        write_csv(dataSet[s2, , drop = FALSE], file)
        
      })
      
      
    })
    
  })
  
