#Load Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(quanteda))
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

# split each corpus into 10 quantiles
split_corpus <- function(x) {
    breaks <- quantile(1:length(x), probs = seq(0, 1, 0.05))
    breaks <- as.numeric(round(breaks))
    splits <- 1:(length(breaks) - 1)
    splits_df <- NULL
    for (i in splits) {
        current_name <- paste("Partition", i, sep = "_")
        if (i == 1) {
            #current_name <- paste("Partition", i, sep = "_")
            current_length <- breaks[i:(i + 1)]
            
        } else {
            #current_name <- paste("Partition", i, sep = "_")
            a <- breaks[i] + 1
            b <- breaks[(i + 1)]
            current_length <- c(a,b)
        }
        current_df <- data.table(data_partition = current_name,
                                 start = current_length[1],
                                 stop = current_length[2])
        splits_df <- rbind(splits_df, current_df)
    }
    splits_df
}

blog_splits <- split_corpus(blog)
news_splits <- split_corpus(news)
twitter_splits <- split_corpus(twitter)

test <- blog
bing <- tokens(test)
bong <- tokens_ngrams(bing, 2, concatenator = " ")
bong

setwd('/Users/marsh/data_science_coursera/JHU_capstone/')

create_df <- function(x) {
    df <- as_data_frame(x)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df2
}

blog <- create_df(blog)
news <- create_df(news)
twitter <- create_df(twitter)






word_token <- function(y) {
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
