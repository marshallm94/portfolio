source("/Users/marsh/data_science_coursera/JHU_capstone/setup.R")

# recall variables from setup.R
## total_word
## total_bigram
## total_trigram
## total_quadgram
## total_quintgram

# remove non-english words from all data sets
remove_non_english <- function(x) {
    english <- NULL
    for (i in letters) {
        letter <- grep(i, x[[2]])
        english <- c(english, letter)
    }
    english <- unique(english)
    x[english,]
}

word_df <- remove_non_english(total_word)
bigram_df <- remove_non_english(total_bigram)
trigram_df <- remove_non_english(total_trigram)
quadgram_df <- remove_non_english(total_quadgram)
quintgram_df <- remove_non_english(total_quintgram)

# remove stop words from word_df only
word_df <- anti_join(word_df, stop_words)

ordered_word <- count(word_df, word, sort = TRUE)
ordered_bigram <- count(bigram_df, ngram, sort = TRUE)
ordered_trigram <- count(trigram_df, ngram, sort = TRUE)
ordered_quadgram <- count(quadgram_df, ngram, sort = TRUE)
ordered_quintgram <- count(quintgram_df, ngram, sort = TRUE)

add_tf <- function(x) {
    y <- sum(x$n)
    x <- mutate(x, term_freq = n/y)
    x
}

# in order to improve performance, will reduce the data sets to only those 
# tokens/ngrams that have a minimum count. (Since the count/term-frequence is so
# low, the probability of my model choosing those ngrams is rather low, therefore
# keeping them in the data set is a waste of memory)
ordered_word <- subset(ordered_word, n >= quantile(ordered_word$n, probs = 0.90))
ordered_bigram <- subset(ordered_bigram, n >= quantile(ordered_bigram$n, probs = 0.90))
ordered_trigram <- subset(ordered_trigram, n >= quantile(ordered_trigram$n, probs = 0.90))
ordered_quadgram <- subset(ordered_quadgram, n >= quantile(ordered_quadgram$n, probs = 0.90))
ordered_quintgram <- subset(ordered_quintgram, n >= quantile(ordered_quintgram$n, probs = 0.90))

# remove non-total data sets to free RAM
rm(
    blog_df, news_df, twitter_df,
    blog_bigram, news_bigram, twitter_bigram,
    blog_trigram, news_trigram, twitter_trigram,
    blog_quadgram, news_quadgram, twitter_quadgram,
    blog_quintgram, news_quintgram, twitter_quintgram
)

# enter test sentence here
a <- "You're the reason why I smile everyday. Can you follow me please? It would mean the"
#########################

sentence_to_word <- function(x) {
    df <- as_data_frame(x)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = word, text, token = 'words')
    df3
}

sentence_to_ngram <- function(x, n) {
    df <- as_data_frame(x)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = ngram, text, token = 'ngrams', n = n)
    df3
}

word_test <- sentence_to_word(a)
bigram_test <- sentence_to_ngram(a, n = 2)
trigram_test <- sentence_to_ngram(a, n = 3)
quadgram_test <- sentence_to_ngram(a, n = 4)

word_fragment <- word_test[nrow(word_test), 2]
bigram_fragment <- bigram_test[nrow(bigram_test), 2]
trigram_fragment <- trigram_test[nrow(trigram_test), 2]
quadgram_fragment <- quadgram_test[nrow(quadgram_test), 2]

search_bigram <- paste("^", word_fragment, " ", sep = "")
search_trigram <- paste("^", bigram_fragment, " ", sep = "")
search_quadgram <- paste("^", trigram_fragment, " ", sep = "")
search_quintgram <- paste("^", quadgram_fragment, " ", sep = "")

# remove non-essential data sets to free up RAM
rm(word_fragment, word_test,
   bigram_fragment, bigram_test,
   trigram_fragment, trigram_test,
   quadgram_fragment, quadgram_test,
   quintgram_fragment, quintgram_test)

fragment_search <- function(x, y) {
    indices <- grep(x, y[[1]])
    df_dist <- y[indices,]
    topx <- df_dist[1:10,]
    topx
}

quint_match <- fragment_search(search_quintgram, ordered_quintgram)
quad_match <- fragment_search(search_quadgram, ordered_quadgram)
tri_match <- fragment_search(search_trigram, ordered_trigram)
bi_match <- fragment_search(search_bigram, ordered_bigram)




# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences for weight

