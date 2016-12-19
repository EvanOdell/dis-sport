

library(shiny)
library(DT)
library(shinyjs)
library(leaflet)
library(shinydashboard)


header<-dashboardHeader(title='Disability Sport Charities')

body<-dashboardBody(
  fluidRow(
    column(width = 8,offset = 1,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("ds_dt")
           )
    ),
    column(width=2,
           box(width=NULL, 
               checkboxGroupInput("category_input",
                            "Category",c("Disability and Sport"="Disability and Sport",
                                         "Disability"="Disability",
                                         "Sport"="Sport"),
                            selected = "Disability and Sport")
               
           )
    )
  )
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  skin = "purple",
  body
)
