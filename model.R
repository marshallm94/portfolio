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

# enter test sentence

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

a <- "The man bought a bouquet and a case of"

word_test <- sentence_to_word(a)
bigram_test <- sentence_to_ngram(a, n = 2)
trigram_test <- sentence_to_ngram(a, n = 3)
quadgram_test <- sentence_to_ngram(a, n = 4)
quintgram_test <- sentence_to_ngram(a, n = 5)

word_fragment <- word_test[nrow(word_test),2]
bigram_fragment <- bigram_test[nrow(bigram_test),2]
trigram_fragment <- trigram_test[nrow(trigram_test),2]
quadgram_fragment <- quadgram_test[nrow(quadgram_test),2]
quintgram_fragment <- quintgram_test[nrow(quintgram_test),2]

search_bigram <- paste("^", word_fragment, sep = "")
search_trigram <- paste("^", bigram_fragment, sep = "")
serach_quadgram <- paste("^", trigram_fragment, sep = "")
serach_quintgram <- paste("^", quadgram_fragment, sep = "")



df_dist <- count(total_trigram, ngram, sort = TRUE)
indices <- grep(fragment, df_dist[[1]])
df_dist <- df_dist[indices,]
topx <- df_dist[1:10,]

# 1. reduce sentence to last 3 - 4 words

# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences for weight

