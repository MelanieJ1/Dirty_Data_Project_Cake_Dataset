

####### Dirty Data Project - Task 2 - Cake Ingredients

#### Cleaning script for cake data

## Loading packages

library(tidyverse)
library(dplyr)
library(janitor)
library(tidyr)
library(here)

##Loading in cake data

cake_ingredients <- read_csv(here("raw_data/cake-ingredients-1961.csv"))
ingredient_code <- read_csv(here("raw_data/cake_ingredient_code.csv"))

glimpse(cake_ingredients)
glimpse(ingredient_code)


## Converting column BM from data type logical to double.

cake_ingredients_bm <- transform(cake_ingredients, BM = as.double(BM))
glimpse(cake_ingredients_bm)




##Pivoting cake_ingredients table.

cake_ingredients_1 <- cake_ingredients_bm %>%
  pivot_longer(!Cake, names_to = "code", values_to = "amount_of_measure")


## Combining cake_ingredients_1 with ingredient_code on code column.

cake_ingredients_combined <- merge(cake_ingredients_1, ingredient_code, by = 'code')


## Converting NAs to value 0.
cake_ingredients_na <- cake_ingredients_combined %>%
  mutate(amount_of_measure = coalesce(amount_of_measure, 0))

glimpse(cake_ingredients_na)

cake_ingredients_na %>%
  summarise(across(.cols = everything(), .fns = ~ sum(is.na(.x))))


##Converting NAs in measure column to cup.

cake_ingredients_no_na %>%
  filter(code == "SC")
         

cake_ingredients_no_na[is.na(cake_ingredients_no_na)] = "cup"


cake_ingredients_no_na_2 <- str_replace_all(cake_ingredients_no_na$ingredient, "Sour cream cup", "Sour cream")
cake_ingredients_no_na_2

cake_ingredients_clean_1 <- cake_ingredients_no_na %>%
  mutate(ingredient = cake_ingredients_no_na_2)




## Clean column names

cake_ingredients_clean <- cake_ingredients_clean_1 %>%
  clean_names()

view(cake_ingredients_clean)



## Writing .csv into clean data folder..

write.csv(cake_ingredients_clean, "clean_data/cake_ingredients_clean.csv")


