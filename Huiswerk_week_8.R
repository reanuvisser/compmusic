# 2. Load the data (R will open TWO pop-ups sequentially)

# POP-UP 1: Select your Russian CSV file when prompted
chroma_ru <- process_chroma_final("S.X.N.D. N.X.D.E.S. (OUTLIER RUSSIA/DRIFT)")

# POP-UP 2: Select your Brazilian CSV file when prompted
chroma_br <- process_chroma_final("MONTAGEM REBOLA (OUTLIER BRAZIL)")

# Combine both tracks into one master dataset
chroma_both <- bind_rows(chroma_ru, chroma_br)


# 3. Create the Stacked Heatmap
pitch_order <- rev(c("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"))

ggplot(chroma_both, aes(x = Time, y = factor(Pitch, levels = pitch_order), fill = Intensity)) +
  geom_tile() +
  scale_fill_viridis_c(option = "magma") + 
  facet_wrap(~ Track, ncol = 1) +  # This is the magic line that stacks the two tracks!
  theme_minimal() +
  labs(
    title = "Harmonic Fingerprint: Phonk Outliers",
    subtitle = "Chroma feature analysis (Sonic Visualiser)",
    x = "Time (seconds)",
    y = "Note (Pitch Class)",
    fill = "Intensity"
  ) +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_text(size = 9),
    strip.text = element_text(face = "bold", size = 11) # Makes the track titles bold
  )

# Save the plot - Notice I doubled the height to 8 so both tracks have plenty of room
ggsave("both_chromagrams_stacked.png", width = 12, height = 8, dpi = 300)