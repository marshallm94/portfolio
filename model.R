suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(quanteda))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(sqldf))

setwd("/Users/marsh/data_science_coursera/JHU_capstone")

clean_waste <- function(x, n) {
    name <- deparse(substitute(x))
    message(paste("Removing observations with counts <", n, "from", name, sep = " "))
    z <- subset(x, x[[2]] >= n)
    rm(list = name, pos = ".GlobalEnv")
    message(paste(name, "removed from global environment"))
    z
}

# clean unnecessary ngrams in files
unigram <- readRDS("./ngrams/unigram.rds")
clean_unigram <- clean_waste(unigram, 5)
saveRDS(clean_unigram, "./ngrams/clean_unigram.rds")
rm(clean_unigram)

bigram <- readRDS("./ngrams/bigram.rds")
clean_bigram <- clean_waste(bigram, 5)
saveRDS(clean_bigram, "./ngrams/clean_bigram.rds")
rm(clean_bigram)

trigram <- readRDS("./ngrams/trigram.rds")
clean_trigram <- clean_waste(trigram, 5)
saveRDS(clean_trigram, "./ngrams/clean_trigram.rds")
rm(clean_trigram)

quadgram <- readRDS("./ngrams/quadgram.rds")
clean_quadgram <- clean_waste(quadgram, 5)
saveRDS(clean_quadgram, "./ngrams/clean_quadgram.rds")
rm(clean_quadgram)

quintgram <- readRDS("./ngrams/quintgram.rds")
clean_quintgram <- clean_waste(quintgram, 5)
saveRDS(clean_quintgram, "./ngrams/clean_quintgram.rds")
rm(clean_quintgram)

sextagram <- readRDS("./ngrams/sextagram.rds")
clean_sextagram <- clean_waste(sextagram, 5)
saveRDS(clean_sextagram, "./ngrams/clean_sextagram.rds")
rm(clean_sextagram)

unigram <- readRDS("./ngrams/clean_unigram.rds")
bigram <- readRDS("./ngrams/clean_bigram.rds")
trigram <- readRDS("./ngrams/clean_trigram.rds")
quadgram <- readRDS("./ngrams/clean_quadgram.rds")
quintgram <- readRDS("./ngrams/clean_quintgram.rds")
sextagram <- readRDS("./ngrams/clean_sextagram.rds")

add_tf <- function(x) {
    y <- sum(x[[2]])
    x <- mutate(x, term_freq = count/y)
    as.data.table(x)
}

unigram <- add_tf(unigram)
bigram <- add_tf(bigram)
trigram <- add_tf(trigram)
quadgram <- add_tf(quadgram)
quintgram <- add_tf(quintgram)
sextagram <- add_tf(sextagram)

######################### ENTER TEST SENTENCE/SEQUENCE HERE
a <- "You're the reason why I smile everyday. Can you follow me please? It would mean the"
#########################

tokenize_test <- function(x, n) {
    x <- a
    n <- 2
    tok <- tokens(a,
                  remove_numbers = TRUE,
                  remove_punct = TRUE,
                  remove_symbols = TRUE,
                  remove_hyphens = TRUE,
                  remove_url = TRUE)
    tokens <- tokens_ngrams(tok, n, concatenator = " ")
    unlisted <- unlist(tokens)
    search_for <- unname(tail(unlisted, n = 1))
    search_for
}


word_test <- sentence_to_word(a)
bigram_test <- sentence_to_ngram(a, n = 2)
trigram_test <- sentence_to_ngram(a, n = 3)
quadgram_test <- sentence_to_ngram(a, n = 4)

word_fragment <- word_test[nrow(word_test), 2]
bigram_fragment <- bigram_test[nrow(bigram_test), 2]
trigram_fragment <- trigram_test[nrow(trigram_test), 2]
quadgram_fragment <- quadgram_test[nrow(quadgram_test), 2]

search_word <- paste("^", word_fragment, " ", sep = "")
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
    topx <- df_dist[,]
    topx
}

quint_match <- fragment_search(search_quintgram, ordered_quintgram)
quad_match <- fragment_search(search_quadgram, ordered_quadgram)
tri_match <- fragment_search(search_trigram, ordered_trigram)
bi_match <- fragment_search(search_bigram, ordered_bigram)
word_match <- fragment_search(search_word, ordered_word)

scores <- NULL
quint_match[1,2] / sum(quad_match$n)
0.4 * quad_match[1,2] / sum(tri_match$n)
0.4 * 0.4 * tri_match[1,2] / sum(bi_match$n)
0.4 * 0.4 * 0.4 * bi_match[1,2] / sum()
# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences more weight

