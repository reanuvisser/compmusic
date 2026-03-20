library(tidyverse)
library(randomForest)
library(ggplot2)
library(caret)

# --- 1. DATA PREPARATION ---
brazilian_data <- read.csv("Brazilian_Phonk_UvA.csv") %>% mutate(genre = "Brazilian Phonk")
russian_data <- read.csv("Drift_Phonk_UvA.csv") %>% mutate(genre = "Russian Phonk")
mijn_corpus <- rbind(brazilian_data, russian_data)

# Full numeric set
corpus_clean <- mijn_corpus %>%
  select(Danceability, Energy, Loudness, Speechiness, Acousticness, 
         Instrumentalness, Liveness, Valence, Tempo, genre) %>%
  mutate(genre = as.factor(genre))

# --- 2. STAGE 1: BASELINE MODEL ---
# Goal: Test performance with all original features
set.seed(123)
baseline_cv <- train(genre ~ ., data = corpus_clean, method = "rf", 
                     trControl = trainControl(method = "cv", number = 10))
print(baseline_cv) # Use these Accuracy/Kappa values for Stage 1 in your table

# --- 3. STAGE 2: REFINED MODEL (FEATURE SELECTION) ---
# Goal: Improve accuracy by removing "noise" (low importance features)
refined_corpus <- corpus_clean %>%
  select(Tempo, Loudness, Instrumentalness, Energy, Acousticness, Speechiness, genre)

set.seed(123)
refined_cv <- train(genre ~ ., data = refined_corpus, method = "rf", 
                    trControl = trainControl(method = "cv", number = 10))
print(refined_cv) # Use these Accuracy/Kappa values for Stage 2

# --- 4. STAGE 3: FINAL MODEL (FEATURE ENGINEERING) ---
# Goal: Use musical intuition to create interaction terms
final_corpus <- refined_corpus %>%
  mutate(
    Aggression = Energy * Tempo,
    Density = Loudness * Instrumentalness
  )

set.seed(123)
# We run the specific randomForest model to extract importance later
final_model <- randomForest(genre ~ ., data = final_corpus, importance = TRUE)

# Validation with Caret
final_cv <- train(genre ~ ., data = final_corpus, method = "rf", 
                  trControl = trainControl(method = "cv", number = 10))
print(final_cv) # Use these Accuracy/Kappa values for Stage 3

# --- 5. VISUALIZATION: FEATURE IMPORTANCE ---
final_imp_df <- as.data.frame(importance(final_model)) %>%
  rownames_to_column(var = "Feature")

importance_bar_chart <- ggplot(final_imp_df, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_col(fill = "#0033A0", width = 0.7) + 
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Feature Importance: Random Forest Classifier",
    subtitle = "Relative contribution of audio features to genre prediction",
    x = NULL, y = "Importance (Mean Decrease Gini)"
  )

ggsave("importance_plot.png", plot = importance_bar_chart, width = 8, height = 4)

# --- 6. VISUALIZATION: UNSUPERVISED CLUSTERING (PCA) ---
pca_data <- final_corpus %>% select(-genre)
pca_result <- prcomp(pca_data, center = TRUE, scale. = TRUE)
var_explained <- round(100 * pca_result$sdev^2 / sum(pca_result$sdev^2), 1)

pca_plot <- as.data.frame(pca_result$x) %>%
  mutate(genre = final_corpus$genre) %>%
  ggplot(aes(x = PC1, y = PC2, color = genre)) +
  geom_point(size = 2.5, alpha = 0.6) +
  stat_ellipse(aes(fill = genre), geom = "polygon", alpha = 0.1) +
  scale_color_manual(values = c("Brazilian Phonk" = "#009739", "Russian Phonk" = "#0033A0")) +
  scale_fill_manual(values = c("Brazilian Phonk" = "#009739", "Russian Phonk" = "#0033A0")) +
  theme_minimal() +
  labs(
    title = "Unsupervised Cluster Analysis (PCA)",
    subtitle = paste0("Total Variance Explained: ", var_explained[1] + var_explained[2], "%"),
    x = paste0("PC1 (", var_explained[1], "%)"),
    y = paste0("PC2 (", var_explained[2], "%)")
  )

ggsave("pca_plot.png", plot = pca_plot, width = 8, height = 5)