#Load Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(tidytext))


setwd('/Users/marsh/data_science_coursera/data/final/en_US/')

# read in entire blog, news and twitter text files
getfile <- function(text_source){
    x <- grep(text_source, list.files())
    con <- file(list.files()[x], "r")
    y <- readLines(con, skipNul = TRUE)
    close(con)
    y
}

blog <- getfile("blog")
news <- getfile("news")
twitter <- getfile("twitter")

setwd('/Users/marsh/data_science_coursera/capstone/')

# tokenize each text source by word, then combine
word_token <- function(y) {
    x <- sample(1:length(y), 10000)
    z <- y[x]
    df <- as_data_frame(z)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = word, text, token = 'words')
    df3
}

blog_df <- word_token(blog)
news_df <- word_token(news)
twitter_df <- word_token(twitter)

total_word <- rbind(blog_df, news_df, twitter_df)

# tokenize each text source by bigram and trigram, then combine
ngram_token <- function(y, number = 2) {
    x <- sample(1:length(y), 10000)
    z <- y[x]
    df <- as_data_frame(z)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = ngram, text, token = 'ngrams', n = number)
    df3
}

blog_bigram <- ngram_token(blog)
news_bigram <- ngram_token(news)
twitter_bigram <- ngram_token(twitter)

total_bigram <- rbind(blog_bigram, news_bigram, twitter_bigram)

blog_trigram <- ngram_token(blog, n = 3)
news_trigram <- ngram_token(news, n = 3)
twitter_trigram <- ngram_token(twitter, n = 3)

total_trigram <- rbind(blog_trigram, news_trigram, twitter_trigram)
