library(shiny)
shinyUI(
    fluidPage(
        titlePanel("PredictR"),
        sidebarLayout(
            sidebarPanel(
                h3("Text Prediction"),
                p("PredictR is a text prediction app that takes a sequence of 
                  words as its input, and returns the next predicted word."),
                p("Simply enter your sentence into the text box to the right, hit
                  the space bar, and the next predicted word will appear.")
            ),
            mainPanel(
                textInput("ngram",
                          "Enter text here",
                          placeholder = "Once upon a time"),
                tableOutput("prediction")
            )
        )
    )
)
