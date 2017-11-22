source("/Users/marsh/data_science_coursera/JHU_capstone/setup.R")
source("/Users/marsh/data_science_coursera/JHU_capstone/eda.R")

# recall variables from setup.R
total_word
total_bigram
total_trigram

# remove non-english words from total_word
english <- NULL
for(i in letters) {
    letter <- grep(i, total_word[[2]])
    english <- c(english, letter)
}
english <- unique(english)
word_df <- total_word[english,]

# remove non-english words from total_bigram
english <- NULL
for(i in letters) {
    letter <- grep(i, total_bigram[[2]])
    english <- c(english, letter)
}
english <- unique(english)
bigram_df <- total_bigram[english,]

# remove non-english words from total_trigram
english <- NULL
for(i in letters) {
    letter <- grep(i, total_trigram[[2]])
    english <- c(english, letter)
}
english <- unique(english)
trigram_df <- total_trigram[english,]

# enter sentence as y
a <- "The guy in front of me just bought a pound of bacon, a bouquet, and a case of"

# 1. reduce sentence to last 3 - 4 words
fragment <- grep(" [a-zA-Z] [a-zA-Z] [a-zA-Z]", a)
selected <- grep(a, df$ngram)
selected_df <- df[selected,]



df_dist <- count(df, ngram, sort = TRUE)
topx <- df_dist[1:10,]

# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences for weight


# beta area

