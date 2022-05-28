library(ggplot2)
library(plotly)
library(dplyr)

climate_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

# use for summ tab
china_data <- climate_df %>% filter(country == "China")
# since Chinese data only from 1899, so make them consistence.
american_data <- climate_df %>% filter(country == "United States", year >= 1899)

server <- function(input, output) {
  output$co2_plot <- renderPlotly({
    filtered_df <- climate_df %>%
      filter(country %in% input$country_selection) %>%
      filter(year >= input$year_selection[1] & 
               year <= input$year_selection[2])

    plot1 <- ggplot(data = filtered_df) +
      geom_line(mapping = aes(x = year, y = co2, color = country)) + 
      labs(title = "Co2 vs. Year", y = "Co2 in million tonnes")
    return(plot1)
  })
  
  output$type_emit_plot <- renderPlotly({
    filtered_df <- climate_df %>%
      filter(country ==  "United States" | country ==  "China")
    plot_title <- paste("Co2 emit from", gsub("_.*", "", input$type_selection)) 
                        
    # since user select value is string and can't pass into ggplot, so I change corresponding column so I can have control over. 
    colnames(filtered_df)[which(names(filtered_df) == input$type_selection)] <- "new_col"
    plot2 <- ggplot(data = filtered_df) +
      geom_line(mapping = aes(x = year, y = new_col, color = country)) + 
      labs(title = plot_title, y = "Co2 in million tonnes")
    return(plot2)
  })
  

  output$table_china <- renderTable({
    # get change of co2 emit for each year
    china_data <- china_data %>% 
      arrange(year) %>% mutate(change = co2 - lag(co2))
    top5_change_china <- china_data %>%
      arrange(desc(change)) %>% slice(1:5) %>% select(year, co2, change)
    
    american_data <- american_data %>%
      arrange(year) %>% mutate(change = co2 - lag(co2))
    top5_change_us <- american_data %>%
      arrange(desc(change)) %>% slice(1:5) %>% select(year, co2, change)
    return(top5_change_china)
  })
  
  output$table_us <- renderTable({
    # get change of co2 emit for each year
    american_data <- american_data %>%
      arrange(year) %>% mutate(change = co2 - lag(co2))
    top5_change_us <- american_data %>%
      arrange(desc(change)) %>% slice(1:5) %>% select(year, co2, change)
    return(top5_change_us)
  })

  output$avg_co2 <- renderText({
    avg_ch <- china_data %>% summarise(avg = mean(co2, na.rm = TRUE)) %>% pull(avg)
    avg_us <- american_data %>% summarise(avg = mean(co2, na.rm = TRUE)) %>% pull(avg)
    msg <- paste("Chinese average co2 emit from 1899 is", avg_ch, "U.S average co2 emit from 1899 is", avg_us)
    return(msg)
  })
  
}
