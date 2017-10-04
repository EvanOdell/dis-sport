
## dis-sport-data-table

library(shiny)
library(shinydashboard)
library(DT)
library(readr)


header <- dashboardHeader(title='Disability Sport Charities Table',
                          titleWidth = 350)

shinyjs::useShinyjs()
tags$head(
  tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
)

body <- dashboardBody(
  h3(strong(a(icon("futbol-o"),"Return to getyourselfactive.org", href="http://getyourselfactive.org"))),
  h3(strong(a(icon("map-o"),"Check out this data as a map", href="https://disabilityrightsuk.shinyapps.io/dis-sport/"))),
  #h4(strong(a(icon("home"),"Return to evanodell.com", href="http://shiny.evanodell.com/"))),
  fluidRow(column(width = 8,offset = 2,
                  box(width=NULL,
                      dataTableOutput("ds_dt")
                  ),
                  box(width=NULL, 
                      downloadButton('download_data',
                                     'Download Table')),
                  includeMarkdown("./assets/summary.Rmd"))
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
    
    dis_sport<- read_rds("./data/dis_sport_table.rds")
    
  
    output$ds_dt = renderDataTable(datatable({
      dataSet <- dis_sport
      
    },
    filter = 'top',
    colnames = c('Name' = 'name',
                 'Charitable Object' = 'object',
                 'Local Authority' = 'district',
                 'Region' = 'region',
                 'Address' = 'address',
                 'Phone' = 'phone',
                 'Website' = 'web',
                 'Category' = 'category'),
    
    extensions = c('FixedHeader','Buttons'),
    escape = FALSE,
    options = list(
      autoWidth=FALSE,
      lengthMenu = list(c(10, 25, 50, -1), c('10', '25', '50', 'All')),
      order = list(2, 'asc'),
      pageLength = 10, 
      fixedHeader = TRUE,
      server = TRUE, 
      autoWidth = FALSE,
      columnDefs = list(list(visible=FALSE, targets=list(0,2,7,8),width = '200px', targets = 7)),
      dom = 'Blfrtip',
      buttons = c(list(list(extend = 'colvis', columns = c(1,2,3,4,5,6,7,8),visible=FALSE))
      ))))
    
      output$download_data = downloadHandler(paste0('disability_sport_', Sys.Date(),".csv"), content = function(file) {
        
        s2 <- input$ds_dt_rows_all
        
        dataSet$web <- gsub("<a href= '", "", dataSet$web)
        
        dataSet$web <- gsub("'>.*", "", dataSet$web)
        
        #dataSet$web <- gsub("</a>*", "", dataSet$web)
        
        write_csv(dataSet[s2, , drop = FALSE], file)
        
      })
      
      
})
    

