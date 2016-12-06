#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(shinyjs)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  useShinyjs(),
  
  title = 'Disability Sport Charities',
  
  actionButton("hideshow", "Hide/show table"),
  
  fluidRow(
        leafletOutput("mymap")
  ),
  

  fluidRow(
    column(10,offset = 1, DT::dataTableOutput('ds_dt'))
  )
  
))
