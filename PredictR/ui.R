library(shiny)
shinyUI(
    fluidPage(
        tabsetPanel(
            tabPanel("PredictR",
                    titlePanel("PredictR"),
                    sidebarLayout(
                        sidebarPanel(
                             h3("Text Prediction"),
                             p("PredictR is a text prediction app that takes a sequence of 
                               words as its input, and returns the next predicted word."),
                             p("Simply select the number of words you would like predicted
                               from the drop down menu, enter your sentence into the text 
                               box to the right, and the predicted word(s) will appear."),
                             selectInput("dropdown",
                                         "Number of Words",
                                         choices = c(0:5),
                                         selected = 0)
                        ),
                        mainPanel(
                             textInput("ngram",
                                       "Enter text here",
                                       placeholder = "Once upon a time"),
                             submitButton("Go"),
                             br(),
                             tableOutput("prediction")
                        )
                    )
            ),
            tabPanel("Documentation",
                     br(),
                     h3("Introduction"),
                     p("PredictR is my word prediction application for the Capstone
                       project of the John Hopkins University Data Science Specialization
                       on Coursera."),
                     p("The data sets that form the basis of the application can be
                       downloaded here. (https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
                       Since this application is built in english, only the files 
                       in the en_US directory were used."),
                     p("The list of profane words I used to filter out of the data 
                       set can be found here. (https://www.frontgatemedia.com/new/wp-content/uploads/2014/03/Terms-to-Block.csv)
                       One note is that, while I understand the need to remove 
                       profanity from the text for the purpose of making the assignment
                       PG, if I were to build a similar app of my own free will, no
                       words would be removed."),
                     h3("Prediction Algorithm"),
                     p("My application utilizes an ngram prediction algorith called 'Stupid Backoff,'
                       the details of which can be found in this paper. (http://www.aclweb.org/anthology/D07-1090.pdf)
                       The general concept is that whenever the user enters a sequence of words 
                       (referred to as an 'ngram') into the text box, my app takes 
                       the last 5 words in the sequence and searches the data set 
                       for matches. If a match is found, the model outputs the 
                       next word in the data set where the match was found. If a 
                       match is not found, the model goes 'down' one level 
                       and takes the last 4 words in the text box and searches 
                       for matches to that sequence, and returns the next word if 
                       any matches are found. This process continues from 6 word 
                       sequences (sextagram) down to 2 word sequences (bigrams). 
                       If no matches are found to any of the ngrams, the model 
                       outputs the single most commond word(s) in the data set."),
                     p("While the actual algorithm gives each prediction a score 
                       and then sorts all the possible predictions in descending 
                       order according to their respecitve scores, I decided to 
                       remove the score from the output, since the end user will 
                       not care about that information.")
                     )
            
        )
    )
)
