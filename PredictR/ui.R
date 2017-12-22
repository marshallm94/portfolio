library(shiny)
suppressPackageStartupMessages(library(shinythemes))
shinyUI(
    fluidPage(theme = shinytheme("cyborg"),
        tabsetPanel(
            tabPanel("PredictR",
                    fixedRow(
                        column(12, align = "center",
                            titlePanel("PredictR"),
                                column(12, align = "center",
                                    p("1. Select the number of words you would like
                                      predicted from the drop down menu,"),
                                    p("2. Enter your sentence into the text box below,"),
                                    p("3. Click go and the predicted word(s)
                                      will appear below."),
                                    selectInput("dropdown",
                                                 "Number of Words",
                                                 choices = c(0:10),
                                                 selected = 0)
                                ),
                        column(12, align = "center",
                                     textInput("ngram",
                                               "Enter text here",
                                               placeholder = "Once upon a time"),
                                     submitButton("Go"),
                                     br(),
                                     tableOutput("prediction")
                        )
                        )
                    )
            ),
            tabPanel("Documentation",
                     br(),
                     h3("Introduction"),
                     p("PredictR is my word prediction application for the Capstone
                       project of the John Hopkins University Data Science Specialization
                       on Coursera."),
                     h4("Data"),
                     p("Since this assignment was only intended to support the english
                        language, only the english versions of the blog, news and
                        twitter data sets were used, all of which can be found in
                        the 'en_US' subdirectory after downloading the",
                       a("Coursera SwiftKey Data set.",
                         href = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")),
                     p("The list of profane words I used to filter out of the data 
                       set can be downloaded",
                       a("here.", href =  "https://www.frontgatemedia.com/new/wp-content/uploads/2014/03/Terms-to-Block.csv")),
                     h3("Prediction Algorithm"),
                     p("My application utilizes an ngram prediction algorithm called 'Stupid Backoff,'
                       the details of which can be found in",
                     a("this paper.", href = "http://www.aclweb.org/anthology/D07-1090.pdf"),
                       "The general concept is that whenever the user enters a sequence of words 
                       (referred to as an 'ngram,' where n = the number of words)
                        into the text box, my app takes the last 5 words in the
                        sequence and searches the data set for matches. If a match
                        is found, the model outputs the next word in the sequence
                        where the match was found. If a match is not found, the
                        model goes 'down' one level and takes the last 4 words in
                        the text box and searches for matches to that sequence,
                        and returns the next word if any matches are found. This
                        process continues from 6 word sequences (sextagrams) down
                        to 2 word sequences (bigrams). If no matches are found to
                        any of the ngrams, the model outputs the most common single word(s) in the data set."),
                     p("While the actual algorithm gives each prediction a score 
                       and then sorts all the possible predictions in descending 
                       order according to their respecitve scores, I decided to 
                       remove the score from the output, since the end user will 
                       not care about that information, only about the next predicted word.")
                     )
            
        )
    )
)
