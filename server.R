library(ggplot2)
library(plotly)
library(dplyr)

heart_df <- read.csv("heart.csv", stringsAsFactors = FALSE)
heart_df <- na.omit(heart_df)


have_disease <- heart_df %>% filter(HeartDisease == "Yes")
no_disease <- heart_df %>% filter(HeartDisease == "No")

# get number of rows in order to calculate percentage.
total_have_disease = nrow(have_disease)
total_no_disease = nrow(no_disease)

server <- function(input, output) {
  output$factor_plot <- renderPlotly({
    # For people have heart disease, see the count of having given factor or not
    factor_have_disease <- have_disease %>% 
      group_by_at(input$factor_selection) %>%
      summarise(count_have_disease = n())
    
    # For people do not have heart disease, see the count of having given factor or not
    factor_no_disease <- no_disease %>% 
      group_by_at(input$factor_selection) %>% 
      summarise(count_no_disease = n())
    
    # Join two data together and calculate the percentage
    all_df <- factor_have_disease %>% 
      left_join(factor_no_disease, by=input$factor_selection) %>%
      mutate(all_count = count_have_disease + count_no_disease,
             have_disease_percentage = 
               count_have_disease / all_count * 100,
             no_disease_percentage =  
               count_no_disease / all_count * 100)
    
    selected_df <- all_df %>% 
      select(input$factor_selection,
             "have_disease_percentage",
             "no_disease_percentage")
    
    pivot_df <- selected_df %>% 
      pivot_longer(!c(input$factor_selection), 
                   names_to = "category",
                   values_to = "percentage")
    
    # since user select value is string and can't pass into ggplot, so I change corresponding column so I can have control over. 
    colnames(pivot_df)[which(names(pivot_df) == input$factor_selection)] <- "factor_condition"
    
    plot1 <- ggplot(pivot_df, aes(fill=category, 
                         x=factor_condition,
                         y=percentage)) +
      geom_bar(position="dodge", stat="identity") +
      labs(title = paste("Relationship between", 
                         input$factor_selection,
                         "And Heart Disease"), 
           x = input$factor_selection, 
           y = "Percentage")
    return(plot1)
  })
  
  output$age_gender_plot <- renderPlotly({
    filtered_df <- heart_df %>%
      filter(Sex == input$gender_selection) %>%
      filter(AgeCategory %in% input$age_selection) 
    
    # Get total amount of people in each age group in order to calculate percentage
    total_count <- filtered_df %>% group_by(AgeCategory) %>% 
      summarise(total = n())
    
    category_count <- filtered_df %>% 
      group_by(AgeCategory, HeartDisease) %>% 
      summarise(count_type = n())
    
    plot_data <- category_count %>% 
      left_join(total_count, by="AgeCategory") %>% 
      mutate(percentage = count_type / total * 100)

    plot2 <- ggplot(data = plot_data,
                    aes(x = AgeCategory, 
                        y = percentage,
                        color = HeartDisease,
                        group=1)) +
      geom_point() + geom_line()
      labs(title = "How does heart disease relate to age and sex",
           x = "age category")
    return(plot2)
  })
  
  
}
