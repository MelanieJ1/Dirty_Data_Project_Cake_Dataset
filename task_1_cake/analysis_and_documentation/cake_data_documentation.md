<h1>Cake Data Project Report</h1>
<h2>Introduction</h2>
This project consists of two datasets of raw data, cake-ingredients-1961.csv and cake_ingredient_code.csv. The cake ingredients dataset contains names of cake types and the code for the ingredients they contain.  The values are the amount of ingredient used.  The cake_ingredient_code dataset contains the ingredient code and the name and measure of each ingredient. 
The datasets were cleaned and combined to create the dataset cake_ingredients_clean.csv.  This dataset contains the columns code, cake, amount of measure, ingredient and measure.  

<h2>Assumptions in the Data</h2>
<li>for amount of ingredient sour cream, it was assumed the measurement was 1 cup taken from the ingredient column name.</li>

<h2>Steps taken to clean data</h2>

<h3>Packages used to clean data</h3>
<ul>
<li>library(tidyverse)</li>
<li>library(dplyr)</li>
<li>library(janitor)</li>
<li>library(tidyr)</li>
<li>library(here)</li>
</ul>


<h3>Converting column BM from data type logical to double.</h3>
<p> Using glimpse() it was determined that the BM column data type was logical.  It was then converted using the following code.</P
cake_ingredients_bm <- transform(cake_ingredients, BM = as.double(BM))</br>
glimpse(cake_ingredients_bm)<br/>

<h3>Pivoting cake_ingredients table and combining data.</h3>
<p> The data was picoted to show code with the values as the amount of measure.</p> 
cake_ingredients_1 <- cake_ingredients_bm %>%<br/>
  pivot_longer(!Cake, names_to = "code", values_to = "amount_of_measure")<br/>

<p>The data from the two sets was combined using merge().</p>
cake_ingredients_combined <- merge(cake_ingredients_1, ingredient_code, by = 'code')<br/>


<h3>Converting NAs to value 0.</h3>
<p>The NA values in amount of measure were converted to 0 using coalesce(). </p>
cake_ingredients_na <- cake_ingredients_combined %>%<br/>
  mutate(amount_of_measure = coalesce(amount_of_measure, 0))<br/>

glimpse(cake_ingredients_na)<br/>

cake_ingredients_na %>%<br/>
  summarise(across(.cols = everything(), .fns = ~ sum(is.na(.x))))<br/>
<p>All columns were checked for NAs and they were only found in the measure column for ingredient Sour Cream.</p>

<h3>Converting NAs in measure column to cup.</h3>         
cake_ingredients_no_na[is.na(cake_ingredients_no_na)] = "cup"<br/>

cake_ingredients_no_na_2 <- str_replace_all(cake_ingredients_no_na$ingredient, "Sour cream cup", "Sour cream")<br/>
cake_ingredients_clean_1 <- cake_ingredients_no_na %>%<br/>
  mutate(ingredient = cake_ingredients_no_na_2)<br/>


<h3>Clean column names</h3>
<p> Column names were tidied using clean_names(). </p>
cake_ingredients_clean <- cake_ingredients_clean_1 %>%<br/>
  clean_names()</br>

<h3>Writing .csv into clean data folder.</h3>
<p>The clean dataset was written into a csv file named cake_ingredients_clean.csv</p>
write.csv(cake_ingredients_clean, "clean_data/cake_ingredients_clean.csv")<br/>

<h2>Answers to Analysis Questions</h2>
<p>Question 1. Which cake has the most cocoa in it?</p>
cake_ingredients_data %>%<br/>
  filter(ingredient == "Cocoa")</br>


<p>Question 2. For sponge cake, how many cups of ingredients are used in total?</p >
ingredient_cups <- cake_ingredients_data %>%<br/>
  filter(cake == "Sponge", measure == "cup") %>% <br/>
  group_by(measure == "cup") %>% <br/>
  count(amount_of_measure)<br/>
  
ingredient_cups_2 <- ingredient_cups %>%</br>
  mutate(total = amount_of_measure * n, na.rm=TRUE)</br>

sum(ingredient_cups_2$total)<br/>
<p>The number of cups of ingredients used is 3.5.</p>


<p>Question 3. How many ingredients are measured in teaspoons?</p>
cake_group <- cake_ingredients_data %>%<br/> 
  filter(measure == "teaspoon", amount_of_measure > 0) %>%<br/>
  group_by("ingredient")<br/>
unique(cake_group$ingredient)<br/>
<p>Eight ingredients are measured in teaspoons.</p>
 
<p>Question 4. Which cake has the most unique ingredients?</p>
cake_unique <- cake_ingredients_data %>% <br/>
  filter(amount_of_measure > 0)<br/>
table(cake_unique$cake)<br/>

<p>Question 5. Which ingredients are used only once?</p>
ingredient_count <- cake_ingredients_data %>%<br/>
  filter(amount_of_measure > 0)<br/>
 
table(ingredient_count$ingredient)<br/>
<p>Bananas, Cream of tartar, Crushed Ice, Dried Currants, Egg white, Nutmeg, Nuts, Zwiebach are used once.</p>
