#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(leaflet)
library(shiny)

# Define UI for application that analyzes crash data
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Analyze Crash Data in Cambridge, MA"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
        h4("Select a type of vehicle to analyze."),
       selectInput("type1",
                   "Type of Vehicle:",
                   c("Car","Truck","Van/SUV","Taxi","Other")),
       submitButton("Submit")
    ),
    
    # Show data
    mainPanel(
            h5("Overview: This is using data from the city of Cambridge, MA. 
               List of crashes involving motor vehicles, bicycles and/or pedestrians 
               reported in the City of Cambridge from January 2010 through June 2016."), 
            h5("URL: https://data.cambridgema.gov/Public-Safety/Police-Department-Crash-Data-Historical/ybny-g9cv."),
            tabsetPanel(type = "tabs", 
                        tabPanel("Maps", br(), 
                                 h3("Map of Crashes for ALL Vehicle Types"),
                                 leafletOutput("map1"),
                                 h3("Map of Crashes for SELECTED Vehicle Type"),
                                 leafletOutput("map2")
                                 ),
                        tabPanel("Graphs",br(),
                                 h3("Graph of Crashes for ALL Vehicle Types"),
                                 plotOutput("plotA"),
                                 h3("Graph of Crashes for SELECTED Vehicle Type"),
                                 plotOutput("plotB")
                                 )
                        )       
        
    )
  )
))
