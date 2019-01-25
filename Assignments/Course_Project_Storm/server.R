#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(dplyr)
library(tidyr)
library(lubridate)
library(leaflet)
library(shiny)

# Define server logic required to analyze crash data
shinyServer(function(input, output) {
        # load the data
        crash <- read.csv(url("https://data.cambridgema.gov/api/views/ybny-g9cv/rows.csv?accessType=DOWNLOAD"))
        
        colnames(crash) <- c("number","date_time","day_of_week","object1","object2",
                             "street_number","street_name","cross_street","Location",
                             "lat","lng","coordinate")
        crash <- crash[!is.na(crash$lat),]
        crash <- crash[!is.na(crash$lng),]
        
        crash$day <- mdy_hms(crash$date_time)
        
        crash$year <- year(crash$day)
        
        crash$type <- ifelse(crash$object1 %in% c('Auto','PASSENGER CAR')
                             ,'Car',
                             ifelse(crash$object1 %in% c('LIGHT TRUCK(VAN, MINI VAN, PICK-UP, SPORT UTILITY)')
                                    ,'Van/SUV',
                                    ifelse(crash$object1 %in% c('Truck')
                                           ,'Truck',
                                           ifelse(crash$object1 %in% c('Taxi')
                                                  ,'Taxi','Other'))))
        crash$popup = paste("Type: ",crash$type,"; Year: ", 
                            crash$year,"; Day of Week: ", crash$day_of_week)
        
        
        new <- crash %>%
                group_by(year, day, type, day_of_week) %>%
                summarize(count=n())
        
        
      #create maps  
  output$map1 <- renderLeaflet({
    
    
          crash %>%
                  leaflet() %>% 
                  addTiles() %>%
                  addMarkers(lat=crash$lat, lng=crash$lng, popup= crash$popup, 
                             clusterOptions = markerClusterOptions())
    
  })
  output$map2 <- renderLeaflet({
          
        
          crash2 <- crash[which(crash$type == input$type1),]
          crash2 %>%
                  leaflet() %>% 
                  addTiles() %>%
                  addMarkers(lat=crash2$lat, lng=crash2$lng, popup= crash2$popup, 
                             clusterOptions = markerClusterOptions())
          
  })
  #create plots
  output$plotA <- renderPlot({
          
          counts <-table(new$year)
          barplot(counts, main="Distribution of All Crashes across Years",
                  xlab="Year")
          
  })
  output$plotB <- renderPlot({
          
          new2 <- new[which(new$type == input$type1),]
          counts2 <-table(new2$year)
          barplot(counts2, main="Distribution for Selection across Years",
                   xlab="Year")
          
  })
  
})
