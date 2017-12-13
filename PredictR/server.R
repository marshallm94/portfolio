library(shiny)
shinyServer(function(input, output) {
    suppressPackageStartupMessages(library(tidyverse))
    suppressPackageStartupMessages(library(quanteda))
    suppressPackageStartupMessages(library(data.table))
    
    setwd("/Users/marsh/data_science_coursera/JHU_capstone/")
    
    # load files
    unigram <- reactive({ readRDS("./PredictR/unigram_final.rds") })
    bigram <- reactive({ readRDS("./PredictR/bigram_final.rds") })
    trigram <- reactive({ readRDS("./PredictR/trigram_final.rds") })
    quadgram <- reactive({ readRDS("./PredictR/quadgram_final.rds") })
    quintgram <- reactive({ readRDS("./PredictR/quintgram_final.rds") })
    sextagram <- reactive({ readRDS("./PredictR/sextagram_final.rds") })
    
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
    
    predict_word <- function(string, number_of_words) {
        test <- string
        
        search_bigram <- tokenize_test(test, 1)
        search_trigram <- tokenize_test(test, 2)
        search_quadgram <- tokenize_test(test, 3)
        search_quintgram <- tokenize_test(test, 4)
        search_sextagram <- tokenize_test(test, 5)
        
        sexta_match <- arrange(subset(sextagram(), base == search_sextagram), desc(count))
        quint_match <- arrange(subset(quintgram(), base == search_quintgram), desc(count))
        quad_match <- arrange(subset(quadgram(), base == search_quadgram), desc(count))
        tri_match <- arrange(subset(trigram(), base == search_trigram), desc(count))
        bi_match <- arrange(subset(bigram(), base == search_bigram), desc(count))
        
        # Stupid Backoff
        pred_dt <- NULL
        if (nrow(sexta_match) > 0) {
            score <- sexta_match$count / sum(subset(quintgram(),
                                                    ngram == search_sextagram)$count)
            dt <- data.table(prediction = sexta_match$prediction, score = score)
            pred_dt <- rbind(pred_dt, dt)
        } else if (nrow(quint_match) > 0) {
            score1 <- 0.4 * quint_match$count / sum(subset(quadgram(),
                                                           ngram == search_quintgram)$count)
            dt1 <- data.table(prediction = quint_match$prediction, score = score1)
            pred_dt <- rbind(pred_dt, dt1)
        } else if (nrow(quad_match) > 0) {
            score2 <- (0.4^2) * quad_match$count / sum(subset(trigram(),
                                                              ngram == search_quadgram)$count)
            dt2 <- data.table(prediction = quad_match$prediction, score = score2)
            pred_dt <- rbind(pred_dt, dt2)
        } else if (nrow(tri_match) > 0) {
            score3 <- (0.4^3) * tri_match$count / sum(subset(bigram(),
                                                             ngram == search_trigram)$count)
            dt3 <- data.table(prediction = tri_match$prediction, score = score3)
            pred_dt <- rbind(pred_dt, dt3)
        } else if (nrow(bi_match) > 0) {
            score4 <- (0.4^4) * bi_match$count / sum(subset(unigram(),
                                                            ngram == search_bigram)$count)
            dt4 <- data.table(prediction = bi_match$prediction, score = score4)
            pred_dt <- rbind(pred_dt, dt4)
        } else {
            message(paste("No matches found; returning top", number_of_words, "unigrams", sep = " "))
        }
        dt5 <- select(unigram(), ngram)
        dt5 <- dplyr::rename(dt5, prediction = ngram) %>% mutate(score = NA)
        pred_dt <- rbind(pred_dt, dt5)
        pred_dt <- subset(pred_dt, is.na(prediction) == FALSE)
        final_dt <- as.data.table(arrange(pred_dt, desc(score)))
        head(final_dt, n = number_of_words)
    }
    
    number <- reactive({ input$dropdown })
    
    string <- reactive({ input$ngram })
    
    output$prediction <- renderTable({
        predict_word(string(), number_of_words = number())
    })
}
)
