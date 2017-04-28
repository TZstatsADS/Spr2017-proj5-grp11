# ADS Project 5: 

Term: Spring 2017

+ Team #11

**Projec title: Movie Magic Mirror**
+ Team members
	+ Yuan Chengcheng
	+ Tan Jiahui
	+ Huang Bowen
	+ Liu Tongyue
	+ Tang Shuyi
	<br/>
	
**Project summary**
<br/>
	In this project, we seek to build a shiny app that would recommend movies to users based on two different methods: 
<br/>
+ a. More direct method: Use a KDTree classifier that we built using the data and additional features, we will recommend 4 movies based on one particular favorite movie of the user.  
     <br/>
 + b.More indirect method: Using “psychological analysis”, we will recommend a few movies based on what picture, what colour, and what poetic line the user chooses.	
<br/>
	We applied data science and natural language processing tools such as tree classification, LDA, sentimental analysis and word cloud visualization to implement the recommendation system and visualize the results in a more efficient, convenient, and most importantly fun manner. 
<br/>
<br/>


### APP Introduction
![alt tag](https://github.com/TZstatsADS/Spr2017-proj5-grp11/blob/bfc9d70e28c4e68c6d8efa8fd1dde5fa7bf18cd6/figs/Screen%20Shot%202017-04-27%20at%2010.52.54%20PM.png)

![alt tag](https://github.com/TZstatsADS/Spr2017-proj5-grp11/blob/bfc9d70e28c4e68c6d8efa8fd1dde5fa7bf18cd6/figs/Screen%20Shot%202017-04-27%20at%2010.53.03%20PM.png)
	
  + *Part 1: “Recommend me!” panel*
  <br/>
	Recommend four movies according to the favorite movie that the user inputs. Using the KD-Tree classifier “nn2” in RANN, which uses a KD-Tree to find a p number of near neighbors for each point in an input/output dataset to offer recommendation. 
<br/>

![alt tag](https://github.com/TZstatsADS/Spr2017-proj5-grp11/blob/bfc9d70e28c4e68c6d8efa8fd1dde5fa7bf18cd6/figs/Screen%20Shot%202017-04-27%20at%2010.53.10%20PM.png)
<br>

  + *Part 2: “I’m feeling lucky!” panel*
  <br/>
	The user is encouraged to choose a picture, colour, and poetic line respectively that call out to him the most. We did some research on psychological explanation of links between these and sentiments/genre, and we applied this to our analysis.
<br/>

![alt tag](https://github.com/TZstatsADS/Spr2017-proj5-grp11/blob/bfc9d70e28c4e68c6d8efa8fd1dde5fa7bf18cd6/figs/Screen%20Shot%202017-04-27%20at%2010.53.39%20PM.png)

![alt tag](https://github.com/TZstatsADS/Spr2017-proj5-grp11/blob/bfc9d70e28c4e68c6d8efa8fd1dde5fa7bf18cd6/figs/Screen%20Shot%202017-04-27%20at%2010.53.52%20PM.png)
<br/>

  + *Part 3: To be continued panel*
  <br/>
	In this part, we hope to provide some additional information that we hope would be useful in some way in helping the user decide on what kind of movie to watch.First, we plot a 3D graph to show the relationship between country, gross and IMDB score. The second graph is a box plot of IMDB score across different genres. 
<br/>
![alt tag](https://github.com/TZstatsADS/Spr2017-proj5-grp11/blob/ff7dc11dc6e86eaf1b4f5caa9fd5a3e691482040/figs/Screen%20Shot%202017-04-28%20at%2012.11.13%20AM.png)
<br/>
<br/>

**Contribution statement**: All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
