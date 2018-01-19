suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(quanteda))
suppressPackageStartupMessages(library(data.table))

setwd("/Users/marsh/data_science_coursera/JHU_capstone")

clean_waste <- function(x, n = 5) {
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

unigram <- readRDS("./ngrams/clean_unigram.rds")
bigram <- readRDS("./ngrams/clean_bigram.rds")
trigram <- readRDS("./ngrams/clean_trigram.rds")
quadgram <- readRDS("./ngrams/clean_quadgram.rds")

# separate ngram column into base and prediction columns
sep_ngrams <- function(x) {
    x$base <- gsub(" \\S*$", "", x$ngram)
    x$prediction <- sub(".*\\s+", "", x$ngram)
    x <- select(x, ngram, base, prediction, count)
    x <- x[order(-count)]
    setkey(x, base, count)
}

# save final data sets
unigram <- setkey(unigram, ngram)
saveRDS(unigram, "./PredictR/unigram_final.rds")
bigram <- sep_ngrams(bigram)
saveRDS(bigram, "./PredictR/bigram_final.rds")
trigram <- sep_ngrams(trigram)
saveRDS(trigram, "./PredictR/trigram_final.rds")
quadgram <- sep_ngrams(quadgram)
saveRDS(quadgram, "./PredictR/quadgram_final.rds")

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

# remove n = 5 as second argument for predict_word
predict_word <- function(test, n = 3) {
    search_bigram <- tokenize_test(test, 1)
    search_trigram <- tokenize_test(test, 2)
    search_quadgram <- tokenize_test(test, 3)
    
    quad_match <- quadgram[base == search_quadgram]
    tri_match <- trigram[base == search_trigram]
    bi_match <- bigram[base == search_bigram]
    
    # Stupid Backoff
    pred_dt <- NULL
    if (quad_match[,.N] > 0) {
        score2 <- 0.4 * quad_match[,count] / trigram[ngram == search_quadgram, sum(count)]
        dt2 <- data.table(prediction = quad_match[,prediction], score = score2)
        pred_dt <- rbind(pred_dt, dt2)
    } else if (tri_match[,.N] > 0) {
        score3 <- (0.4^2) * tri_match[,count] / bigram[ngram == search_trigram, sum(count)]
        dt3 <- data.table(prediction = tri_match[,prediction], score = score3)
        pred_dt <- rbind(pred_dt, dt3)
    } else if (bi_match[,.N] > 0) {
        score4 <- (0.4^3) * bi_match[,count] / unigram[ngram == search_bigram, sum(count)]
        dt4 <- data.table(prediction = bi_match[,prediction], score = score4)
        pred_dt <- rbind(pred_dt, dt4)
    } else {
        message("No matches found; returning top 5 unigrams")
        dt5 <- unigram[,.(ngram)]
        dt5 <- dt5[, .(prediction = ngram)]
        dt5 <- dt5[, score:= NA]
        pred_dt <- head(rbind(pred_dt, dt5), n = 5)
    }
    
    pred_dt <- pred_dt[order(-score)]
    head(pred_dt, n = n)
}