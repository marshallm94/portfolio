setwd("/Users/marsh/data_science_coursera/JHU_capstone")

unigram <- readRDS("./ngrams/unigram.rds")
bigram <- readRDS("./ngrams/bigram.rds")
trigram <- readRDS("./ngrams/trigram.rds")
quadgram <- readRDS("./ngrams/quadgram.rds")
quintgram <- readRDS("./ngrams/quintgram.rds")
sextagram <- readRDS("./ngrams/sextag")

add_tf <- function(x) {
    y <- sum(x$count)
    x <- mutate(x, term_freq = count/y)
    as.data.table(x)
}

tf_unigram <- add_tf(unigram)
ordered_bigram <- add_tf(ordered_bigram)
ordered_trigram <- add_tf(ordered_trigram)
ordered_quadgram <- add_tf(ordered_quadgram)
ordered_quintgram <- add_tf(ordered_quintgram)

# in order to improve performance, will reduce the data sets to only those 
# tokens/ngrams that have a minimum count. (Since the count/term-frequency is so
# low, the probability of my model choosing those ngrams is rather low, therefore
# keeping them in the data set is a waste of memory)

ordered_word <- subset(tf_unigram, count >= quantile(tf_unigram$count, probs = 0.75))
ordered_bigram <- subset(ordered_bigram, n >= quantile(ordered_bigram$n, probs = 0.90))
ordered_trigram <- subset(ordered_trigram, n >= quantile(ordered_trigram$n, probs = 0.90))
ordered_quadgram <- subset(ordered_quadgram, n >= quantile(ordered_quadgram$n, probs = 0.90))
ordered_quintgram <- subset(ordered_quintgram, n >= quantile(ordered_quintgram$n, probs = 0.90))

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

######################### ENTER TEST SENTENCE/SEQUENCE HERE
a <- "You're the reason why I smile everyday. Can you follow me please? It would mean the"
#########################

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

