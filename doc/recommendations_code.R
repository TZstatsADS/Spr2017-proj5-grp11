install.packages("RANN")
library(RANN)
#Clean data for tree

#load and process data
imdb_data <- read_csv("~/Desktop/Spr2017-proj5-grp11/data/imdb_data.csv")
colnames(imdb_data)

#Required variables (for tree): use all variables, except color (not very significant), plot_keywords (replace with sentiment analysis), movie_imdblink use for shiny when displaying information, genres change to binary variables for each unique genre, td-idf for plot_keywords, remove movie_imdblink only use as information displayed

data_use= imdb_data[complete.cases(imdb_data),]
data_use$movie_title=as.character(data_use$movie_title)
movie_title= as.data.frame(data_use$movie_title)
colnames(movie_title)="movie_title"
movie_title$movie_title=as.character(movie_title$movie_title)
movie_title$movie_title=substr(movie_title$movie_title, 1, nchar(movie_title$movie_title)-1) #remove ugly characters in movietitle
movie_title_n= movie_title

data_use= data_use[,-c(1,10,17,18)] # remove certain variables
data_use$movie_title= movie_title_n
data_use$movie_title<- do.call(cbind, data_use$movie_title)

#note: to use RANN package, must convert all character variables into factor variables
data_use$director_name= as.factor(data_use$director_name)
data_use$actor_2_name= as.factor(data_use$actor_2_name)
data_use$actor_1_name= as.factor(data_use$actor_1_name)
data_use$movie_title=as.factor(data_use$movie_title)
data_use$actor_3_name= as.factor(data_use$actor_3_name)
data_use$language= as.factor(data_use$language)
data_use$country= as.factor(data_use$country)
data_use$content_rating= as.factor(data_use$content_rating)
data_use$title_year=as.factor(data_use$title_year)

#parse plot_keywords
data_use2= imdb_data[complete.cases(imdb_data),]
plot_words= data_use2[,"plot_keywords"]
plot_words= strsplit(plot_words$plot_keywords, split="[|]")
plot_words_df= matrix(NA, nrow=length(plot_words), ncol=1)
for (i in 1:length(plot_words)){
  plot_words_df[i]= paste(plot_words[[i]], collapse=" ")
}

plot_words_df= as.data.frame(plot_words_df)
plot_words_df$ID= 1:nrow(plot_words_df)
colnames(plot_words_df)[1]= "plot_keyword"

library(text2vec)
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

#combine data
data_use2= cbind(data_use, plot_words_mat)

#build KDTree classifier

#movienames= c("Avatar", "Star Trek Into Darkness", "For Love of the Game")
data_use2$movie_title= as.factor(data_use2$movie_title)

getrecc= function(movienames_vec, data){
  
  movieind=vector(length=length(movienames_vec))
  for (i in 1:length(movienames)){
    movieind[i]=which(movienames_vec[i]==data$movie_title)
  }
  querydata=data[movieind,]
  
  tree=nn2(data, query=querydata, k=7, searchtype="priority")
  ind=tree$nn.idx[order(tree$nn.dists)[4:21]]
  ind=as.vector(ind)
  output= data[ind,]
  recc= unique(output$movie_title)[1:5]
  recc=as.vector(recc)
  recind=vector(length=length(recc))
  for (i in 1:length(recc)){
    recind[i]=which(recc[i]==data$movie_title)
  }
  return(list(recc=recc, indi=recind))
}

output=getrecc(movienames, data_use2) #get outcome 
reccommendations= output$recc #get recommendations in a vector
recinfo= data_use2[output$indi,1:ncol(data_use)] #get dataframe for output


#movie_imdblink use for shiny
imdblink= data_use2[, "movie_imdb_link"]
```
