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

# separate ngram column into base and prediction columns
sep_ngrams <- function(x) {
    x$base <- gsub(" \\S*$", "", x$ngram)
    x$prediction <- sub(".*\\s+", "", x$ngram)
    x <- select(x, base, prediction, count, term_freq)
}

bigram <- sep_ngrams(bigram)
trigram <- sep_ngrams(trigram)
quadgram <- sep_ngrams(quadgram)
quintgram <- sep_ngrams(quintgram)
sextagram <- sep_ngrams(sextagram)

######################### ENTER TEST SENTENCE/SEQUENCE HERE (as a character string)
test <- "You're the reason why I smile everyday. Can you follow me please? It would mean the"
#########################

tokenize_test <- function(x, n) {
    tok <- tokens(x,
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

search_bigram <- tokenize_test(test, 1)
search_trigram <- tokenize_test(test, 2)
search_quadgram <- tokenize_test(test, 3)
search_quintgram <- tokenize_test(test, 4)
search_sextagram <- tokenize_test(test, 5)

sexta_match <- subset(sextagram, base == search_sextagram)
quint_match <- subset(quintgram, base == search_quintgram)
quad_match <- subset(quadgram, base == search_quadgram)
tri_match <- subset(trigram, base == search_trigram)
bi_match <- subset(bigram, base == search_bigram)

# Stupid Backoff
if (nrow(sexta_match) > 0) {
    score <- sexta_match$count[1] / sum(quint_match$count)
} else if (nrow(quint_match) > 0) {
    score <- quint_match$count[1] / sum(quad_match$count)
} else if (nrow(quad_match) > 0) {
    score <- quad_match$count[1] / sum(tri_match$count)
}

scores <- NULL
quint_match[1,3] / sum(quad_match$n)
0.4 * quad_match[1,3] / sum(tri_match$n)
0.4 * 0.4 * tri_match[1,3] / sum(bi_match$n)
0.4 * 0.4 * 0.4 * bi_match[1,3] / sum()
# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences more weight

