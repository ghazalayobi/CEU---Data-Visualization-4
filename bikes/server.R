
library(shiny)
library(shinyWidgets)
library(data.table)
library(DT)
library(ggplot2)
library(plotly)
library(dplyr)
library(lubridate)
library(viridis)
library(remotes)
library(tidyverse)

source('global.R')
library(collapsibleTree)


# reading the data ####################
df <- read.csv("https://raw.githubusercontent.com/ghazalayobi/CEU-Data-Visualization-4/main/data/Sales.csv")
df <- na.omit(df) %>% filter()
df$Date <- ymd(df$Date)


countries <- unique(df$Country)
product_cat <- unique(df$Product_Category)
sub_cat <- unique(df$Sub_Category)
gender <- unique(df$Customer_Gender)
age_group <- unique(df$Age_Group)
pro_sub_cat <- unique(df$Sub_Category)



shinyServer(function(input, output, session) {
  
  
  # filtering ##########################
  
  get_data_by_year <- function(type, subtype, gender_1, countryof, min_revenue, max_revenue, min_age, max_age,
                               min_date, max_date) {
    my_data <- filter(df, 
                      Product_Category %in% type,
                      Sub_Category %in% subtype, 
                      Customer_Gender %in% gender_1,
                      Country %in% countryof,
                      Revenue >= min_revenue, Revenue <= max_revenue,
                      Customer_Age >= min_age, Customer_Age <= max_age,
                      Date >= ymd(min_date), Date <= ymd(max_date)
                      
                      
    )
    return(my_data)
  }
  
  #####################################
  
  my_reactive_df <- reactive({
    df_1 <- get_data_by_year(input$product_category, input$sub_cat, input$gender, input$country, input$revenue_range[1], input$revenue_range[2], 
                             input$age[1], input$age[2], input$date_range[1], input$date_range[2])
    return(df_1)
  })
  
  # filters button ####################
  
  observeEvent(input$button_reset,{
    updateCheckboxGroupInput(session, "product_category", selected = product_cat)
    updatePickerInput(session, "sub_cat", selected = pro_sub_cat)
    updatePickerInput(session, "country", selected = countries)
    updateSliderInput(session, "revenue_range", value = c(0, ceiling(max(df$Revenue))))
    updateSliderInput(session, "age", value = c(17, ceiling(max(df$Customer_Age))))
    updateCheckboxGroupInput(session, "gender", selected = gender)
    updateSliderInput(session, "date_range", value = c(as.Date("2011-01-01"), as.Date("2016-07-31")))
    
  })
  
  ### Info Boxes  ########################
  output$rev_acc_info <- renderInfoBox({
    infoBox(
      title = 'Accessories Total Revenue',
      value = paste0(sum(df[which(my_reactive_df()$Product_Category == "Accessories"), 'Revenue']), " $"),
      icon = icon('gear', lib = 'font-awesome'),
      color = 'purple'
    )
  })
  
  output$rev_bikes_info <- renderInfoBox({
    infoBox(
      title = 'Bikes Total Revenue',
      value = paste0(sum(df[which(my_reactive_df()$Product_Category == "Bikes"), 'Revenue']), " $"),
      icon = icon('bicycle'),
      color = 'olive'
    )
  })
  
  output$rev_clothing_info <- renderInfoBox({
    infoBox(
      title = 'Clothing Total Revenue',
      value = paste0(sum(df[which(my_reactive_df()$Product_Category == "Clothing"), 'Revenue']), " $"),
      icon = icon('tshirt'),
      color = 'blue'
    )
  })
  
  
  ### Plots ########################
  
  
  # plotting date and product category
  output$year_dist_plot <- renderPlotly({
    get_freqpoly(my_reactive_df(), my_reactive_df()$Date, my_reactive_df()$Product_Category) +
      labs(y = 'Count', x = 'Date', title = 'Products Distribution per Year', color = 'Product Category')
  })
  
  # plotting date and product category
  output$density_plot <- renderPlotly({
    get_density(my_reactive_df(), my_reactive_df()$Date, my_reactive_df()$Product_Category) +
      labs(y = 'Density', x = 'Date', title = 'Density Distribution of Product Category', fill = 'Product Category')
    
  })
  
  
  # plotting country info, revenue and product category
  output$country_rev_plot <- renderPlotly({
    get_bar(my_reactive_df(), my_reactive_df()$Country, my_reactive_df()$Revenue, my_reactive_df()$Product_Category) +
      labs(y = 'Revenue', x = 'Country', title = 'Revenue Distribution Per Country and Product Category', fill = 'Product Category')
    
  })
  
  # plotting customer age and customer gender data
  output$age_gender_plot <- renderPlotly({
    get_hist(my_reactive_df(), my_reactive_df()$Customer_Age, my_reactive_df()$Customer_Gender) +
      labs(y = 'Count', x = 'Age', title = 'Customer Age Distribution', fill = 'Gender')
    
  })
  
  ########## Collapsible Tree from htmlwidgets.org
  output$my_tree <- collapsibleTree::renderCollapsibleTree({
    collapsibleTree(my_reactive_df(), c("Product_Category", "Sub_Category" ), root = "Products", collapsed = FALSE, 
                    fill = c("#440154", rep("#21918c", 3), rep("#fde725", 17)))
    
  })
  
  ########## Data table from htmlwidgets.org
  output$my_data <- DT::renderDataTable({
    my_reactive_df()
  })
  
})
