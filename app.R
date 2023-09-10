library(shiny)
library(ggplot2)

ui = fluidPage(
  titlePanel("Color Generator"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "color_input",
        label = "Choose Input Type:",
        choices = c("RGB", "Hex", "RGBA"),
        selected = "RGB"
      ),
      conditionalPanel(
        condition = "input.color_input == 'RGB'",
        numericInput(
          inputId = "red",
          label = "Red (0-255):",
          value = 0, min = 0, max = 255
        ),
        numericInput(
          inputId = "green",
          label = "Green (0-255):",
          value = 0, min = 0, max = 255
        ),
        numericInput(
          inputId = "blue",
          label = "Blue (0-255):",
          value = 0, min = 0, max = 255
        )
      ),
      conditionalPanel(
        condition = "input.color_input == 'Hex'",
        textInput(
          inputId = "hex",
          label = "Hex Code:",
          value = "#000000"
        )
      ),
      conditionalPanel(
        condition = "input.color_input == 'RGBA'",
        numericInput(
          inputId = "red_alpha",
          label = "Red (0-255):",
          value = 0, min = 0, max = 255
        ),
        numericInput(
          inputId = "green_alpha",
          label = "Green (0-255):",
          value = 0, min = 0, max = 255
        ),
        numericInput(
          inputId = "blue_alpha",
          label = "Blue (0-255):",
          value = 0, min = 0, max = 255
        ),
        numericInput(
          inputId = "alpha",
          label = "Alpha (0-1):",
          value = 1, min = 0, max = 1, step = 0.01
        )
      ),
      actionButton("generate_color", "Generate Color")
    ),
    mainPanel(
      plotOutput("color_display"),
      h4("Color Information:"),
      verbatimTextOutput("color_info")
    )
  )
)

server = function(input, output) {
  observeEvent(input$generate_color, {
    color = if (input$color_input == "RGB") {
      rgb(input$red, input$green, input$blue, maxColorValue = 255)
    } else if (input$color_input == "Hex") {
      input$hex
    } else {
      rgba(input$red_alpha, input$green_alpha, input$blue_alpha, input$alpha)
    }
    
    gg = ggplot() +
      geom_blank() +
      theme_void() +
      theme(plot.background = element_rect(fill = color))
    
    output$color_display = renderPlot({
      print(gg)
    })
    
    output$color_info = renderPrint({
      hex_color = tolower(color)
      rgb_color = col2rgb(color)
      cat("Hex Value:", hex_color,
            "\nRGB Value:", paste(rgb_color, collapse = ", "),
            "\nRGBA Value:", color)
    })
  })
}

shinyApp(ui, server)
