library(shiny)


setwd("~/Desktop/ADS/Spr2017-proj5-grp11/data")
movie <- read.csv("data_clean.csv",header=T,as.is=T)


keywords <- movie$plot_keywords
emotions <- get_nrc_sentiment(keywords)[,1:8]



sent.df <- data.frame(movie$movie_title,movie$gross,movie$director_name,emotions)
sent.df[order(sent.df$trust,decreasing=T),]
sent.df$red<-sent.df$fear+sent.df$anger+sent.df$surprise
sent.df<-sent.df[,-c(4,7,10)]
colnames(sent.df)[4:8]<-c("purple","dark yellow","pink","blue","orange")



shinyServer(function(input, output) {
  
  observeEvent(input$filter2_red, {
    ans<-sent.df[order(sent.df$red,decreasing=T),1:3][1:4,]
    
    output$result<-renderDataTable(ans)
  })
  
  
  observeEvent(input$filter2_purple, {
    ans<-sent.df[order(sent.df$purple,decreasing=T),1:3][1:4,]
    
    output$result<-renderDataTable(ans)
  })
  
  
  observeEvent(input$filter2_pink, {
    ans<-sent.df[order(sent.df$pink,decreasing=T),1:3][1:4,]
    
    output$result<-renderDataTable(ans)
  })
  
  observeEvent(input$filter2_blue, {
    ans<-sent.df[order(sent.df$blue,decreasing=T),1:3][1:4,]
    
    output$result<-renderDataTable(ans)
  })
  
  observeEvent(input$filter2_yellow, {
    ans<-sent.df[order(sent.df$`dark yellow`,decreasing=T),1:3][1:4,]
    
    output$result<-renderDataTable(ans)
  })
  
  observeEvent(input$filter2_orange, {
    ans<-sent.df[order(sent.df$orange,decreasing=T),1:3][1:4,]
    
    output$result<-renderDataTable(ans)
  })
  
  
})
