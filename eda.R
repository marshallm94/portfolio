setwd('/Users/marsh/data_science_coursera/JHU_capstone/')

# Returns the top n words in pre-processed tibble x
top_words <- function(x, title, n = 10, stopword = FALSE) {
      df <- x
      if (stopword == FALSE) {
            df <- anti_join(df, stop_words)
      } else {
            print("Continuing with stopwords included...")
      }
      english <- NULL
      for (i in letters) {
            letter <- grep(i, df[[2]])
            english <- c(english, letter)
      }
      english <- unique(english)
      df <- df[english,]
      df_dist <- count(df, word, sort = TRUE)
      topx <- df_dist[1:n,]
      g <- ggplot(topx, aes(x = reorder(word, n), y = n))
      g <- g + geom_bar(fill = "Red", stat = "identity")
      g <- g + xlab("Word")
      g <- g + ylab("Instances")
      g <- g + ggtitle(title)
      g <- g + coord_flip()
      g
}

word_dist <- top_words(total_word, "Word Distribution")

# returns the top ngrams in processed corpus tibble x
top_ngrams <- function(x, title, n = 10) {
      df <- x
      english <- NULL
      for (i in letters) {
            letter <- grep(i, df[[2]])
            english <- c(english, letter)
      }
      english <- unique(english)
      df <- df[english,]
      df_dist <- count(df, ngram, sort = TRUE)
      topx <- df_dist[1:n,]
      g <- ggplot(topx, aes(x = reorder(ngram, n), y = n))
      g <- g + geom_bar(fill = "Red", stat = "identity")
      g <- g + xlab("n-gram")
      g <- g + ylab("Instances")
      g <- g + ggtitle(title)
      g <- g + coord_flip()
      g
}

bigram_dist <- top_ngrams(total_bigram, "Bigram Distribution")
trigram_dist <- top_ngrams(total_trigram, "Trigram Distribution")

blog_bigram_dist <- top_ngrams(blog_bigram, "Bigram Blog Distribution")
news_bigram_dist <- top_ngrams(news_bigram, "Bigram News Distribution")
twitter_bigram_dist <- top_ngrams(twitter_bigram, "Bigram Twitter Distribution")

blog_trigram_dist <- top_ngrams(blog_trigram, "Trigram Blog Distribution")
news_trigram_dist <- top_ngrams(news_trigram, "Trigram News Distribution")
twitter_trigram_dist <- top_ngrams(twitter_trigram, "Trigram Twitter Distribution")
