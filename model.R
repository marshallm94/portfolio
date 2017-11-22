source("/Users/marsh/data_science_coursera/JHU_capstone/setup.R")
source("/Users/marsh/data_science_coursera/JHU_capstone/eda.R")

# recall variables from setup.R
total_word
total_bigram
total_trigram

# remove non-english words from total_word
english <- NULL
for (i in letters) {
    letter <- grep(i, total_word[[2]])
    english <- c(english, letter)
}
english <- unique(english)
word_df <- total_word[english,]

# remove non-english words from total_bigram
english <- NULL
for (i in letters) {
    letter <- grep(i, total_bigram[[2]])
    english <- c(english, letter)
}
english <- unique(english)
bigram_df <- total_bigram[english,]

# remove non-english words from total_trigram
english <- NULL
for (i in letters) {
    letter <- grep(i, total_trigram[[2]])
    english <- c(english, letter)
}
english <- unique(english)
trigram_df <- total_trigram[english,]

# enter test sentence
a <- "The guy in front of me just bought a pound of bacon, a bouquet, and a case of"
b <- "You're the reason why I smile everyday. Can you follow me please? It would mean the"

sentence_to_word <- function(x) {
    df <- as_data_frame(x)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = word, text, token = 'words')
    df3
}

sentence_to_ngram <- function(x, number = 2) {
    df <- as_data_frame(x)
    df2 <- mutate(df, line = rownames(df))
    df2$line <- as.integer(df2$line)
    df2 <- select(df2, line, value)
    df2 <- rename(df2, text = value)
    df3 <- df2 %>% unnest_tokens(output = ngram, text, token = 'ngrams', n = number)
    df3
}

test <- sentence_to_ngram(a)

fragment <- test[nrow(test),2]
fragment <- paste("^", fragment, sep = "")

indices <- grep(fragment, total_trigram[[2]])
bing <- total_trigram[indices,]

# 1. reduce sentence to last 3 - 4 words
selected <- grep("^mean the ", total_trigram[[2]])
selected_df <- total_trigram[selected,]



df_dist <- count(df, ngram, sort = TRUE)
topx <- df_dist[1:10,]

# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences for weight


# beta area

