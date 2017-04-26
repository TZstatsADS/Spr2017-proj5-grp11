library(syuzhet)
library(stringr)
library(text2vec)
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
for(i in 1:3652){
  flag[i]= uniquetype[1] %in% genrestype[[i]]|uniquetype[2] %in% genrestype[[i]]|uniquetype[15] %in% genrestype[[i]]|uniquetype[18] %in% genrestype[[i]]
}
flag1<-as.numeric(flag)
flag<-NULL
for(i in 1:3652){
  flag[i]= uniquetype[3] %in% genrestype[[i]]|uniquetype[4] %in% genrestype[[i]]|uniquetype[7] %in% genrestype[[i]]
}
flag2<-as.numeric(flag)
flag<-NULL
for(i in 1:3652){
  flag[i]= uniquetype[5] %in% genrestype[[i]]|uniquetype[11] %in% genrestype[[i]]|uniquetype[16] %in% genrestype[[i]]|uniquetype[17] %in% genrestype[[i]]
}
flag3<-as.numeric(flag)
flag<-NULL
for(i in 1:3652){
  flag[i]= uniquetype[9] %in% genrestype[[i]]|uniquetype[13] %in% genrestype[[i]]|uniquetype[6] %in% genrestype[[i]]|uniquetype[10] %in% genrestype[[i]]|uniquetype[12] %in% genrestype[[i]]|uniquetype[20] %in% genrestype[[i]]
}
flag4<-as.numeric(flag)
flag<-NULL
for(i in 1:3652){
  flag[i]= uniquetype[8] %in% genrestype[[i]]}
flag5<-as.numeric(flag)
flag<-NULL
for(i in 1:3652){
  flag[i]= uniquetype[22] %in% genrestype[[i]]|uniquetype[19] %in% genrestype[[i]]|uniquetype[14] %in% genrestype[[i]]|uniquetype[21] %in% genrestype[[i]]
}
flag6<-as.numeric(flag)

genre_data<-data.frame(flag1,flag2,flag3,flag4,flag5,flag6)

## data with genres+sentiment
data_wgs= cbind(data_emo, genre_data)

#get plotkeywords tdidf
plot_words= input_data$plot_keywords
plot_words= strsplit(plot_words, split="[|]")
plot_words_df= matrix(NA, nrow=length(plot_words), ncol=1)
for (i in 1:length(plot_words)){
  plot_words_df[i]= paste(plot_words[[i]], collapse=" ")
}

plot_words_df= as.data.frame(plot_words_df)
plot_words_df$ID= 1:nrow(plot_words_df)
colnames(plot_words_df)[1]= "plot_keyword"
plot_words_df$plot_keyword=as.character(plot_words_df$plot_keyword)
plot_it <- itoken(plot_words_df$plot_keyword,
                  preprocessor = tolower, 
                  tokenizer = word_tokenizer,
                  ids = plot_words_df$ID,
                  progressbar = FALSE)
vocab <- create_vocabulary(plot_it, stopwords = c("a", "an", "the", "in", "on",
                                                  "at", "of", "above", "under"))
vectorizer <- vocab_vectorizer(vocab)
dtm_train <- create_dtm(plot_it, vectorizer)
tfidf <- TfIdf$new()
dtm_train_tfidf <- fit_transform(dtm_train, tfidf)
plot_words_mat= as.matrix(dtm_train_tfidf)

#filter data for recommendations
data_wgst= cbind(data_wgs, plot_words_mat)
data_recc= data_wgst[,-c(1,10, 17, 18)]
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

## Server function

server<- function(input, output){
  
  ##Introduction
  output$blankspace = renderUI({
    HTML("<br/><br/><br/><br/><br/><br/><br/><br/>")
  })
  output$text = renderUI({
    HTML("<br/><br/><br/>Our project looks into the trade of coffee, tea, chocolate, cocoa and spices<br/>
         between the United States and the rest of the world<br/><br/><br/><br/>Group 11: Ruxue, Xiaowo, Rapha??l, Bowen, Terry")
  })
  
  ##Recommendations page
  
  #get 4 movie recommendations dataframe
  data_aftrec = reactive({
    #Using KDtree classifier
    
    moviename<- input$movienames
    data_recc$movie_title= as.factor(data_recc$movie_title)
    movieind= which(moviename==data_recc$movie_title)
    querydata=data_recc[movieind,]
    tree=nn2(data_recc, query=querydata, k=5, searchtype="priority")
    ind=tree$nn.idx[2:5]
    ind=as.vector(ind)
    
    data_recc[ind,]}) 
  
  output$try = renderDataTable({
    d<-data_aftrec()
    d[,1:2]})

  
  output$wordcloud1 = renderImage({
    
    d<- data_aftrec()
    recc1= as.vector(d$movie_title[1])
    recc1 <- str_replace_all(string=recc1, pattern=" ", repl="")
    recc1 <- str_replace_all(string=recc1, pattern="/", repl="_")
    recc1 <- str_replace_all(string=recc1, pattern=":", repl="/")
    filename = normalizePath(file.path('../figs', paste(recc1, '.jpg', sep='')))
    list(src=filename, alt=paste("Reviews Wordcloud", recc1))
    
    }, deleteFile=FALSE) 
  
  output$wordcloud2 = renderImage({
    
    d<- data_aftrec()
    recc2= as.vector(d$movie_title[2]) 
    recc2 <- str_replace_all(string=recc2, pattern=" ", repl="")
    recc2 <- str_replace_all(string=recc2, pattern="/", repl="_")
    recc2 <- str_replace_all(string=recc2, pattern=":", repl="/")
    filename = normalizePath(file.path('./figs', paste(recc2, '.jpeg', sep='')))
    list(src=filename, alt=paste("Reviews Wordcloud", recc2))
    
  }, deleteFile=FALSE) 
  
  output$wordcloud3 = renderImage({
    
    d<- data_aftrec()
    recc3= as.vector(d$movie_title[3]) 
    recc3 <- str_replace_all(string=recc3, pattern=" ", repl="")
    recc3 <- str_replace_all(string=recc3, pattern="/", repl="_")
    recc3 <- str_replace_all(string=recc3, pattern=":", repl="/")
    filename = normalizePath(file.path('./figs', paste(recc3, '.jpeg', sep='')))
    list(src=filename, alt=paste("Reviews Wordcloud", recc3))
    
  }, deleteFile=FALSE) 
  
  output$wordcloud4 = renderImage({
    
    d<- data_aftrec()
    recc4= as.vector(d$movie_title[4]) 
    recc4 <- str_replace_all(string=recc4, pattern=" ", repl="")
    recc4 <- str_replace_all(string=recc4, pattern="/", repl="_")
    recc4 <- str_replace_all(string=recc4, pattern=":", repl="/")
    filename = normalizePath(file.path('./figs', paste(recc4, '.jpeg', sep='')))
    list(src=filename, alt=paste("Reviews Wordcloud", recc4))
    
  }, deleteFile=FALSE) 
  
  
    
    
    
  }