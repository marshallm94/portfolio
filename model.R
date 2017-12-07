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
    x <- select(x, ngram, base, prediction, count, term_freq)
}

bigram <- sep_ngrams(bigram)
trigram <- sep_ngrams(trigram)
quadgram <- sep_ngrams(quadgram)
quintgram <- sep_ngrams(quintgram)
sextagram <- sep_ngrams(sextagram)

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

######################### ENTER TEST SENTENCE/SEQUENCE HERE (as a character string)
test <- "The guy in front of me just bought a pound of bacon, a bouquet, and a case of"
#########################

search_bigram <- tokenize_test(test, 1)
search_trigram <- tokenize_test(test, 2)
search_quadgram <- tokenize_test(test, 3)
search_quintgram <- tokenize_test(test, 4)
search_sextagram <- tokenize_test(test, 5)

sexta_match <- head(subset(sextagram, base == search_sextagram), n = 5)
quint_match <- head(subset(quintgram, base == search_quintgram), n = 5)
quad_match <- head(subset(quadgram, base == search_quadgram), n = 5)
tri_match <- head(subset(trigram, base == search_trigram), n = 5)
bi_match <- head(subset(bigram, base == search_bigram), n = 5)

# Stupid Backoff
pred_dt <- NULL
if (nrow(sexta_match) > 0) {
    score <- sexta_match$count / sum(quint_match$count)
    dt <- data.table(prediction = sexta_match$prediction, score = score)
    pred_dt <- rbind(pred_dt, dt)
} else if (nrow(quint_match) > 0) {
    score1 <- 0.4 * quint_match$count / sum(quad_match$count)
    dt1 <- data.table(prediction = quint_match$prediction, score = score1)
    pred_dt <- rbind(pred_dt, dt, dt1)
} else if (nrow(quad_match) > 0) {
    score2 <- (0.4^2) * quad_match$count / sum(tri_match$count)
    dt2 <- data.table(prediction = quad_match$prediction, score = score2)
    pred_dt <- rbind(pred_dt, dt, dt1, dt2)
} else if (nrow(tri_match) > 0) {
    score3 <- (0.4^3) * tri_match$count / sum(bi_match$count)
    dt3 <- data.table(prediction = tri_match$prediction, score = score2)
    pred_dt <- rbind(pred_dt, dt, dt1, dt2, dt3)
} else if (nrow(bi_match) > 0) {
    score4 <- (0.4^4) * bi_match$count / sum(unigram$count)
    dt4 <- data.table(prediction = bi_match$prediction, score = score4)
    pred_dt <- rbind(pred_dt, dt, dt1, dt2, dt3, dt4)
}

pred_dt

pred_dt <- NULL
score <- sexta_match$count[1] / sum(quint_match$count)
dt <- data.table(prediction = sexta_match$prediction[1], score = score)

score1 <- 0.4 * quint_match$count[1] / sum(quad_match$count)
dt1 <- data.table(prediction = quint_match$prediction[1], score = score1)

score2 <- (0.4^2) * quad_match$count[1] / sum(tri_match$count)
dt2 <- data.table(prediction = quad_match$prediction[1], score = score2)


score3 <- (0.4^3) * tri_match$count[1] / sum(bi_match$count)
dt3 <- data.table(prediction = tri_match$prediction[1], score = score3)

score4 <- (0.4^4) * bi_match$count[1] / sum(unigram$count)
dt4 <- data.table(prediction = bi_match$prediction[1], score = score4)
pred_dt <- rbind(pred_dt, dt, dt1, dt2, dt3, dt4)

final_dt <- subset(pred_dt, is.na(prediction) == FALSE)
final_dt



# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences more weight

