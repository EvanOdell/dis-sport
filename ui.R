
library(shiny)
library(DT)
library(leaflet)
library(shinydashboard)

header <- dashboardHeader(title='Disability Sport Charities',
                        titleWidth = 350)

body <- dashboardBody(
  shinyjs::useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  h4(a(icon("futbol-o"),"Return to getyourselfactive.org", href="http://getyourselfactive.org")),
  h5(a(icon("home"),"Return to evanodell.com", href="http://shiny.evanodell.com/")),
  fluidRow(
  div(id="myapp",

    column(width = 8,offset = 1,
           box(
             width = NULL, solidHeader = TRUE,
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
                            "Category",c("Disability and Sport"='Disability and Sport',
                                         "Disability"="Disability",
                                         "Sport"="Sport"),
                            selected = "Disability and Sport")),
           box(width=NULL, h5("Options"),
               checkboxInput("show_penguins",
                             "Show Get Yourself Active Partners",
                             value = FALSE),
               checkboxInput("show_main",
                             "Show Primary Charities Only",
                             value = FALSE)),
           
      #box(width=NULL, 
          #sliderInput("income_input",
          #                   "Income Percentile",min=0,max=100,
          #            value = c(50,60), step=1),
      #    numericInput("min_income", "Minimum Income:", 0, min = 0, max = 767600000),
      #    numericInput("max_income", "Maximum Income:", 767600000, min = 0, max = 767600000)),
          #sliderInput("min_income", "Maximum Income:", 500000, min = 0,
          #            max = 767600000,pre = "£", sep = ","),
          #sliderInput("max_income", "Maximum Income:", 600000, min = 0,
          #            max = 767600000,pre = "£", sep = ",")),
      
      box(width=NULL, 
          downloadButton('download_data',
                         'Download Table')),

      
      box(width=NULL,
          actionButton("reset", "Reset Search"))
          )
    )
  )
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  skin = "green",
  body
)
