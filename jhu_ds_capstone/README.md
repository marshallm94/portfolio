# PredictR
#### About

PredictR is my word prediction application built as the capstone project of the
John Hopkins University Data Science Specialization on Coursera.org. This was
the culmination of a series of nine courses, providing a great introduction to
Data Science. All [10 courses](https://www.coursera.org/specializations/jhu-data-science)
took me a little under one year to complete. While the presentation below gives
some specifics on the the algorithm I used and the performance of the
application, A general outline of the project is as follows:

1. **Learn Natural Language Processing (NLP)** - Initially a frustration, later
turning into an appreciation for the mental skillset the instructors were
teaching, the first step in the project was gaining a basic understanding of
NLP. None of the nine previous courses covered this topic, so obtaining a basic
understanding of the concepts in NLP that are necessary for word prediction was
imperative.

2. **Cleaning the data** - The data set consisted of three large text files
(roughly 4 millions lines of text total), all in english. Due to computational
constraints of the machine I used, combining and using a 0.25 sample was
necessary. After removing profanity from the data set, I tokenized and moved on
to my algorithm.

3. **Stupid Backoff** - The detail of the algorithm I used can be found in the
presentation below, however a very rough overview would be that we can predict
the next word in a sequence of words based on the previous *n* words, with
(generally) increasing accuracy as *n* increases.

4. **Shiny Application** - The final step was incorporating all of the above
into a Shiny application, the link for which can be found below. This was a
little more complex than simply converting each of the scripts into an
application-compatible format, since speed was a key goal. Using data tables
brought my processing time down tremendously, although I know further
improvements could be made.

The RPubs presentation for the project can be found [here](http://rpubs.com/marshallm94/343846).

The Shiny Application can be found [here](https://marshallm94.shinyapps.io/Word_Prediction/).
