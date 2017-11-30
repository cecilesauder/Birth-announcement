library(tidyverse)
library(lubridate)
#devtools::install_github("dill/emoGG")
library(emoGG)
#devtools::install_github("ThinkR-open/who")
library(who)

#deploiement de l'application
#install.packages('rsconnect')
library(rsconnect)
rsconnect::setAccountInfo(name='cecilesauder', token='557317F15D5B138698A64DD8DA2FC6E6', secret='lWG2AsOatUUJW1FRiwxc3EYvFCqE36mHViyuMQXV')
deployApp()

install.packages("plotly")
library(plotly)

# Lexie data 
lexie <- tribble( ~date, ~weight, ~height, ~head_circumference,
                  "2017-07-12", 3.460, 50, 34, 
                  "2017-07-13", 3.200, NA, NA,
                  "2017-07-14", 3.100, NA, NA,
                  "2017-07-15", 3.200, NA, NA,
                  "2017-07-16", 3.250, NA, NA,
                  "2017-07-17", 3.310, 51, 35,
                  "2017-07-18", 3.350, NA, NA,
                  "2017-07-26", 3.810, NA, NA,
                  "2017-08-03", 3.950, NA, NA,
                  "2017-08-14", 4.180, 56, 37.5,
                  "2017-09-05", 4.530, NA, NA,
                  "2017-09-14", 4.750, 57, NA,
                  "2017-10-12", 5.060, 59.5, 40,
                  "2017-10-27", 5.520, 61, NA,
                  "2017-11-13", 5.980, 62, 41.5
) %>%
  mutate(
    date = ymd(date),
    day = as.numeric(date - min(date)),
    week = day/7
  )


# function to plot different curves
courbe <- function(varname){
  maxDay <- max(lexie[["day"]])
  # tbl for ggplot
  tab <- standards %>%
    filter(sex == "F", percentile %in% c(3, 25, 50, 75, 97)) %>%
    select_("Age","percentile", varname) %>%
    filter(Age < maxDay )
  
  lexie <- lexie %>%
    select_("day", varname) %>%
    na.omit()
  
  #ggplot
  
  img <- readPNG("./www/bg.png") 
  
  g <- rasterGrob(img, interpolate=TRUE) 
  
  tab %>%
    ggplot( aes_string( "Age", varname, color = "percentile", group = "percentile" )) +
    geom_line(linetype = 2) + 
    theme_light() +
    geom_text(
      data = filter(tab, Age == maxDay - 1),
      mapping  = aes_string( x = "Age + 3" , varname, label = "percentile", col = NULL ), 
      size = 3
    ) +
    guides(colour=FALSE) +
    scale_color_gradient_mirror(midpoint=50, colors = c("violetred4", "violetred3", "violetred1") ) +
    geom_line(data=lexie , mapping = aes_string( x = "day", y = varname, col = NULL, group = NULL), size = 1) +
  #  annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) +
    geom_point(data=lexie, col= "violetred4", size=2, mapping = aes_string( x = "day", y = varname, col = NULL, group = NULL))
  
}

p <- courbe("weight")
p
ggplotly(p)
courbe("height")
courbe("head_circumference")

gp <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + geom_point()
ggplotly(gp)

#code romain

library(tidyverse)
library(scales)
library(stringr)

scale_color_gradient_mirror <- function (..., colors ,  
                                         midpoint = 0, space = "Lab", na.value = "grey50", guide = "colourbar") {
  cols <- c( head(colors, -1), tail( colors, 1), rev( head( colors, -1)) )
  continuous_scale("colour", "gradient2", 
                   gradient_n_pal( cols ), 
                   na.value = na.value, guide = guide, 
                   ..., rescaler = ggplot2:::mid_rescaler(mid = midpoint))
}


df <- data.frame( date = seq( ymd("2017-07-12"), today() , by = "day"), age = 0:127)
