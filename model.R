source("/Users/marsh/data_science_coursera/JHU_capstone/setup.R")
source("/Users/marsh/data_science_coursera/JHU_capstone/eda.R")

# from eda.R
x <- total_trigram
df <- x
english <- NULL
for(i in letters) {
    letter <- grep(i, df[[2]])
    english <- c(english, letter)
}
english <- unique(english)
df <- df[english,]
df_dist <- count(df, ngram, sort = TRUE)
topx <- df_dist[1:10,]

# for new/unseen ngrams in prediction model, if word predicted is wrong, input
# entire sentence/sequence and add to file (add to data frame). For future calls
# to function, give these user-inputed sequences for weight

y <- "to go"
grep(x, df_dist$ngram)