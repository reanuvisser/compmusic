# Project Overview
This project uses Music Information Retrieval (MIR) to analyze the harmonic fingerprints of two Phonk subgenres: Brazilian Phonk (MONTAGEM REBOLA) and Russian Drift Phonk (S.X.N.D. N.X.D.E.S.). By treating audio as a fossil record, I investigate how these tracks differ in pitch distribution over time.

## Visual Analysis
### 1. Brazilian Phonk (Percussive Aggression)
The chromagram shows intense, vertical noise streaks across all 12 pitch classes. This confirms that the track prioritizes timbral energy over melody. This aligns with Topic H5 which is the absence of identifiable chord structure found in high-energy, rap-related genres.

### 2. Russian Phonk (Harmonic Repetition)
In contrast, the Russian track displays distinct horizontal lines, particularly at F# and D. This visualizes the repetitive cowbell loops that define the genre's modal structure. It provides a clear physical measure of its melodic content rather than a purely cognitive interpretation.

## Technical Implementation
Using R and ggplot2, I corrected axis NA errors to ensure a full 12-semitone mapping. This ensures better construct validity for the final portfolio evaluation. The results prove that while both are Phonk, the Brazilian style is percussive/noisy, whereas the Russian style is melodic/repetitive.
