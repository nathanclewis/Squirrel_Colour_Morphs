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

### Load Packages and Settings -----

{ #run this line to read all packages
  library(tidyverse) #for tidyverse structure of coding using pipes
  library(furrr) #contains future_map_lgl, which speeds up rowwise check of URLs
  plan(multisession) #enable parallel processing to speed up certain processes
  library(EBImage) #for image processing
  library(ggplot2) #for tidy plot generation
  }

### Read Data -----

{ #run this line to read all data files
  
  ## Completed dataset (including RGBs) with 22,219 records from 2020
  df_sq_2020_completed <- read_csv("Data/sq_RGB_2020_df_1_31535.csv")
  head(df_sq_2020_completed)
  
  ## All 31,535 records from 2020
  df_sq_2020 <- read_csv("Data/df_2020_complete_data.csv")
  head(df_sq_2020)
  
  ## All 31413 records from 2021
  df_sq_2021 <- read_csv("Data/df_2021_complete_data.csv")
  head(df_sq_2021)
  }

### Test Image URLs and remove rows with invalid URLs -----

## Create a function that identifies invalid image URLs
url_check = function(url_in,t=2){
  con <- url(url_in)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=t),silent=T)[1])
  suppressWarnings(try(close.connection(con),silent=T))
  ifelse(is.null(check),TRUE,FALSE)
  }  

## Choose a subset to process and remove invalid URLs
df_sq_2021_noerrors <- df_sq_2021 %>%
  slice(1:10) %>%
  mutate(valid_url = future_map_lgl(image_url, url_check))

### Coordinate extraction -----

## Function that extracts coordinates from a picture
locate_box = function(image_url){
  display(readImage(image_url), 
          temp(),
          method = "raster", all = TRUE)
  locator()
}

## Apply it to a short list
df_2021_1_3 = df_sq_2021_noerrors %>%
  slice(1:3) %>% 
  rowwise() %>%
  mutate(picture_info = list(locate_box(image_url))) %>%
  #remove images without two clicks
  filter(length(picture_info$x) == 2) %>%
  ungroup() %>%
  mutate(sq_location = map(picture_info,
                           ~ c(sort(.[[1]], decreasing = T), 
                               sort(.[[2]], decreasing = T)))) %>% 
  unnest_wider(sq_location, names_sep = "_") %>% 
  # keeps the sq_location to check if code is correct
  dplyr::rename(color_max_x = sq_location_1,
                color_min_x = sq_location_2,
                color_max_y = sq_location_3,
                color_min_y = sq_location_4) %>% 
  mutate(across(starts_with("color"), round))

### Extract RGB values -----

## Function to extract mean RGBs from an image given the coordinates
extract_mean_colour = function(image, xmin, xmax, ymin, ymax){
  readImage(image)[xmin:xmax, ymin:ymax, ] %>% 
    apply(3, mean)
}

## Apply extract colour functions and create columns for red, green, and blue values
df_2021_1_3_col <- df_2021_1_3 %>% 
  rowwise() %>% 
  mutate(mean_rgb = list(extract_mean_colour(image_url,
                                             color_min_x,
                                             color_max_x,
                                             color_min_y,
                                             color_max_y))) %>% 
  unnest_wider(mean_rgb, names_sep = "_") %>%
  rename(mean_red = mean_rgb_1,
         mean_green = mean_rgb_2,
         mean_blue = mean_rgb_3)


### Add new df to existing master df -----

## Generate complete dataset
df_sq_full <- tibble() %>%
  rbind(df_2021_1_3_col)
