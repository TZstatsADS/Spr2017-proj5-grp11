library(shiny)

setwd("../data")

#load data
input_data =  read.csv("data_clean.csv",header = T,as.is = T)
input_data = input_data[,-1]

shinyUI(navbarPage(
  
  ##link to css.file
  theme = "bootstrap2.css",
  
  ##Project Title
  "Movie Inside You",
  
  tabPanel("Home",
           htmlOutput("blankspace"),
           titlePanel("Adventure in Movies"),
           h4(htmlOutput("text")),
           htmlOutput("teammates")
  ),
  
  tabPanel("Recommend me!",
           titlePanel("Movie Recommendation"),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 60, right = "auto", bottom = "auto",
                         width = 350, height = "auto",
                         
                         h2("Key in one of your favourite movie and we will recommend you one back!"),
                         hr(),
                         verbatimTextOutput('out6'),
                         selectInput('movienames', 'My Movie Choice:', input_data$movie_title, selected="Spectre", multiple=F, selectize=T)
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 460, right = "auto", bottom = "auto",
                         width = 350, height = 350,
                         h2("Movie Rec 1!"),
                         #dataTableOutput("try"),
                         imageOutput("wordcloud1",width="250px",height="250px")
                         #imageOutput("wordcloud2",width="100%",height="250px"),
                         #imageOutput("wordcloud3",width="100%",height="250px"),
                         #imageOutput("wordcloud4",width="100%",height="250px")
           ),
           
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 800, right = "auto", bottom = "auto",
                         width = 350, height = 350,
                         h2("Movie Rec 2!"),
                         #dataTableOutput("try"),
                         #imageOutput("wordcloud1",width="250px",height="250px")
                         imageOutput("wordcloud2",width="100%",height="250px")
                         #imageOutput("wordcloud3",width="100%",height="250px"),
                         #imageOutput("wordcloud4",width="100%",height="250px")
           )
           
           
           
  ),

  
  tabPanel("I'm feeling Lucky!",
           titlePanel("Do not know what to watch? Just follow your heart!"),

           absolutePanel(id = "controls1", class = "panel panel-default",
                         draggable = F, 
                         top = 160, left = 100, right = "auto", bottom = "auto",
                         width = 250, height = "auto",
                         radioButtons(inputId = "genres",
                                      label  = "1.which attracts you most",
                                      choices = c('1','2','3','4','5','6'),
                                      selected ='1')
           ),
           absolutePanel(id = "controls2", class = "panel panel-default",
                         draggable = F, 
                         top = 380, left = 100, right = "auto", bottom = "auto",
                         width = 250, height = "auto",
                         radioButtons(inputId = "keywords",
                                      label  = "How about the color?",
                                      choices = c('red','yellow','green','blue','purple','black'),
                                      selected ='red')
           ),
           absolutePanel(id = "controls3", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 600, left = 100, right = "auto", bottom = "auto",
                         width = 250, height = "auto",
                         radioButtons(inputId = "keywords2",
                                      label  = "Have you ever read the poems",
                                      choices = c('A','B','C','D','E','F'),
                                      selected ='A')
           ),      
           absolutePanel(id = "options1", class = "panel panel-default",
                                     draggable = FALSE, 
                                     top = 160, left = 320, right = "auto", bottom = "auto",
                                     width = 1160, height = "auto",
                                     HTML('</center><img src="picture.gif" width="190" height="190" border="10"><tr>
                                          <img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10>
                                          <tr><img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10>')
                                     
                                     ),
           absolutePanel(id = "options2", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 380, left = 320, right = "auto", bottom = "auto",
                         width = 1160, height = "auto",
                         HTML('</center><img src="picture.gif" width="190" height="190" border="10"><tr>
                              <img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10>
                              <tr><img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10>')
                         
                         ),
           absolutePanel(id = "options3", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 600, left = 320, right = "auto", bottom = "auto",
                         width = 1160, height = "auto",
                         HTML('</center><img src="picture.gif" width="190" height="190" border="10"><tr>
                              <img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10>
<tr><img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10> <tr><img src="picture.gif" width="190" height="190" border=10>')
                         
           ),
           absolutePanel(id = "wordcloud1", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 820, left = 480, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("1"),
                         textOutput("1")
                         ),
           absolutePanel(id = "wordcloud2", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 820, left = 980, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("2"),
                         textOutput("2")
           ),
           absolutePanel(id = "wordcloud3", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 1220, left = 480, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("3"),
                         textOutput("3")
                         ),
           absolutePanel(id = "wordcloud4", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 1220, left = 980, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("4"),
                         textOutput("4")
           ),
           absolutePanel(id = "sen1", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 820, left = 100, right = "auto", bottom = "auto",
                         width = 350, height = 270,
                         plotOutput("1")),
           absolutePanel(id = "sen2", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 1090, left = 100, right = "auto", bottom = "auto",
                         width = 350, height = 270,
                         plotOutput("2")),
           absolutePanel(id = "sen3", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 1350, left = 100, right = "auto", bottom = "auto",
                         width = 350, height = 270,
                         plotOutput("3"))
           
           
           ),
  
  
  
  
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
           )
           
           
           
  )))
