#Load Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(tidytext))
suppressPackageStartupMessages(library(data.table))

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

# split each corpus into 20 partitions
split_corpus <- function(x) {
    breaks <- quantile(1:length(x), probs = seq(0, 1, 0.05))
    breaks <- as.numeric(round(breaks))
    splits <- 1:(length(breaks) - 1)
    splits_df <- NULL
    for (i in splits) {
        current_name <- paste("Partition", i, sep = "_")
        if (i == 1) {
            current_length <- breaks[i:(i + 1)]
        } else {
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

# tokenize function that iterates through object
iterate_token <- function(x, y) {
    toks_dts <- NULL
    for (i in 1:nrow(x)) {
        name <- as.character(x[i,1])
        len <- as.integer(x[i,2]):as.integer(x[i,3])
        dt <- as.data.table(y[len])
        dt <- rename(dt, value = V1)
        dt2 <- mutate(dt, line = rownames(dt))
        dt2$line <- as.integer(dt2$line)
        dt2 <- select(dt2, line, value)
        dt2 <- rename(dt2, text = value)
        dt3 <- unnest_tokens(dt2, output = word, text, token = 'words')
        dt3 <- as.data.table(dt3)
        toks_dts <- rbind(toks_dts, dt3)
        print(paste(name, "complete...", sep = " "))
    }
    toks_dts
}

# tokenize each source then combine into one
blog_dt <- iterate_token(blog_splits, blog)
news_dt <- iterate_token(news_splits, news)
twitter_dt <- iterate_token(twitter_splits, twitter)

total_word <- rbind(blog_dt, news_dt, twitter_dt)

rm(blog_dt, news_dt, twitter_dt)

# tokenize to ngram function that iterates through object
iterate_ngram <- function(x, y, n) {
    toks_dts <- NULL
    for (i in 1:nrow(x)) {
        name <- as.character(x[i,1])
        len <- as.integer(x[i,2]):as.integer(x[i,3])
        dt <- as.data.table(y[len])
        dt <- rename(dt, value = V1)
        dt2 <- mutate(dt, line = rownames(dt))
        dt2$line <- as.integer(dt2$line)
        dt2 <- select(dt2, line, value)
        dt2 <- rename(dt2, text = value)
        dt3 <- unnest_tokens(dt2, output = word, text, token = 'ngrams', n = n)
        dt3 <- as.data.table(dt3)
        toks_dts <- rbind(toks_dts, dt3)
        print(paste(name, "complete...", sep = " "))
    }
    toks_dts
}

# bigram each source then combine into one
blog_bigram <- iterate_ngram(blog_splits, blog, 2)
news_bigram <- iterate_ngram(news_splits, news, 2)
twitter_bigram <- iterate_ngram(twitter_splits, twitter, 2)

total_bigram <- rbind(blog_bigram, news_bigram, twitter_bigram)

rm(blog_bigram, news_bigram, twitter_bigram)

# trigram each source then combine into one
blog_trigram <- iterate_ngram(blog_splits, blog, 3)
news_trigram <- iterate_ngram(news_splits, news, 3)
twitter_trigram <- iterate_ngram(twitter_splits, twitter, 3)

total_trigram <- rbind(blog_trigram, news_trigram, twitter_trigram)

rm(blog_trigram, news_trigam, twitter_trigram)

# quadgram each source then combine into one
blog_quadgram <- iterate_ngram(blog_splits, blog, 4)
news_quadgram <- iterate_ngram(news_splits, news, 4)
twitter_quadgram <- iterate_ngram(twitter_splits, twitter, 4)

total_quadgram <- rbind(blog_quadgram, news_quadgram, twitter_quadgram)

rm(blog_quadgram, news_quadgram, twitter_quadgram)

# quintgram each source then combine into one
blog_quintgram <- iterate_ngram(blog_splits, blog, 5)
news_quintgram <- iterate_ngram(news_splits, news, 5)
twitter_quintgram <- iterate_ngram(twitter_splits, twitter, 5)

total_quintgram <- rbind(blog_quintgram, news_quintgram, twitter_quintgram)

rm(blog_quintgram, news_quintgram, twitter_quintgram)

