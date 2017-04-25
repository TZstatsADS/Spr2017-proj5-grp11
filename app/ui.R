library(shiny)



color_select<-list(purple="purple",red="red")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("我不知道我不知道我不知道看什么movie"),
  
  
  sidebarLayout(
    sidebarPanel(
      width = 100,
      actionButton("filter2_red", "red", 
                   style="color: #fff; background-color: #f03b20"),
      actionButton("filter2_purple", "purple", 
                   style="color: #fff; background-color: #cf8cea"),
      actionButton("filter2_pink", "pink", 
                   style="color: #fff; background-color: #fa9fb5"),
      actionButton("filter2_blue", "blue", 
                   style="color: #fff; background-color: #3182bd"),
      actionButton("filter2_yellow", "dark yellow", 
                   style="color: #fff; background-color: #b8860b"),
      actionButton("filter2_orange", "orange", 
                   style="color: #fff; background-color: #fd8d3c")
    ),
    
    
    mainPanel(
      h4("Our Recommendation"),dataTableOutput("result")
    )
  )
))
