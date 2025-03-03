##### Analyses and data visualizations for the squirrel colour morphs project

#### Script Info/Instructions -----

{
  ## Start-up Instructions
  # 1. Pull from github first
  # 2. Read libraries second (after downloading them on first use)
  # 3. Read all datasets third
  
  # Script Format
  ##### Script Description
  #### Script Instructions/Details
  ### Section Header
  ## Description of single code chunk
  # Description of single line
}

### Download packages -----

## For EBImage
{
  install.packages("BiocManager")
  BiocManager::install("EBImage")
}

### Load Packages -----

{ #run this line to read all packages
  library(tidyverse) #for tidyverse structure of coding using pipes
  library(ggplot2) #for tidy plot generation
  library(EBImage) #for image processing
}

### Read Data -----

{ #run this line to read all data files
  df_sq_1_31535 <- read_csv("Data/sq_RGB_2020_df_1_31535.csv")
  head(df_sq_1_31535)
}