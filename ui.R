

library(shiny)
library(DT)
library(shinyjs)
library(leaflet)
library(shinydashboard)


header<-dashboardHeader(title='Disability Sport Charities')

# Define UI for application that draws a histogram


body<-dashboardBody(
  fluidRow(
    column(width = 10,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("ds_dt")
           )
    ),
    column(width=2,
           box(width=NULL,
               radioButtons("category_input",
                            "Category",c("Disability"="Disability",
                                         "Sport" = "Sport",
                                         "Disability and Sport"="Disability and Sport"))
               ))
radioButtons()
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  skin = "purple",
  body
)
