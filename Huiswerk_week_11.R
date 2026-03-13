library(tidyverse)
library(ggplot2)

# 1. Load datasets
print("Selecteer Brazilian_Phonk_UvA.csv")
brazilian_data <- read.csv(file.choose()) %>% mutate(genre = "Brazilian Phonk")

print("Selecteer Drift_Phonk_UvA.csv")
russian_data <- read.csv(file.choose()) %>% mutate(genre = "Russian Phonk")

# 2. Combine them
mijn_corpus <- rbind(brazilian_data, russian_data)

# 3. Create an overlapping histogram of the tempos
ggplot(mijn_corpus, aes(x = Tempo, fill = genre)) +
  geom_histogram(position = "identity", alpha = 0.6, bins = 20, color = "white") +
  scale_fill_manual(values = c("Brazilian Phonk" = "#009739", "Russian Phonk" = "#0033A0")) +
  theme_minimal() +
  labs(
    title = "Tempo Distribution: Brazilian vs. Russian Phonk",
    subtitle = "Comparing BPM across 114 corpus tracks",
    x = "Tempo (BPM)",
    y = "Number of Tracks",
    fill = "Genre:"
  ) +
  theme(panel.grid.minor = element_blank())