packages.used <- 
  c("dplyr",
    "tidyr",
    "plyr",
    "syuzhet",
    "shinyBS",
    "text2vec",
    "RANN",
    "stringr",
    "ggplot2",
    "plotly"
  )

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

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