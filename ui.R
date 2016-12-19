<<<<<<< HEAD

=======
>>>>>>> 6ded0d627f9630d8840e277911a4223aafbe9f6d

library(shiny)
library(DT)
library(shinyjs)
library(leaflet)
library(shinydashboard)

<<<<<<< HEAD
=======
shinyUI(fluidPage(
  useShinyjs(),
  
  title = 'Disability Sport Charities',
  
  actionButton("hideshow", "Hide/show table"),
  
  fluidRow(
    column(10,offset = 1, 
        leafletOutput("mymap")
    )
  ),
  
>>>>>>> 6ded0d627f9630d8840e277911a4223aafbe9f6d

header<-dashboardHeader(title='Disability Sport Charities')

body<-dashboardBody(
  fluidRow(
    
    column(width = 10, offset=1,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("ds_dt")
           )
    )))


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  skin = "purple",
  body
)
