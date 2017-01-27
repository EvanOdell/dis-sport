
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
           ),
          includeMarkdown("./assets/summary.Rmd")
    ),
    column(width=2,
           box(width=NULL, 
               checkboxGroupInput("category_input",
                            "Category",c("Disability and Sport"="Disability and Sport",
                                         "Disability"="Disability",
                                         "Sport"="Sport"),
                            selected = "Disability and Sport")),
           box(width=NULL,
               checkboxInput("show_penguins",
                             "Show Get Yourself Active Partners",
                             value = TRUE)),
           
      box(width=NULL, 
          #sliderInput("income_input",
          #                   "Income Percentile",min=0,max=100,
          #            value = c(50,60), step=1),
          numericInput("min_income", "Minimum Income:", 0, min = 0, max = 767600000),
          numericInput("max_income", "Maximum Income:", 767600000, min = 0, max = 767600000)),
          #sliderInput("min_income", "Maximum Income:", 500000, min = 0,
          #            max = 767600000,pre = "£", sep = ","),
          #sliderInput("max_income", "Maximum Income:", 600000, min = 0,
          #            max = 767600000,pre = "£", sep = ",")),
      
      box(width=NULL, 
          downloadButton('downloadData',
                         'Download CSV File'))
      )
   )
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  skin = "purple",
  body
)
