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

# enter test sentence here
a <- "The man bought a bouquet and a case of"
#########################

word_test <- sentence_to_word(a)
bigram_test <- sentence_to_ngram(a, n = 2)
trigram_test <- sentence_to_ngram(a, n = 3)
quadgram_test <- sentence_to_ngram(a, n = 4)
quintgram_test <- sentence_to_ngram(a, n = 5)

word_fragment <- word_test[nrow(word_test), 2]
bigram_fragment <- bigram_test[nrow(bigram_test), 2]
trigram_fragment <- trigram_test[nrow(trigram_test), 2]
quadgram_fragment <- quadgram_test[nrow(quadgram_test), 2]
quintgram_fragment <- quintgram_test[nrow(quintgram_test), 2]

search_bigram <- paste("^", word_fragment, " ", sep = "")
search_trigram <- paste("^", bigram_fragment, " ", sep = "")
search_quadgram <- paste("^", trigram_fragment, " ", sep = "")
search_quintgram <- paste("^", quadgram_fragment, " ", sep = "")

ordered_word <- count(word_df, word, sort = TRUE)
ordered_bigram <- count(bigram_df, ngram, sort = TRUE)
ordered_trigram <- count(trigram_df, ngram, sort = TRUE)
ordered_quadgram <- count(quadgram_df, ngram, sort = TRUE)
ordered_quintgram <- count(quintgram_df, ngram, sort = TRUE)

# remove non-essential data sets to free up RAM
rm(word_df, word_fragment, word_test,
   bigram_df, bigram_fragment, bigram_test,
   trigram_df, trigram_fragment, trigram_test,
   quadgram_df, quadgram_fragment, quadgram_test,
   quintgram_df, quintgram_fragment, quintgram_test)

fragment_search <- function(x, y) {
    indices <- grep(x, y[[1]])
    df_dist <- y[indices,]
    topx <- df_dist[1:10,]
    topx
}

fragment_search(search_bigram, ordered_bigram)
fragment_search(search_trigram, ordered_trigram)
fragment_search(search_quadgram, ordered_quadgram)
fragment_search(search_quintgram, ordered_quintgram)

# 1. reduce sentence to last 3 - 4 words

# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences for weight

