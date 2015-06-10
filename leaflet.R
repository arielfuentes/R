library(shiny)
ui <- fluidPage(
  leafletOutput("mymap"),
  p()
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet(data = s) %>% addTiles() %>%
      addMarkers(~x, ~y, popup = "a")
  })
}

shinyApp(ui, server)
