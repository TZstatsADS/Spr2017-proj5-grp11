
#load the packages
if(FALSE){
library(plyr)
library(dplyr)
library(tidyr)
library(syuzhet)
library(shinyBS)
library(text2vec)
library(RANN)
library(stringr)
library(ggplot2)
library(plotly)
  }


#load data
input_data =  read.csv("data_clean.csv",header = T,as.is = T)
input_data = input_data[,-1]

shinyUI(navbarPage(
  
  ##link to css.file
  theme = "bootstrap2.css",
  
  ##Project Title
  "Magic Movie Mirror",
  
  
  tags$head(
    tags$style(HTML("body{
                    background-image: url(http://www.publicdomainpictures.net/pictures/170000/velka/faded-clouds-background.jpg );
                    }"))),
  
  tabPanel("Home",
           htmlOutput("blankspace"),
           titlePanel("Magic Mirror on the Wall, What is the Movie for me Now?"),
           h4(htmlOutput("text")),
           htmlOutput("teammates")
  ),
  
  tabPanel("Manual",
           titlePanel("How to use our App"),
           h4(htmlOutput("manual"))
  ),
  
  
  tabPanel("Recommend me!",
           titlePanel("Movie Recommendation"),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 20, right = "auto", bottom = "auto",
                         width = 350, height = "auto",
                         
                         h2("Key in one of your favourite movie and we will recommend you one back!"),
                         hr(),
                         verbatimTextOutput('out6'),
                         selectInput('movienames', 'My Movie Choice:', input_data$movie_title, selected="Titanic", multiple=F, selectize=T)
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 390, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("wordcloud1"),
                         verbatimTextOutput("w1")
           ),
           
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 180, left = 890, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("wordcloud2"),
                         verbatimTextOutput("w2")
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 698, left = 390, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("wordcloud3"),
                         verbatimTextOutput("w3")
                         
                         
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 698, left = 890, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("wordcloud4"),
                         verbatimTextOutput("w4")
           )
           
  ),
  
  
  tabPanel("I'm feeling Lucky!",
           titlePanel("Don't know what to watch? Just follow your heart!"),
           
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = F, 
                         top = 160, left = 20, right = "auto", bottom = "auto",
                         width = 250, height = "auto",
                         radioButtons(inputId = "genres",
                                      label  = "1. Which picture attracts you the most?",
                                      choices = c('1','2','3','4','5','6'),
                                      selected ='3')
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = F, 
                         top = 420, left = 20, right = "auto", bottom = "auto",
                         width = 250, height = "auto",
                         radioButtons(inputId = "keywords",
                                      label  = "2. Which color calls out to you?",
                                      choices = c('red','pink','orange','dark yellow','blue','purple'),
                                      selected ='orange')
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 680, left = 20, right = "auto", bottom = "auto",
                         width = 250, height = "auto",
                         radioButtons(inputId = "keywords2",
                                      label  = "3. Which is your favorite poetic line?",
                                      choices = c('A','B','C','D','E','F'),
                                      selected ='C')
           ),      
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 180, left = 280, right = "auto", bottom = "auto",
                         width = 1120, height = 195,
                         HTML('</center><img src="actiongenre.jpg" width="175" height="190" border="10"><tr>
                              <img src="fantasygenre.jpg" width="175" height="190" border=10> <tr><img src="mysterygenre.jpg" width="175" height="190" border=10>
                              <tr><img src="romancegenre.jpg" width="175" height="190" border=10> <tr><img src="comedygenre.jpg" width="175" height="190" border=10> <tr><img src="docgenre.jpg" width="175" height="190" border=10>')
                         
                         ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 440, left = 280, right = "auto", bottom = "auto",
                         width = 1120, height = 195,
                         HTML('</center><img src="red.jpg" width="175" height="190" border="10"><tr>
                              <img src="pink.jpg" width="175" height="190" border=10> <tr><img src="orange.jpg" width="175" height="190" border=10>
                              <tr><img src="yellow.jpg" width="175" height="190" border=10> <tr><img src="blue.jpg" width="175" height="190" border=10> <tr><img src="purple.jpg" width="175" height="190" border=10>')
                         
                         ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = FALSE, 
                         top = 700, left = 280, right = "auto", bottom = "auto",
                         width = 1120, height = 195,
                         HTML('</center><img src="anger.png" width="175" height="190" border="10"><tr>
                              <img src="joy.png" width="175" height="190" border=10> <tr><img src="trust.png" width="175" height="190" border=10>
                              <tr><img src="disgust.png" width="175" height="190" border=10> <tr><img src
                              ="sad.png" width="175" height="190" border=10> <tr><img src="anticipation.png" width="175" height="190" border=10>')
                         
                         ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 950, left = 300, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("p1"),
                         verbatimTextOutput("r1")
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 950, left = 810, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("p2"),
                         verbatimTextOutput("r2")
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 1480, left = 300, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("p3"),
                         verbatimTextOutput("r3")
           ),
           absolutePanel(id = "controls", class = "panel panel-default",
                         draggable = TRUE, 
                         top = 1480, left = 810, right = "auto", bottom = "auto",
                         width = 500, height = "auto",
                         imageOutput("p4"),
                         verbatimTextOutput("r4")
           )),
  
  tabPanel( "To be continued",
            titlePanel("In the end..."),
            
            # Show a plot of the generated distribution
            absolutePanel(id="controls", class="panel panel-default", draggable=TRUE,
              top = 160, left = 30,
              plotlyOutput("Plot1")),
            absolutePanel(id="controls", class="panel panel-default", draggable=TRUE,
                          top = 600, left = 30,
                          plotlyOutput("Plot2")),
            absolutePanel(id="controls", class="panel panel-default", draggable=TRUE,
                          top = 160, left = 800, width=600,
                          htmlOutput("explain"))
            ))      
           
           
           
  )
