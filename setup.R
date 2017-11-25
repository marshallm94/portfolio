#Load Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(tidytext))


setwd('/Users/marsh/data_science_coursera/data/final/en_US/')

# read in entire blog, news and twitter text files
getfile <- function(text_source) {
    x <- grep(text_source, list.files())
    con <- file(list.files()[x], "r")
    y <- readLines(con, skipNul = TRUE)
    close(con)
    y
}

blog <- getfile("blog")
news <- getfile("news")
twitter <- getfile("twitter")

setwd('/Users/marsh/data_science_coursera/JHU_capstone/')

# tokenize function that samples 100,000 lines
word_token <- function(y) {
    x <- sample(1:length(y), 100000)
    z <- y[x]
    df <- as_data_frame(z)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = word, text, token = 'words')
    df3
}

# tokenize each source then combine into one
blog_df <- word_token(blog)
news_df <- word_token(news)
twitter_df <- word_token(twitter)

total_word <- rbind(blog_df, news_df, twitter_df)

# tokenize to ngram function that smaples 100,000 lines
ngram_token <- function(y, n = 2) {
    x <- sample(1:length(y), 100000)
    z <- y[x]
    df <- as_data_frame(z)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = ngram, text, token = 'ngrams', n = n)
    df3
}

# bigram for each source then combine into one
blog_bigram <- ngram_token(blog)
news_bigram <- ngram_token(news)
twitter_bigram <- ngram_token(twitter)

total_bigram <- rbind(blog_bigram, news_bigram, twitter_bigram)

# trigram each source then combine into one
blog_trigram <- ngram_token(blog, n = 3)
news_trigram <- ngram_token(news, n = 3)
twitter_trigram <- ngram_token(twitter, n = 3)

total_trigram <- rbind(blog_trigram, news_trigram, twitter_trigram)

# quadgram each source then combine into one
blog_quadgram <- ngram_token(blog, n = 4)
news_quadgram <- ngram_token(news, n = 4)
twitter_quadgram <- ngram_token(twitter, n = 4)

total_quadgram <- rbind(blog_quadgram, news_quadgram, twitter_quadgram)

# quintgram each source then combine into one
blog_quintgram <- ngram_token(blog, n = 5)
news_quintgram <- ngram_token(news, n = 5)
twitter_quintgram <- ngram_token(twitter, n = 5)

total_quintgram <- rbind(blog_quintgram, news_quintgram, twitter_quintgram)

# remove non-total data sets to free RAM
rm(
    blog_df, news_df, twitter_df,
    blog_bigram, news_bigram, twitter_bigram,
    blog_trigram, news_trigram, twitter_trigram,
    blog_quadgram, news_quadgram, twitter_quadgram,
    blog_quintgram, news_quintgram, twitter_quintgram
)