
#load the packages
if (FALSE){
library(plyr)
library(dplyr)
library(tidyr)
library(syuzhet)
library(shinyBS)
library(text2vec)
library(RANN)
library(stringr)
library(ggplot2)
library(plotly)}


## main data
input_data =  read.csv("data_clean.csv",header = T,as.is = T)
input_data = input_data[,-1]

##create data for recommendations (put in genre, remove keywords, put in recommendations)

#sentiment code
keywords <- input_data$plot_keywords
emotions <- get_nrc_sentiment(keywords)[,1:8]
data_emo = cbind(input_data, emotions)

#generate genre data columns (binary labels)
genrestype<-input_data$genres
genrestype<-as.matrix(genrestype)

uniquetype<-unique(unlist(apply(genrestype,2,strsplit,split=",")))
genrestype<-strsplit(genrestype,split = ",")
#pick out
flag<-NULL
for(i in 1:nrow(input_data)){
  flag[i]= uniquetype[1] %in% genrestype[[i]]|uniquetype[2] %in% genrestype[[i]]|uniquetype[15] %in% genrestype[[i]]|uniquetype[18] %in% genrestype[[i]]
}
flag1<-as.numeric(flag)
flag<-NULL
for(i in 1:nrow(input_data)){
  flag[i]= uniquetype[3] %in% genrestype[[i]]|uniquetype[4] %in% genrestype[[i]]|uniquetype[7] %in% genrestype[[i]]
}
flag2<-as.numeric(flag)
flag<-NULL
for(i in 1:nrow(input_data)){
  flag[i]= uniquetype[5] %in% genrestype[[i]]|uniquetype[11] %in% genrestype[[i]]|uniquetype[16] %in% genrestype[[i]]|uniquetype[17] %in% genrestype[[i]]
}
flag3<-as.numeric(flag)
flag<-NULL
for(i in 1:nrow(input_data)){
  flag[i]= uniquetype[9] %in% genrestype[[i]]|uniquetype[13] %in% genrestype[[i]]|uniquetype[6] %in% genrestype[[i]]|uniquetype[10] %in% genrestype[[i]]|uniquetype[12] %in% genrestype[[i]]|uniquetype[20] %in% genrestype[[i]]
}
flag4<-as.numeric(flag)
flag<-NULL
for(i in 1:nrow(input_data)){
  flag[i]= uniquetype[8] %in% genrestype[[i]]}
flag5<-as.numeric(flag)
flag<-NULL
for(i in 1:nrow(input_data)){
  flag[i]= uniquetype[22] %in% genrestype[[i]]|uniquetype[19] %in% genrestype[[i]]|uniquetype[14] %in% genrestype[[i]]|uniquetype[21] %in% genrestype[[i]]
}
flag6<-as.numeric(flag)

genre_data<-data.frame(flag1,flag2,flag3,flag4,flag5,flag6)

## data with genres+sentiment
data_wgs= cbind(data_emo, genre_data)
data_recc= data_wgs[,-c(1,10, 17, 18)]
data_recc$movie_title=as.character(data_recc$movie_title)
##note: to use RANN package, must convert all character variables into factor variables
data_recc$director_name= as.factor(data_recc$director_name)
data_recc$actor_2_name= as.factor(data_recc$actor_2_name)
data_recc$actor_1_name= as.factor(data_recc$actor_1_name)
data_recc$movie_title=as.factor(data_recc$movie_title)
data_recc$actor_3_name= as.factor(data_recc$actor_3_name)
data_recc$language= as.factor(data_recc$language)
data_recc$country= as.factor(data_recc$country)
data_recc$content_rating= as.factor(data_recc$content_rating)
data_recc$title_year=as.factor(data_recc$title_year)

##data for panel 3 (feeling lucky)
sent.df <- data.frame(input_data$movie_title, input_data$imdb_score, input_data$gross,input_data$director_name, emotions)

sent.df$red<-sent.df$fear+sent.df$anger+sent.df$surprise
sent.df<-sent.df[,-c(5,8,11)]
colnames(sent.df)[5:9]<-c("purple","dark yellow","pink","blue","orange")

genre_choice<-c('1','2','3','4','5','6')
color_choice<-c('red','purple',"pink","dark yellow","blue","orange")
peom_choice<-c('A','B','C','D','E','F')


get_df<-function(genre,col,poem){
  df<-sent.df
  index<-genre_data[,which(genre_choice==genre)]==1
  df<-df[index,]
  temp<-df[order(df[,col],decreasing = TRUE),]
  color2 <- color_choice[which(peom_choice==poem)]
  temp<-temp[temp[,color2]!=0,][1:5,]
  temp<-temp[order(temp$input_data.gross,decreasing = TRUE),c(1,2,4)]
  colnames(temp)<-c("Movie Title","IMDB Score","Director Name")
  # temp<-as.matrix(temp)
  # temp<-t(temp)
  return(temp)
}

get_recc= function(movie, data_recc) {
  moviename<- movie
  data_recc$movie_title= as.factor(data_recc$movie_title)
  movieind= which(moviename==data_recc$movie_title)
  querydata=data_recc[movieind,]
  tree=nn2(data_recc, query=querydata, k=5, searchtype="priority")
  ind=tree$nn.idx[2:5]
  ind=as.vector(ind)
  
  return(as.data.frame(data_recc[ind,]))
}

  

## Server function

server<- function(input, output, session){
  
  ##Introduction
  output$blankspace = renderUI({
    HTML("<br/><br/><br/><br/><br/>")
  })
  output$text = renderUI({
    HTML("<br/><br/><br/>Our Shiny App seeks to provide you with a fun and different platform to choose a movie to watch.<br/><br/>
         You can either key in one of your favorite movies to get a recommendation <b>(Recommend me!)</b>, <br/><br/>
         Or use our <b>Im feeling Lucky!</b> tab to choose a movie by selecting images and poems that call out to you. <br/><br/>
         Of course, our methodology is secret, but do not worry as we have backed it up with psychology research. <br/><br/>
         (or maybe not)<br/><br/><br/><br/>Group 11: Jia Hui, Tong Yue, Bo Wen, Chengcheng, Shu Yi")
  })
  
  ##Manual
  output$manual=renderUI({HTML("<br/><br/><br/><b>(Recommend me!)</b><br>
                               - User keys in one favorite movie<br>
                               - We would recommend four movies, displaying a word cloud for the audience review of that movie and some basic information<br/><br/>
                               <br/><br/><br/><b>(I am feeling lucky!)</b><br>
                               - User keys in choices of favorite pictures<br>
                               - We would recommend four movies, displaying a word cloud for the audience reviews of that movie and some basic information. The recommendation is based on reference of chosen <br/><br/>
                               <br/><br/><br/><b>(To be Continued!)</b><br>
                               - display some data analysis results to give users a broad view of the scores of movies belonged to different genres and across different countries<br>")
    
  })
  
  
  ##Recommendations page

  
  output$wordcloud1 = renderImage({
    
    d<- get_recc(input$movienames, data_recc)
    recc1= as.vector(d$movie_title[1]) 
    recc1 <- str_replace_all(string=recc1, pattern=" ", repl="")
    recc1 <- str_replace_all(string=recc1, pattern="/", repl="_")
    recc1 <- str_replace_all(string=recc1, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc1, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc1))
    
    }, deleteFile=FALSE) 

                                                         
  output$wordcloud2 = renderImage({
    
    d<- get_recc(input$movienames, data_recc)
    recc2= as.vector(d$movie_title[2]) 
    recc2 <- str_replace_all(string=recc2, pattern=" ", repl="")
    recc2 <- str_replace_all(string=recc2, pattern="/", repl="_")
    recc2 <- str_replace_all(string=recc2, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc2, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc2))
    
  }, deleteFile=FALSE) 
  
  
  output$wordcloud3 = renderImage({
    
    d<- get_recc(input$movienames, data_recc)
    recc3= as.vector(d$movie_title[3]) 
    recc3 <- str_replace_all(string=recc3, pattern=" ", repl="")
    recc3 <- str_replace_all(string=recc3, pattern="/", repl="_")
    recc3 <- str_replace_all(string=recc3, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc3, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc3))
    
  }, deleteFile=FALSE) 
  

  output$wordcloud4 = renderImage({
    
    d<- get_recc(input$movienames, data_recc)
    recc4= as.vector(d$movie_title[4]) 
    recc4 <- str_replace_all(string=recc4, pattern=" ", repl="")
    recc4 <- str_replace_all(string=recc4, pattern="/", repl="_")
    recc4 <- str_replace_all(string=recc4, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc4, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc4))
    
  }, deleteFile=FALSE) 
  
  
  output$w1<-renderPrint(cat(" Movie Title:",
                             as.character(get_recc(input$movienames, data_recc)$movie_title[1]),"\n",
                             "IMDB Score:",get_recc(input$movienames, data_recc)$imdb_score[1],"\n",
                             "Director Name:",as.character(get_recc(input$movienames, data_recc)$director_name[1])))
  
  
  
  output$w2<-renderPrint(cat(" Movie Title:",
                             as.character(get_recc(input$movienames, data_recc)$movie_title[2]),"\n",
                             "IMDB Score:",get_recc(input$movienames, data_recc)$imdb_score[2],"\n",
                             "Director Name:",as.character(get_recc(input$movienames, data_recc)$director_name[2])))
  
  
  
  
  
  output$w3<-renderPrint(cat(" Movie Title:",
                             as.character(get_recc(input$movienames, data_recc)$movie_title[3]),"\n",
                             "IMDB Score:",get_recc(input$movienames, data_recc)$imdb_score[3],"\n",
                             "Director Name:",as.character(get_recc(input$movienames, data_recc)$director_name[3])))
  
  
  
  output$w4<-renderPrint(cat(" Movie Title:",
                             as.character(get_recc(input$movienames, data_recc)$movie_title[4]),"\n",
                             "IMDB Score:",get_recc(input$movienames, data_recc)$imdb_score[4],"\n",
                             "Director Name:",as.character(get_recc(input$movienames, data_recc)$director_name[4])))
  
    #### for panel feeling lucky
  
  
  output$r1<-renderPrint(cat(" Movie Title:",
                             as.character(get_df(input$genres,input$keywords,input$keywords2)[1,1]),"\n",
                             "IMDB Score:",get_df(input$genres,input$keywords,input$keywords2)[1,2],"\n",
                             "Director Name:",as.character(get_df(input$genres,input$keywords,input$keywords2)[1,3])))
  
  output$r2<-renderPrint(cat(" Movie Title:",
                             as.character(get_df(input$genres,input$keywords,input$keywords2)[2,1]),"\n",
                             "IMDB Score:",get_df(input$genres,input$keywords,input$keywords2)[2,2],"\n",
                             "Director Name:",as.character(get_df(input$genres,input$keywords,input$keywords2)[2,3])))
  
  output$r3<-renderPrint(cat(" Movie Title:",
                             as.character(get_df(input$genres,input$keywords,input$keywords2)[3,1]),"\n",
                             "IMDB Score:",get_df(input$genres,input$keywords,input$keywords2)[3,2],"\n",
                             "Director Name:",as.character(get_df(input$genres,input$keywords,input$keywords2)[3,3])))
  
  output$r4<-renderPrint(cat(" Movie Title:",
                             as.character(get_df(input$genres,input$keywords,input$keywords2)[4,1]),"\n",
                             "IMDB Score:",get_df(input$genres,input$keywords,input$keywords2)[4,2],"\n",
                             "Director Name:",as.character(get_df(input$genres,input$keywords,input$keywords2)[4,3])))
  
  output$p1<-renderImage({
    
    d<-get_df(input$genres,input$keywords,input$keywords2)
    recc1= as.vector(d[1,1]) 
    recc1 <- str_replace_all(string=recc1, pattern=" ", repl="")
    recc1 <- str_replace_all(string=recc1, pattern="/", repl="_")
    recc1 <- str_replace_all(string=recc1, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs/', paste(recc1, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc1))
    
  }, deleteFile=FALSE) 
  

  output$p2<-renderImage({
    
    d<-get_df(input$genres,input$keywords,input$keywords2)
    recc2= as.vector(d[2,1]) 
    recc2 <- str_replace_all(string=recc2, pattern=" ", repl="")
    recc2 <- str_replace_all(string=recc2, pattern="/", repl="_")
    recc2 <- str_replace_all(string=recc2, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc2, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc2))
    
  }, deleteFile=FALSE) 
  
  output$p3<-renderImage({
    
    d<-get_df(input$genres,input$keywords,input$keywords2)
    recc3= as.vector(d[3,1]) 
    recc3 <- str_replace_all(string=recc3, pattern=" ", repl="")
    recc3 <- str_replace_all(string=recc3, pattern="/", repl="_")
    recc3 <- str_replace_all(string=recc3, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc3, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc3))
    
  }, deleteFile=FALSE) 
  
  
  output$p4<-renderImage({
    
    d<-get_df(input$genres,input$keywords,input$keywords2)
    recc4= as.vector(d[4,1]) 
    recc4 <- str_replace_all(string=recc4, pattern=" ", repl="")
    recc4 <- str_replace_all(string=recc4, pattern="/", repl="_")
    recc4 <- str_replace_all(string=recc4, pattern=":", repl="_")
    filename = normalizePath(file.path('./figs', paste(recc4, '.jpg', sep='')))
    list(src=filename, width=470, height=330,alt=paste("Reviews Wordcloud", recc4))
    
  }, deleteFile=FALSE) 
  
  
  ###to be continued
  movie <- read.csv("data_symbol.csv",header=T,as.is=T)
  
  movie$symbols <- as.factor(movie$symbols)
  movie <- movie[is.na(movie$gross)==FALSE,]
  symbols_gross <- tapply(as.numeric(movie$gross),movie$symbols,sum)
  symbols_top <- names(sort(symbols_gross,decreasing=T))[1:20]
  movie_plotly <- movie[movie$symbols %in% symbols_top,]
  
  movie1 <- read.csv("data_clean.csv",header=T,as.is=T)
  movie1$country <- as.factor(movie1$country)
  movie1 <- movie1[is.na(movie1$gross)==FALSE,]
  country_gross <- tapply(as.numeric(movie1$gross),movie1$country,sum)
  country_top <- names(sort(country_gross,decreasing=T))[1:20]
  movie1_plotly <- movie1[movie1$country %in% country_top,]
  
  
  output$Plot1 <- renderPlotly(
    plot_ly(movie1, x = ~imdb_score, y = ~country, z = ~gross, color = ~country, colors="Set3",marker = list(symbol = 'circle', sizemode = 'diameter')) %>%
      layout(scene = list(xaxis = list(title = 'IMDB Score'),
                          yaxis = list(title = 'Country'),
                          zaxis = list(title = 'Gross')))
    
  )
  
  output$Plot2 <- renderPlotly(
    plot_ly(movie, x = ~symbols, y= ~imdb_score, color= ~symbols, colors="Set3",type = "box") %>%
      layout(yaxis=list(title="IMDB Score"),xaxis=list(title=""))
  )
  
  output$explain = renderUI({
    HTML("<br/><br/><br/>This tab serves to provide additional information that we hope would be useful in some way in helping the user decide on what kind of movie to watch. 
         In view of this, we created two plots:<br/><br/>
         <b>1. Explore the distribution of IMDB score and gross for movies of various</b><br/><br/>
         <b>2. Boxplot of the IMDB score of various genres </b><br/><br/>
         Gives a preliminary visualization of which genre seem to have a higher IMDB mean score/spread size <br/><br/>
         <b>Have lots of fun using our app!</b><br/><br/>
         Further possible improvements: 
         We could look into scrapping reviews from more neutral public domain websites, such as Rotten Tomatoes. 
         Also, we could further explore clustering techniques (i.e. KMeans) to see if they would perform similarly or better than the KDTree classifier.<br/><br/><br/><br/>")
  })
  
  
    
  }