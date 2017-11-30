
library(shiny)
library(shinydashboard)

dashboardPage(

  skin = "purple",
  dashboardHeader(title = "Hello World ! "),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Bébé", tabName = "bebe", icon = icon("birthday-cake")),
      menuItem("Courbes", tabName = "courbes",icon = icon("dashboard"),
               menuSubItem("Poids", tabName = "poids"),
               menuSubItem("Taille", tabName = "taille"),
               menuSubItem("Périmètre cranien", tabName = "PC")
               ),
      menuItem("Photos", tabName = "photos", icon = icon("baby-formula", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    tabItems(
      tabItem(tabName = "bebe",
              valueBox("Lexie", "SAUDER FRANCOIS", icon = icon("venus"), color = "fuchsia", width = 3),
              valueBox("2017-07-12", "17:16", icon = icon("birthday-cake"), width = 3),
              valueBox("3.460 kg" , "weight", icon = icon("balance-scale"), color = "maroon", width = 3),
              valueBox("50 cm", "height", icon = icon("arrows-v"), color = "yellow", width = 3),
              imageOutput("baImg")
      ),
      tabItem(tabName = "poids",
              box(
                width = 12,
                title = "Courbe du poids (kg)",  solidHeader = TRUE,
                collapsible = TRUE, background = "maroon",
                valueBoxOutput("poidsBox"),
                plotOutput("poidsPlot", height = 800, 
                           hover = hoverOpts(
                             id = "plot_hover"
                           )
                           )
              )
      ),
      tabItem(tabName = "taille",
              box(
                width = 12,
                title = "Courbe de la taille (cm)",  solidHeader = TRUE,
                collapsible = TRUE, background = "teal",
                plotOutput("taillePlot", height = 800)
              )
      ),
      tabItem(tabName = "PC",
              box(
                width = 12,
                title = "Courbe du périmètre cranien (cm)",  solidHeader = TRUE,
                collapsible = TRUE, background = "fuchsia",
                plotOutput("pcPlot", height = 800)
              )
      ),
      tabItem(tabName = "photos",
              box(
                width = 12,
                sliderInput("sliderphoto", "Age en jours : ", min = 0, max = 124, value = 0,
                            animate =  animationOptions(interval = 4000, loop = TRUE, 
                                                        playButton = "PLAY", pauseButton = "PAUSE"))
              ),
              box(
                width = 12,
                #imageOutput("image")
                uiOutput("image")
              )
      )
      
    )
  )
)

