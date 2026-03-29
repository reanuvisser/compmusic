library(tidyverse)
library(ggplot2)

# STAP 1: Bestanden opnieuw inladen (Kies je CSV's)
print("Selecteer nu Brazilian_Phonk_UvA.csv")
brazilian_data <- read.csv(file.choose()) %>%
  mutate(genre = "Brazilian Phonk")

print("Selecteer nu Drift_Phonk_UvA.csv")
russian_data <- read.csv(file.choose()) %>%
  mutate(genre = "Russian Phonk")

# STAP 2: Samenvoegen tot mijn_corpus
mijn_corpus <- rbind(brazilian_data, russian_data)

# STAP 3: Gemiddeldes berekenen
gemiddeldes <- mijn_corpus %>%
  group_by(genre) %>%
  summarise(
    avg_dance = mean(Danceability, na.rm = TRUE),
    avg_energy = mean(Energy, na.rm = TRUE)
  )

# STAP 4: De grafiek maken
ggplot() +
  # De individuele tracks (kleine puntjes)
  geom_point(data = mijn_corpus, aes(x = Danceability, y = Energy, color = genre), 
             size = 2, alpha = 0.3) +
  
  # De GROTE ruiten voor het gemiddelde
  geom_point(data = gemiddeldes, aes(x = avg_dance, y = avg_energy, color = genre), 
             size = 8, shape = 18) + 
  
  theme_minimal() +
  scale_color_manual(values = c("Brazilian Phonk" = "#009739", "Russian Phonk" = "#0033A0")) +
  labs(
    title = "Brazilian vs. Russian Phonk: Centroids",
    subtitle = "Grote ruiten geven het gemiddelde aan (N=100)",
    x = "Danceability (0-1)",
    y = "Energy (0-1)",
    color = "Genre:"
  ) +
  xlim(0, 1) + 
  ylim(0, 1)