library(shiny)
library(dplyr)
library(shinydashboard)
library(shinyWidgets)
library(data.table)
library(plotly)
library(ggplot2)
library(lubridate)
library(viridis)
library(remotes)
library(tidyverse)
library(collapsibleTree)
source('global.R')


# reading the data
df <- read.csv("https://raw.githubusercontent.com/ghazalayobi/CEU-Data-Visualization-4/main/data/Sales.csv")
df <- na.omit(df) %>% filter()
df$Date <- ymd(df$Date)



ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = 'Bike Sales'
                    ),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem('Filters', tabName = 'filters', icon = icon("filter")),
                        menuItem('Analysis', tabName = 'analysis', icon = icon("table")),
                        menuItem('Product Division', tabName = 'tree', icon = icon('bars')),
                        menuItem('Data', tabName = 'data', icon = icon("database"))
                      )
                    ), 
                    
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = 'filters',
                                fluidRow(
                                  column(6,
                                         sliderInput(inputId = "revenue_range", label = "Revenue item", min = 0, max = ceiling(max(df$Revenue)), 
                                                     round = TRUE, value = c(0, ceiling(max(df$Revenue)))),
                                         sliderInput(inputId = "age", label = "Customer Age", min = 17, 
                                                     max = ceiling(max(df$Customer_Age)), step = 1, round = TRUE, value = c(17, ceiling(max(df$Customer_Age)))),
                                         sliderInput("date_range", 
                                                     label = "Date Range:", 
                                                     min = as.Date("2011-01-01"), max = as.Date("2016-07-31"), 
                                                     value = c(as.Date("2011-01-01"), as.Date("2016-07-31")),
                                                     timeFormat = "%F",
                                                     step = 1)
                                  ), 
                                  column(6,
                                         checkboxGroupInput('product_category', label = 'Product Category', 
                                                            choices = unique(df$Product_Category), selected = unique(df$Product_Category)),
                                         br(),
                                         
                                         pickerInput('sub_cat', label = 'Product Sub Category', choices = unique(df$Sub_Category), 
                                                     selected = unique(df$Sub_Category), options = list(`actions-box` = TRUE), multiple = TRUE),
                                         br(),
                                         
                                         checkboxGroupInput('gender', label = 'Select Gender', choices = unique(df$Customer_Gender), 
                                                            selected = unique(df$Customer_Gender)),
                                         br(),
                                         pickerInput('country', label = 'Country', choices = unique(df$Country), 
                                                     selected = unique(df$Country), options = list(`actions-box` = TRUE), multiple = TRUE),
                                         br(),
                                         tags$h3('Reset filters'),
                                         actionButton('button_reset', label = 'Reset Filters')
                                  )
                                ),
                                
                                br(),
                                
                        ),
                        tabItem(tabName = 'analysis',
                                fluidRow(infoBoxOutput('rev_acc_info'),
                                         infoBoxOutput('rev_bikes_info'),
                                         infoBoxOutput('rev_clothing_info')
                                ),
                                br(),
                                fluidRow(column(6,plotlyOutput('year_dist_plot')),
                                         column(6,plotlyOutput('density_plot'))
                                ),
                                br(),
                                
                                fluidRow(column(6,plotlyOutput('country_rev_plot')),
                                         column(6,plotlyOutput('age_gender_plot'))
                                ),
                                br()
                        ), # End of the analysis tab
                        
                        tabItem(tabName = 'tree',
                                collapsibleTreeOutput('my_tree')
                        ),
                        
                        tabItem(tabName = 'data',
                                dataTableOutput('my_data')
                        ) # End data tab
                      )# end tab items
                    ) # end body
)





