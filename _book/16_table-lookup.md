# Table lookup {#lookup}



<!--Original content: https://stat545.com/bit008_lookup.html-->

I try to use [dplyr joins](#join-cheatsheet) for most tasks that combine data from two tibbles. But sometimes you just need good old "table lookup". Party like it's Microsoft Excel `LOOKUP()` time!

## Load gapminder and the tidyverse


```r
library(gapminder)
library(tidyverse)
```

## Create mini Gapminder

Work with a tiny subset of Gapminder, `mini_gap`.


```r
mini_gap <- gapminder %>% 
  filter(country %in% c("Belgium", "Canada", "United States", "Mexico"),
         year > 2000) %>% 
  select(-pop, -gdpPercap) %>% 
  droplevels()
mini_gap
#> # A tibble: 8 x 4
#>   country       continent  year lifeExp
#>   <fct>         <fct>     <int>   <dbl>
#> 1 Belgium       Europe     2002    78.3
#> 2 Belgium       Europe     2007    79.4
#> 3 Canada        Americas   2002    79.8
#> 4 Canada        Americas   2007    80.7
#> 5 Mexico        Americas   2002    74.9
#> 6 Mexico        Americas   2007    76.2
#> 7 United States Americas   2002    77.3
#> 8 United States Americas   2007    78.2
```

## Dorky national food example.

Make a lookup table of national foods. Or at least the stereotype. Yes, I have intentionally kept Mexico in mini-Gapminder and neglected to put Mexico here.


```r
food <- tribble(
        ~ country,    ~ food,
        "Belgium",  "waffle",
         "Canada", "poutine",
  "United States", "Twinkie"
)
food
#> # A tibble: 3 x 2
#>   country       food   
#>   <chr>         <chr>  
#> 1 Belgium       waffle 
#> 2 Canada        poutine
#> 3 United States Twinkie
```

## Lookup national food

`match(x, table)` reports where the values in the key `x` appear in the lookup variable `table`. It returns positive integers for use as indices. It assumes `x` and `table` are free-range vectors, i.e. there's no implicit data frame on the radar here.

Gapminder's `country` plays the role of the key `x`. It is replicated, i.e. non-unique, in `mini_gap`, but not in `food`, i.e. no country appears more than once `food$country`. FYI `match()` actually allows for multiple matches by only consulting the first.


```r
match(x = mini_gap$country, table = food$country)
#> [1]  1  1  2  2 NA NA  3  3
```

In table lookup, there is always a value variable `y` that you plan to index with the `match(x, table)` result.  It often lives together with `table` in a data frame; they should certainly be the same length and synced up with respect to row order.

But first...

I get `x` and `table` backwards some non-negligible percentage of the time. So I store the match indices and index the data frame where `table` lives with it. Add `x` as a column and eyeball-o-metrically assess that all is well.


```r
(indices <- match(x = mini_gap$country, table = food$country))
#> [1]  1  1  2  2 NA NA  3  3
add_column(food[indices, ], x = mini_gap$country)
#> # A tibble: 8 x 3
#>   country       food    x            
#>   <chr>         <chr>   <fct>        
#> 1 Belgium       waffle  Belgium      
#> 2 Belgium       waffle  Belgium      
#> 3 Canada        poutine Canada       
#> 4 Canada        poutine Canada       
#> 5 <NA>          <NA>    Mexico       
#> 6 <NA>          <NA>    Mexico       
#> 7 United States Twinkie United States
#> 8 United States Twinkie United States
```

Once all looks good, do the actual table lookup and, possibly, add the new info to your main table.


```r
mini_gap %>% 
  mutate(food = food$food[indices])
#> # A tibble: 8 x 5
#>   country       continent  year lifeExp food   
#>   <fct>         <fct>     <int>   <dbl> <chr>  
#> 1 Belgium       Europe     2002    78.3 waffle 
#> 2 Belgium       Europe     2007    79.4 waffle 
#> 3 Canada        Americas   2002    79.8 poutine
#> 4 Canada        Americas   2007    80.7 poutine
#> 5 Mexico        Americas   2002    74.9 <NA>   
#> 6 Mexico        Americas   2007    76.2 <NA>   
#> 7 United States Americas   2002    77.3 Twinkie
#> 8 United States Americas   2007    78.2 Twinkie
```

Of course, if this was really our exact task, we could have used a join!


```r
mini_gap %>% 
  left_join(food)
#> Joining, by = "country"
#> # A tibble: 8 x 5
#>   country       continent  year lifeExp food   
#>   <chr>         <fct>     <int>   <dbl> <chr>  
#> 1 Belgium       Europe     2002    78.3 waffle 
#> 2 Belgium       Europe     2007    79.4 waffle 
#> 3 Canada        Americas   2002    79.8 poutine
#> 4 Canada        Americas   2007    80.7 poutine
#> 5 Mexico        Americas   2002    74.9 <NA>   
#> 6 Mexico        Americas   2007    76.2 <NA>   
#> 7 United States Americas   2002    77.3 Twinkie
#> 8 United States Americas   2007    78.2 Twinkie
```

But sometimes you have a substantive reason (or psychological hangup) that makes you prefer the table look up interface.

## World's laziest table lookup

While I'm here, let's demo another standard R trick that's based on indexing by name.

Imagine the table you want to consult isn't even a tibble but is, instead, a named character vector.


```r
(food_vec <- setNames(food$food, food$country))
#>       Belgium        Canada United States 
#>      "waffle"     "poutine"     "Twinkie"
```

Another way to get the national foods for mini-Gapminder is to simply index `food_vec` with `mini_gap$country`.


```r
mini_gap %>% 
  mutate(food = food_vec[country])
#> # A tibble: 8 x 5
#>   country       continent  year lifeExp food   
#>   <fct>         <fct>     <int>   <dbl> <chr>  
#> 1 Belgium       Europe     2002    78.3 waffle 
#> 2 Belgium       Europe     2007    79.4 waffle 
#> 3 Canada        Americas   2002    79.8 poutine
#> 4 Canada        Americas   2007    80.7 poutine
#> 5 Mexico        Americas   2002    74.9 Twinkie
#> 6 Mexico        Americas   2007    76.2 Twinkie
#> 7 United States Americas   2002    77.3 <NA>   
#> 8 United States Americas   2007    78.2 <NA>
```

HOLD ON. STOP. Twinkies aren't the national food of Mexico!?! What went wrong?

Remember `mini_gap$country` is a factor. So when we use it in an indexing context, it's integer nature is expressed. It is pure luck that we get the right foods for Belgium and Canada. Luckily the Mexico - United States situation tipped us off. Here's what we are really indexing `food_vec` by above:


```r
unclass(mini_gap$country)
#> [1] 1 1 2 2 3 3 4 4
#> attr(,"levels")
#> [1] "Belgium"       "Canada"        "Mexico"        "United States"
```

To get our desired result, we need to explicitly coerce `mini_gap$country` to character.


```r
mini_gap %>% 
  mutate(food = food_vec[as.character(country)])
#> # A tibble: 8 x 5
#>   country       continent  year lifeExp food   
#>   <fct>         <fct>     <int>   <dbl> <chr>  
#> 1 Belgium       Europe     2002    78.3 waffle 
#> 2 Belgium       Europe     2007    79.4 waffle 
#> 3 Canada        Americas   2002    79.8 poutine
#> 4 Canada        Americas   2007    80.7 poutine
#> 5 Mexico        Americas   2002    74.9 <NA>   
#> 6 Mexico        Americas   2007    76.2 <NA>   
#> 7 United States Americas   2002    77.3 Twinkie
#> 8 United States Americas   2007    78.2 Twinkie
```

When your key variable is character (and not a factor), you can skip this step.



<!--STAT 545 external resources/content-->
[useR-2014-dropbox]: https://www.dropbox.com/sh/i8qnluwmuieicxc/AAAgt9tIKoIm7WZKIyK25lh6a
[Tidy data using Lord of the Rings]: https://github.com/jennybc/lotr-tidy#readme
[ggplot2 tutorial]: https://github.com/jennybc/ggplot2-tutorial
[R Graph Catalog]: https://github.com/jennybc/r-graph-catalog

<!--Packages: main link-->
[dplyr]: https://dplyr.tidyverse.org
[tidyr]: https://tidyr.tidyverse.org
[ggplot2]: https://ggplot2.tidyverse.org
[tidyverse]: https://tidyverse.tidyverse.org
[stringr]: https://stringr.tidyverse.org
[forcats]: https://forcats.tidyverse.org
[purrr]: https://purrr.tidyverse.org
[readr]: https://readr.tidyverse.org
[fs]: https://fs.r-lib.org/index.html
[glue]: https://glue.tidyverse.org
[testthat]: https://testthat.r-lib.org
[ellipsis]: https://ellipsis.r-lib.org
[lubridate]: https://lubridate.tidyverse.org
[devtools]: https://devtools.r-lib.org
[roxygen2]: https://roxygen2.r-lib.org
[knitr]: https://github.com/yihui/knitr
[usethis]: https://usethis.r-lib.org
[xml2]: https://xml2.r-lib.org
[httr]: https://httr.r-lib.org
[rvest]: https://rvest.tidyverse.org
[Shiny]: https://shiny.rstudio.com
[gh]: https://github.com/r-lib/gh
[plyr]: http://plyr.had.co.nz
[magrittr]: https://magrittr.tidyverse.org
[googlesheets]: https://github.com/jennybc/googlesheets
[gapminder]: https://github.com/jennybc/gapminder
[stringi]: http://www.gagolewski.com/software/stringi/
[rex]: https://github.com/kevinushey/rex
[lattice]: http://lattice.r-forge.r-project.org
[RColorBrewer]: https://cloud.r-project.org/package=RColorBrewer
[gridExtra]: https://cloud.r-project.org/package=gridExtra
[rebird]: https://docs.ropensci.org/rebird/
[geonames]: https://docs.ropensci.org/geonames/
[rplos]: https://docs.ropensci.org/rplos/
[gender]: https://docs.ropensci.org/gender/
[genderdata]: https://docs.ropensci.org/genderdata/
[curl]: https://jeroen.cran.dev/curl
[jsonlite]: https://github.com/jeroen/jsonlite
[shinythemes]: https://rstudio.github.io/shinythemes/
[shinyjs]: https://deanattali.com/shinyjs/
[leaflet]: https://rstudio.github.io/leaflet/
[ggvis]: https://ggvis.rstudio.com
[shinydashboard]: https://rstudio.github.io/shinydashboard/

<!--Packages: vignettes & CRAN/GitHub links-->
[Introduction to dplyr]: https://dplyr.tidyverse.org/articles/dplyr.html
[Window functions]: https://dplyr.tidyverse.org/articles/window-functions.html
[Two-table verbs]: https://dplyr.tidyverse.org/articles/two-table.html
[Do more with dates and times in R]: https://lubridate.tidyverse.org/articles/lubridate.html
[dplyr-cran]: https://cloud.r-project.org/package=dplyr
[dplyr-github]: https://github.com/hadley/dplyr

<!--Bookdowns: main link-->
[Happy Git and GitHub for the useR]: https://happygitwithr.com
[R for Data Science]: https://r4ds.had.co.nz
[The tidyverse style guide]: https://style.tidyverse.org
[Advanced R]: http://adv-r.had.co.nz
[Tidyverse design principles]: https://principles.tidyverse.org
[R Packages]: https://r-pkgs.org/index.html
[R Graphics Cookbook]: http://shop.oreilly.com/product/0636920023135.do
[Cookbook for R]: http://www.cookbook-r.com 
[ggplot2: Elegant Graphics for Data Analysis]: https://ggplot2-book.org/index.html

<!--Bookdowns: specific chapters-->
[adv-r-fxn-args]: http://adv-r.had.co.nz/Functions.html#function-arguments
[r4ds-transform]: https://r4ds.had.co.nz/transform.html
[r4ds-readr-strings]: https://r4ds.had.co.nz/data-import.html#readr-strings

<!--RStudio Cheat Sheets--> 
[RStudio Data Transformation Cheat Sheet]: https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf
[Regular Expressions in R Cheat Sheet]: https://github.com/rstudio/cheatsheets/raw/master/regex.pdf
[Shiny Cheat Sheet]: https://shiny.rstudio.com/articles/cheatsheet.html

<!--Blog posts, slides, & papers-->
["minimal make: a minimal tutorial on make"]: https://kbroman.org/minimal_make/
["Let the Data Flow: Pipelines in R with dplyr and magrittr"]: https://github.com/tjmahr/MadR_Pipelines
["Hands-on dplyr tutorial for faster data manipulation in R"]: https://www.dataschool.io/dplyr-tutorial-for-faster-data-manipulation-in-r/
["Writing R Extensions"]: https://cloud.r-project.org/doc/manuals/r-release/R-exts.html
["The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets (No Excuses!)"]: https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/
["What Every Programmer Absolutely, Positively Needs To Know About Encodings And Character Sets To Work With Text"]: http://kunststube.net/encoding/
["3 Steps to Fix Encoding Problems in Ruby"]: https://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
["My favorite RGB color"]: https://manyworldstheory.com/2013/01/15/my-favorite-rgb-color/

<!--Papers/Books Cited-->
["Dates and Times Made Easy with lubridate"]: https://www.jstatsoft.org/article/view/v040i03
["testthat: Get Started with Testing"]: https://journal.r-project.org/archive/2011-1/RJournal_2011-1_Wickham.pdf
["Let's Practice What We Preach"]: https://www.jstor.org/stable/3087382?seq=1#page_scan_tab_contents
[Creating More Effective Graphs]: https://www.amazon.com/Creating-Effective-Graphs-Naomi-Robbins/dp/0985911123
["Escaping RGBland: Selecting Colors for Statistical Graphs"]: https://eeecon.uibk.ac.at/~zeileis/papers/Zeileis+Hornik+Murrell-2009.pdf
["A layered grammar of graphics"]: https://vita.had.co.nz/papers/layered-grammar.html
[Managing Projects with GNU Make, 3rd Edition]: http://shop.oreilly.com/product/9780596006105.do
["Why Should Engineers and Scientists Be Worried About Color?"]: https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=2ahUKEwi0xYqJ8JbjAhWNvp4KHViYDxsQFjABegQIABAC&url=https%3A%2F%2Fwww.researchgate.net%2Fprofile%2FAhmed_Elhattab2%2Fpost%2FPlease_suggest_some_good_3D_plot_tool_Software_for_surface_plot%2Fattachment%2F5c05ba35cfe4a7645506948e%2FAS%253A699894335557644%25401543879221725%2Fdownload%2FWhy%2BShould%2BEngineers%2Band%2BScientists%2BBe%2BWorried%2BAbout%2BColor_.pdf&usg=AOvVaw1qwjjGMd7h_z6TLUjzu7Nb

<!--Misc.-->
[rOpenSci]: https://ropensci.org
[wiki-snake-case]: https://en.wikipedia.org/wiki/Snake_case
[Janus]: https://en.wikipedia.org/wiki/Janus
