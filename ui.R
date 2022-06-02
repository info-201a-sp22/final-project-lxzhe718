library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(markdown)
library(tidyr)

heart_df <- read.csv("heart.csv", stringsAsFactors = FALSE)
my_theme <- bs_theme() 
my_theme <- bs_theme_update(my_theme, bootswatch = "sandstone", font_scale = 1.3, bg = "#f5f6fd", fg = "black") %>% bs_add_rules(sass::sass_file("my_style.scss"))

# Home page tab
intro_tab <- tabPanel(
  # Title of tab
  "Introduce to final project",
  fluidPage(
    includeMarkdown("introduce.md")
  )
)

# Create sidebar panel for widget
first_widget <- sidebarPanel(
  selectInput(
    inputId = "factor_selection",
    label = "Choice the factor to see if it has correlation with heart desease",
    choices = c("Smoking", "Drinknig alcohol" = "AlcoholDrinking",
                "Stroke", "Diabetic", "Asthma",
                "Kidney disease" = "KidneyDisease"),
    selected = "Smoking"
    )
)

first_plot <- mainPanel(
  plotlyOutput(outputId = "factor_plot")
)

first_tab <- tabPanel(
  "Heart disease's factors",
  sidebarLayout(
    first_widget,
    first_plot
  ),
  p("the graph is conducted to explore the correlation bewteen people with or without heart disease and their heart disease indicators. The population is splited into two categories pf people(heart disease and no heart diesease) The users are able to choose which factor they want to study specific. By choosing given factor, the graph will show the percentage of heart disease and compare the two groups of people.")
)

second_widget <- sidebarPanel(
  selectInput(
    inputId = "gender_selection",
    label = "Choice a gender",
    choices = unique(heart_df$Sex),
    selected = "Male"
  ),
  checkboxGroupInput(
    inputId = "age_selection",
    label = "Choice the age range",
    choices = c("18-24", "25-29", "30-34", "35-39", "40-44", 
                "45-49", "50-54","55-59", "60-64", "65-69",
                "70-74", "75-79", "80 or older"),
    selected = c( "35-39", "40-44", "45-49", "50-54","55-59", "60-64")
  )
)

second_plot <- mainPanel(
  plotlyOutput(outputId = "age_gender_plot")
)

second_tab <- tabPanel(
  "Gender & Age",
  sidebarLayout(
    second_widget,
    second_plot
  ),
  p("This visualization shows how age and gender relate to heart disease. From the graph, we can see that as the age increases, the percentage of people who getting heart disease is increasing. Interestingly, the rate of heart disease increase more among men than woman and men have higher rate of getting heart disease.")
)


third_widget <- sidebarPanel(
  sliderInput(inputId ="hour_selection",
              label = h3("Sleep Hours"), 
              min = min(heart_df$SleepTime), 
              max = max(heart_df$SleepTime), 
              value = c(2, 16))
)

third_plot <- mainPanel(
  plotlyOutput(outputId = "sleep_hour_plot")
)

third_tab <- tabPanel(
  "Sleep Hours",
  sidebarLayout(
    third_widget,
    third_plot
  ),
  p("The main goal of this chart is to explore the relationship between average sleep hours and the chances of getting heart disease. The percentages presented above were calculated by using the number of people who got heart disease to devide by total number of people in each sleep hour category. Regardless of the abnormal data (more tha 16 hours or less than 2 hours), the graph shows that there are slightly more chances to get heart disease if people sleep more than 9 hours or less than 5 hours.If the abnormal datas are included, the graph shows an unstable trend with the factor of sleep hours. One hypothesis of the phenomenon is that, for people who sleeps more than 20, heart disease might be the causes of drowsiness instead of the result.")
)

# Conclusion/Summary page

con_tab <- tabPanel( 
  "Conclusion/Summary",
  fluidPage(
    includeMarkdown("conclusion.md")
  )
)


ui <- navbarPage(
  theme = my_theme,
  "Final Project",
  intro_tab,
  first_tab,
  second_tab,
  third_tab,
  con_tab
)

