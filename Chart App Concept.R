library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Chart Generator Concept"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File", accept = ".csv"),
      selectInput("x_var", "Select X Variable", choices = NULL),
      selectInput("y_var", "Select Y Variable", choices = NULL),
      actionButton("save_plot", "Save Plot")
    ),
    mainPanel(
      plotOutput("plot"),
      downloadButton("download_plots", "Download All Plots"),
      tableOutput("saved_combinations")  # Added table to display saved combinations
    )
  )
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  saved_combinations <- reactiveValues(combinations = data.frame(x_var = character(), y_var = character()))  # Initialize empty data frame
  
  observe({
    updateSelectInput(session, "x_var", choices = names(data()))
    updateSelectInput(session, "y_var", choices = names(data()))
  })
  
  observeEvent(input$save_plot, {
    req(input$x_var, input$y_var)
    plot <- ggplot(data(), aes_string(x = input$x_var, y = input$y_var)) +
      geom_point()
    saved_combinations$combinations <- rbind(saved_combinations$combinations, data.frame(x_var = input$x_var, y_var = input$y_var))  # Add new combination to data frame
  })
  
  output$plot <- renderPlot({
    req(input$x_var, input$y_var)
    ggplot(data(), aes_string(x = input$x_var, y = input$y_var)) +
      geom_point()
  })
  
  output$download_plots <- downloadHandler(
    filename = "plots.zip",
    content = function(file) {
      temp_dir <- tempdir()
      for (i in seq_along(saved_combinations$combinations)) {
        combination <- saved_combinations$combinations[i, ]
        plot <- ggplot(data(), aes_string(x = combination$x_var, y = combination$y_var)) +
          geom_point()
        filename <- paste0("plot_", i, ".png")
        filepath <- file.path(temp_dir, filename)
        ggsave(filepath, plot)
      }
      zip::zipr(zipfile = file, files = list.files(temp_dir, full.names = TRUE))
    }
  )
  
  output$saved_combinations <- renderTable({
    saved_combinations$combinations
  })
}

shinyApp(ui, server)

