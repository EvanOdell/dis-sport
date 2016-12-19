

library(shiny)
library(DT)
library(shinyjs)
library(leaflet)
library(shinydashboard)


header<-dashboardHeader(title='Disability Sport Charities')

body<-dashboardBody(
  fluidRow(

    column(width = 10,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("ds_dt")
           )
    )),


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  skin = "purple",
  body
)
)