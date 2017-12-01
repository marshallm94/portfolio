#Load Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(quanteda))

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

blog_toks <- tokens(blog, remove_numbers = TRUE,
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_hyphens = TRUE,
                    remove_url = TRUE)
news_toks <- tokens(news, remove_numbers = TRUE,
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_hyphens = TRUE,
                    remove_url = TRUE)
twitter_toks <- tokens(twitter, remove_numbers = TRUE,
                       remove_punct = TRUE,
                       remove_symbols = TRUE,
                       remove_hyphens = TRUE,
                       remove_url = TRUE)

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

test_toks <- blog_toks[1:10000]
test_splits <- blog_splits

iterate_token <- function(x, y, n) {
    x <- test_splits
    y <- test_toks
    n <- 2
    dts<- NULL
    for (i in 1:nrow(x)) {
        name <- as.character(x[i,1])
        len <- as.integer(x[i,2]):as.integer(x[i,3])
        z <- tokens_ngrams(y, n = n, concatenator = " ")
        dt <- data.table(name = name, tokens = z)
        print(paste(name, "complete...", sep = " "))
        dts <- rbind(dts, dt)
    }
    dts
}

create_token <- function(x, n) {
    y <- tokens_ngrams(x, n = n, concatenator = " ")
    total_gram <- NULL
    for (i in 1:length(y)) {
        a <- as.character(y[i])
        dt <- data.table(line = rep(i, length(a)), token = a)
        total_gram <- rbind(total_gram, dt)
    }
    total_gram
}

total_blog_bigram <- NULL
for (i in 1:nrow(blog_splits)) {
    len <- as.integer(blog_splits[i,2]):as.integer(blog_splits[i,3]) 
    name <- as.character(blog_splits[i,1])
    blog_tokens <- create_token(blog_toks[len], 2)
    total_blog_bigram <- rbind(total_blog_bigram, blog_tokens)
    print(paste(name, "complete...", sep = " "))
}


blog_dts <- iterate_token(blog_splits, blog)
news_dts <- iterate_token(news_splits, news)
twitter_dts <- iterate_token(twitter_splits, twitter)



# unigram
uni_blog <- tokens_ngrams(blog_toks, n = 1)
uni_news <- tokens_ngrams(news_toks, n = 1)
uni_twitter <- tokens_ngrams(twitter_toks, n = 1)

# bigram
bi_blog <- tokens_ngrams(blog_toks, n = 2)
bi_news <- tokens_ngrams(news_toks, n = 2)
bi_twitter <- tokens_ngrams(twitter_toks, n = 2)

# trigram
tri_blog <- tokens_ngrams(blog_toks, n = 3)
tri_news <- tokens_ngrams(news_toks, n = 3)
tri_twitter <- tokens_ngrams(twitter_toks, n = 3)

# quadgram
quad_blog <- tokens_ngrams(blog_toks, n = 4)
quad_news <- tokens_ngrams(news_toks, n = 4)
quad_twitter <- tokens_ngrams(twitter_toks, n = 4)

# quintgram
quint_blog <- tokens_ngrams(blog_toks, n = 5)
quint_news <- tokens_ngrams(news_toks, n = 5)
quint_twitter <- tokens_ngrams(twitter_toks, n = 5)


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
