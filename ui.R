library(plotly)
library(bslib)
library(markdown)

heart_df <- read.csv("heart.csv", stringsAsFactors = FALSE)

# Update BootSwatch Theme
my_theme <- bs_theme_update(my_theme, bootswatch = "minty")

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
  p("Detecting and preventing the factors that have the greatest impact on heart disease is very important in healthcare. So this page shows if a factor have correlation wirh heart disease. By choosing given factor, the graph will show the percentage of heart disease and whether have the factor or not.")
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
  p("This visualization shows how age and gender relate to heart disease. From the graph, we can see that as the age increase, the percentage of people who getting heart disease in increasing. So their is some relationship between age and heart disease. Interestingly, the rate of heart disease increase more among men than woman and men have higher rate of getteing heart disease.")
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

ui <- navbarPage(
  # Home page title
  "Final Project",
  intro_tab,
  first_tab,
  second_tab,
  third_tab
)

