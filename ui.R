

library(shiny)
library(DT)
library(shinyjs)
library(leaflet)
library(shinydashboard)


header<-dashboardHeader(title='Disability Sport Charities')

# Define UI for application that draws a histogram
<<<<<<< HEAD
=======
shinyUI(fluidPage(
  useShinyjs(),
  
  title = 'Disability Sport Charities',
  
  actionButton("hideshow", "Hide/show table"),
  
  fluidRow(
    column(10, offset=1,
           leafletOutput("mymap")
    ),
>>>>>>> 33528648879b6c3a7a6d00ffd83775aee2771811


body<-dashboardBody(
  fluidRow(
<<<<<<< HEAD
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
=======
    column(10, offset=1, 
           DT::dataTableOutput('ds_dt'))
  )
  )
  
))
>>>>>>> 33528648879b6c3a7a6d00ffd83775aee2771811
