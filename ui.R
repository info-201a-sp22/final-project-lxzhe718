library(plotly)

# Load climate data
climate_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

# Home page tab
intro_tab <- tabPanel(
  # Title of tab
  "Introduce to final project",
  fluidPage(
    includeMarkdown("introduce.md")
  )
)

summ_tab <- tabPanel(
  # Title of tab
  "Summary of the data",
  fluidPage(
    p("Chinese data"),
    tableOutput(outputId = "table_china"),
    p("US data"),
    tableOutput(outputId = "table_us"),
    textOutput(outputId = "avg_co2")
  )
)

# Create sidebar panel for widget
sidebar_panel_widget <- sidebarPanel(
  checkboxGroupInput(
    inputId = "country_selection",
    label = "Choice the filter country",
    choices = c("United States", "China"),
    selected = "China"
    ),
  sliderInput(
    inputId = "year_selection",
    label = h3("Choose Year range"),
    min = min(climate_df$year),
    max = max(climate_df$year),
    sep = "",
    value = c(2010, 2020)
  )
)

co2_year_plot <- mainPanel(
  plotlyOutput(outputId = "co2_plot")
)

co2_tab <- tabPanel(
  "Co2 Viz",
  sidebarLayout(
    sidebar_panel_widget,
    co2_year_plot
  ),
  p("This page shows how co2 emit change over year. The graph will give us direct comparison on co2 emit between China and U.S. From the graph, we can see U.S. have higher co2 emit until 2005 and their is a period in China that have huge increase of co2 emit from 2000")
)

type_emit_widget <- sidebarPanel(
  selectInput(
    inputId = "type_selection",
    label = h3("Choose source of Co2"),
    choices = c("Co2 from coal" = "coal_co2",
                "Co2 from flaring" =  "flaring_co2", 
                "Co2 from gas" =  "gas_co2",
                "Co2 from oil" = "oil_co2")
  )
)

type_plot <- mainPanel(
  plotlyOutput(outputId = "type_emit_plot")
)

emit_tab <- tabPanel(
  "Source of emit",
  sidebarLayout(
    type_emit_widget,
    type_plot
  ),
  p("This plot shows different source of co2, we can see in China, cole contribute huge amount of co2. In other aspect, U.S have higher amount.")
)

ui <- navbarPage(
  # Home page title
  "A5: Co2 emission",
  intro_tab,
  co2_tab,
  emit_tab,
  summ_tab
)
