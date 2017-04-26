
library(shiny)


shinyUI(navbarPage(
  
  ##link to css.file
  theme = "bootstrap2.css",
  
  ##Project Title
  "Movie Inside You",
  
  tabPanel("Home",
           htmlOutput("blankspace"),
           titlePanel("Adeventure in Movies"),
           h4(htmlOutput("text")),
           htmlOutput("teammates")
  ),
  
  
  ## 3D Globe tab
  tabPanel("Mannual",
           titlePanel("How to use the Application"),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 60, right = "auto", bottom = "auto",
                         width = 350, height = "auto",
                         
                         h2("Explorer"),
                         verbatimTextOutput('out6'),
                         selectInput('in6', 'Search', state.name, multiple=TRUE, selectize=TRUE)
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                          draggable = TRUE, 
                          top = 180, left = 460, right = "auto", bottom = "auto",
                          width = 350, height = "auto",
             h2("Just Try Them"),
             imageOutput("wordcloud1",width="100%",height="250px"),
             imageOutput("wordcloud2",width="100%",height="250px"),
             imageOutput("wordcloud3",width="100%",height="250px"),
             imageOutput("wordcloud4",width="100%",height="250px")
             ),
           
           
           
           globeOutput("Globe",width="100%",height="650px")),
  
  tabPanel("Recommend Me",
           titlePanel("Coffee ,tea, and others traded between US and the world"),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 60, right = "auto", bottom = "auto",
                         width = 350, height = "auto",
                         
                         h2("3D Explorer"),
                         
                         radioButtons(inputId = "type",
                                      label  = "Choose import/export",
                                      choices = c('Export','Import'),
                                      selected ='Import'),
                         sliderInput(inputId = "year_3D",
                                     label = "Select a year",
                                     value = 1996, min =1996, max =2016),
                         sliderInput(inputId = "number_countries",
                                     label = "Top Countries in Trade",
                                     value = 10,min = 1,max = 50),
                         selectInput(inputId = "commodity_3D",
                                     label  = "Select the commodity",
                                     choices = c('Annual Aggregate','Chocolate', 'Coffee','Cocoa','Spices','Tea'),
                                     selected ='Coffee')
           ),
           
           
           
           globeOutput("Globe",width="100%",height="650px")),
  
  
  
  tabPanel("I'm feeling Lucky!",
           titlePanel("Coffee ,tea, and others traded between US and the world"),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 60, right = "auto", bottom = "auto",
                         width = 350, height = "auto",
                         
                         h2("3D Explorer"),
                         
                         radioButtons(inputId = "type",
                                      label  = "Choose import/export",
                                      choices = c('Export','Import'),
                                      selected ='Import'),
                         sliderInput(inputId = "year_3D",
                                     label = "Select a year",
                                     value = 1996, min =1996, max =2016),
                         sliderInput(inputId = "number_countries",
                                     label = "Top Countries in Trade",
                                     value = 10,min = 1,max = 50),
                         selectInput(inputId = "commodity_3D",
                                     label  = "Select the commodity",
                                     choices = c('Annual Aggregate','Chocolate', 'Coffee','Cocoa','Spices','Tea'),
                                     selected ='Coffee')
           ),
           
           
           
           globeOutput("Globe",width="100%",height="650px")),
  tabPanel("To be continued",
           titlePanel("Coffee ,tea, and others traded between US and the world"),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 60, right = "auto", bottom = "auto",
                         width = 350, height = "auto",
                         
                         h2("3D Explorer"),
                         
                         radioButtons(inputId = "type",
                                      label  = "Choose import/export",
                                      choices = c('Export','Import'),
                                      selected ='Import'),
                         sliderInput(inputId = "year_3D",
                                     label = "Select a year",
                                     value = 1996, min =1996, max =2016),
                         sliderInput(inputId = "number_countries",
                                     label = "Top Countries in Trade",
                                     value = 10,min = 1,max = 50),
                         selectInput(inputId = "commodity_3D",
                                     label  = "Select the commodity",
                                     choices = c('Annual Aggregate','Chocolate', 'Coffee','Cocoa','Spices','Tea'),
                                     selected ='Coffee')
           ),
           
           
           
           globeOutput("Globe",width="100%",height="650px"))))