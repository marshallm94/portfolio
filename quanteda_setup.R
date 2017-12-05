#Load Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(quanteda))

setwd('/Users/marsh/data_science_coursera/JHU_capstone/data/final/en_US/')

# read in entire blog, news and twitter text files
getfile <- function(text_source) {
    x <- grep(text_source, list.files())
    con <- file(list.files()[x], "r")
    y <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
    close(con)
    y
}

blog <- getfile("blog")
news <- getfile("news")
twitter <- getfile("twitter")

setwd('/Users/marsh/data_science_coursera/JHU_capstone/')

total <- c(blog, news, twitter)

sample_set <- sample(1:length(total), length(total)/4)

system.time(sample_corp <- corpus(total[sample_set]))

rm(blog, news, twitter, sample_set, total)

system.time(corp_tokens <- tokens(sample_corp,
                    remove_numbers = TRUE,
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_hyphens = TRUE,
                    remove_url = TRUE))

gc()

create_ngram <- function(tokens, n) {
    current_name <- paste(n, "gram", sep = "")
    filename <- paste("./ngrams/", n, "gram.rds", sep = "")
    
    message(paste("Starting", current_name, "creation...", date(), sep = " "))
    name <- tokens_ngrams(tokens, n, concatenator = " ")
    message(paste("Creation of", current_name, "complete:", date(), sep = " "))
    
    saveRDS(name, file = filename)
    message(paste("Saving of", filename, "complete:", date(), sep = " "))
    
    rm(name)
    message(paste(current_name, "removed from workspace:", date(), sep = " "))
}

create_ngram(corp_tokens, 6)
create_ngram(corp_tokens, 5)
create_ngram(corp_tokens, 4)
create_ngram(corp_tokens, 3)
create_ngram(corp_tokens, 2)
create_ngram(corp_tokens, 1)

rm(corp_tokens, sample_corp)

create_table <- function(file) {
    message(paste("Reading", file, "into workspace...", date(), sep = " "))
    x <- readRDS(file = file)
    message(paste("Unlisting", file, "object...", date(), sep = " "))
    unlisted <- unlist(x)
    message(paste("Unnaming", file, "object...", date(), sep = " "))
    unnamed <- unname(unlisted)
    dt <- data.table(ngram = unnamed, count = 1)
    message(paste("Transformation of", file, "to data.table complete:",
                  date(), sep = " "))
    dt
}

# cleans non-english words and performs a summation of ngrams
clean_sum <- function(x, filename) {
    message(paste("Starting summation of ngrams...", date(), sep = " "))
    y <- x[, .(count = sum(count)), by = .(ngram)]
    y <- arrange(y, desc(count))
    message(paste("Summation of ngrams complete:", date(), sep = " "))
    y <- as.data.table(y)
    english <- NULL
    message(paste("Searching for non-english ngrams...", date(), sep = " "))
    for (i in letters) {
        letter <- grep(i, y[[1]])
        english <- c(english, letter)
    }
    english <- unique(english)
    y <- y[english,]
    message(paste("Removal of non-english ngrams complete:", date(), sep = " "))
    saveRDS(y, file = filename)
    message(paste("Saving of", filename, "complete:", date(), sep = " "))
    rm(list = deparse(substitute(x)), pos = ".GlobalEnv")
    message(paste("Removed object from workspace and", filename, "created:",
                  date(), sep = " "))
}

unigram <- create_table("./ngrams/1gram.rds")
clean_sum(unigram, "./ngrams/unigram.rds")

bigram <- create_table("./ngrams/2gram.rds")
clean_sum(bigram, "./ngrams/bigram.rds")

trigram <- create_table("./ngrams/3gram.rds")
clean_sum(trigram, "./ngrams/trigram.rds")

quadgram <- create_table("./ngrams/4gram.rds")
clean_sum(quadgram, "./ngrams/quadgram.rds")

quintgram <- create_table("./ngrams/5gram.rds")
clean_sum(quintgram, "./ngrams/quintgram.rds")

sextagram <- create_table("./ngrams/6gram.rds")
clean_sum(sextagram, "./ngrams/sextagram.rds")


