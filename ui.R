
library(shiny)
library(DT)
library(leaflet)
library(shinydashboard)

header<-dashboardHeader(title='Disability Sport Charities')

body<-dashboardBody(
  fluidRow(
    column(width = 8,offset = 1,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap")
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
      ),
      box(width=NULL, 
          sliderInput("income_input",
                             "Income Percentile",min=0,max=100,
                      value = c(50,60), step=1)
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
