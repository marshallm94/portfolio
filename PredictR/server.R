suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(quanteda))
suppressPackageStartupMessages(library(data.table))

unigram <- readRDS("./unigram_final.rds")
bigram <-  readRDS("./bigram_final.rds")
trigram <- readRDS("./trigram_final.rds")
quadgram <- readRDS("./quadgram_final.rds")

shinyServer(function(input, output) {
    #unigram <- reactive({ readRDS("./unigram_final.rds") })
    #bigram <- reactive({ readRDS("./bigram_final.rds") })
    #trigram <- reactive({ readRDS("./trigram_final.rds") })
    #quadgram <- reactive({ readRDS("./quadgram_final.rds") })
    
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
    
    predict_word <- function(test, number_of_words) {
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
            message(paste("No matches found; returning top", number_of_words, "unigrams", sep = " "))
        }
        dt5 <- select(unigram, ngram)
        dt5 <- dplyr::rename(dt5, prediction = ngram) %>% mutate(score = NA)
        pred_dt <- rbind(pred_dt, dt5)
        pred_dt <- subset(pred_dt, is.na(prediction) == FALSE)
        final_dt <- as.data.table(arrange(pred_dt, desc(score)))
        if (number_of_words == 0) {
            print("no input detected")
        } else {
            final_dt[1:number_of_words, 1]
        }
    }
    
    number <- reactive({ input$dropdown })
    string <- reactive({ input$ngram })
    output$prediction <- renderTable({
        predict_word(string(), number_of_words = number())
    })
}
)
