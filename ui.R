library(shiny)
library(DT)
library(shinyjs)
library(leaflet)


shinyUI(fluidPage(
  useShinyjs(),
  
  title = 'Disability Sport Charities',
  
  actionButton("hideshow", "Hide/show table"),
  
  fluidRow(
    column(10,offset = 1, 
        leafletOutput("mymap")
    )
  ),
  

  fluidRow(
    column(10,offset = 1, DT::dataTableOutput('ds_dt'))
  )
  
))
