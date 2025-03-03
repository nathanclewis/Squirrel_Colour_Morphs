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
  
  ## Ful dataset for 22,219 records from 2020
  df_sq_1_31535 <- read_csv("Data/sq_RGB_2020_df_1_31535.csv")
  head(df_sq_1_31535)
  
  ## All 31413 records from 2021
  df_sq_2021 <- read_csv("Data/observations_2021_fixedurls.csv")
  
  ## All records from 2020
  df_sq_2020 <- read_csv("Data/df_2020_complete_data.csv")
}