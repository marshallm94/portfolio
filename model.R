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

# separate ngram column into base and prediction columns
sep_ngrams <- function(x) {
    x$base <- gsub(" \\S*$", "", x$ngram)
    x$prediction <- sub(".*\\s+", "", x$ngram)
    x <- select(x, ngram, base, prediction, count)
    x <- setkey(x, base)
    x <- as.data.table(arrange(x, desc(count)))
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
quintgram <- sep_ngrams(quintgram)
saveRDS(quintgram, "./PredictR/quintgram_final.rds")
sextagram <- sep_ngrams(sextagram)
saveRDS(sextagram, "./PredictR/sextagram_final.rds")



rm(unigram, bigram, trigram, quadgram, quintgram, sextagram)

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

predict_word <- function(string, n = 10) {
    test <- string
    
    search_bigram <- tokenize_test(test, 1)
    search_trigram <- tokenize_test(test, 2)
    search_quadgram <- tokenize_test(test, 3)
    search_quintgram <- tokenize_test(test, 4)
    search_sextagram <- tokenize_test(test, 5)
    
    sexta_match <- arrange(subset(sextagram, base == search_sextagram), desc(count))
    quint_match <- arrange(subset(quintgram, base == search_quintgram), desc(count))
    quad_match <- arrange(subset(quadgram, base == search_quadgram), desc(count))
    tri_match <- arrange(subset(trigram, base == search_trigram), desc(count))
    bi_match <- arrange(subset(bigram, base == search_bigram), desc(count))
    
    # Stupid Backoff
    pred_dt <- NULL
    if (nrow(sexta_match) > 0) {
        score <- sexta_match$count / sum(subset(quintgram,
                                                ngram == search_sextagram)$count)
        dt <- data.table(prediction = sexta_match$prediction, score = score)
        pred_dt <- rbind(pred_dt, dt)
    } else if (nrow(quint_match) > 0) {
        score1 <- 0.4 * quint_match$count / sum(subset(quadgram,
                                                       ngram == search_quintgram)$count)
        dt1 <- data.table(prediction = quint_match$prediction, score = score1)
        pred_dt <- rbind(pred_dt, dt1)
    } else if (nrow(quad_match) > 0) {
        score2 <- (0.4^2) * quad_match$count / sum(subset(trigram,
                                                          ngram == search_quadgram)$count)
        dt2 <- data.table(prediction = quad_match$prediction, score = score2)
        pred_dt <- rbind(pred_dt, dt2)
    } else if (nrow(tri_match) > 0) {
        score3 <- (0.4^3) * tri_match$count / sum(subset(bigram,
                                                         ngram == search_trigram)$count)
        dt3 <- data.table(prediction = tri_match$prediction, score = score3)
        pred_dt <- rbind(pred_dt, dt3)
    } else if (nrow(bi_match) > 0) {
        score4 <- (0.4^4) * bi_match$count / sum(subset(unigram,
                                                        ngram == search_bigram)$count)
        dt4 <- data.table(prediction = bi_match$prediction, score = score4)
        pred_dt <- rbind(pred_dt, dt4)
    } else {
        message("No matches found; returning top 5 unigrams")
        dt5 <- select(unigram, ngram)
        dt5 <- rename(dt5, prediction = ngram) %>% mutate(score = NA)
        pred_dt <- head(rbind(pred_dt, dt5), n = 5)
    }
    
    pred_dt <- subset(pred_dt, is.na(prediction) == FALSE)
    final_dt <- as.data.table(arrange(pred_dt, desc(score)))
    head(final_dt, n = n)
}