library(plotly)

heart_df <- read.csv("heart.csv", stringsAsFactors = FALSE)

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
    inputId = "factor_selection",
    label = "Choice the factor to see if it has correlation with heart desease",
    choices = c("Smoking", "Drinknig alcohol" = "AlcoholDrinking",
                "Stroke", "Diabetic", "Asthma",
                "Kidney disease" = "KidneyDisease"),
    selected = "Smoking"
  )
)

second_plot <- mainPanel(
  plotlyOutput(outputId = "factor_plot")
)
second_tab <- tabPanel(
  "Heart disease's factors",
  sidebarLayout(
    second_widget,
    second_plot
  ),
  p("add decription here")
)


third_widget <- sidebarPanel(

)

third_plot <- mainPanel(
  plotlyOutput(outputId = "factor_plot")
)
third_tab <- tabPanel(
  "Heart disease's factors",
  sidebarLayout(
    third_widget,
    third_plot
  ),
  p("add decription here.")
)

ui <- navbarPage(
  # Home page title
  "A5: Co2 emission",
  intro_tab,
  second_tab,
  third_tab
)
