# (PART) Data analysis 3 {-} 

# When one tibble is not enough {#multiple-tibbles}



<!--Original content: https://stat545.com/block033_working-with-two-tables.html-->

We've covered many topics on how to manipulate and reshape a single data frame:

* Chapter \@ref(basic-data-care) - Basic care and feeding of data in R
  + Data frames (and tibbles) are awesome.
* Chapter \@ref(dplyr-intro) - Introduction to dplyr
  + Filter, select, the pipe.
* Chapter \@ref(dplyr-single) - dplyr functions for a single dataset
  + Single table verbs.
* Chapter \@ref(tidy-data) - Tidy data using Lord of the Rings
  + Tidy data, [tidyr]. 
  + *This actually kicks off with a row bind operation, discussed below.*

But what if your data arrives in many pieces? There are many good (and bad) reasons why this might happen. How do you get it into one big beautiful tibble? These tasks break down into 3 main classes:

* Bind
* Join
* Lookup

## Typology of data combination tasks

__Bind__ - This is basically smashing ~~rocks~~ tibbles together. You can smash things together row-wise ("row binding") or column-wise ("column binding"). Why do I characterize this as rock-smashing? They're often fairly crude operations, with lots of responsibility falling on the analyst for making sure that the whole enterprise even makes sense.

When row binding, you need to consider the variables in the two tibbles. Do the same variables exist in each? Are they of the same type? Different approaches for row binding have different combinations of flexibility vs. rigidity around these matters.

When column binding, the onus is entirely on the analyst to make sure that the rows are aligned. I would avoid column binding whenever possible. If you can introduce new variables through any other, safer means, do so! By safer, I mean: use a mechanism where the row alignment is correct **by definition**. A proper join is the gold standard. In addition to joins, functions like `dplyr::mutate()` and `tidyr::separate()` can be very useful for forcing yourself to work inside the constraint of a tibble.

__Join__ - Here you designate a variable (or a combination of variables) as a **key**. A row in one data frame gets matched with a row in another data frame because they have the same key. You can then bring information from variables in a secondary data frame into a primary data frame based on this key-based lookup. That description is incredibly oversimplified, but that's the basic idea.

A variety of row- and column-wise operations fit into this framework, which implies there are many different flavors of join. The concepts and vocabulary around joins come from the database world. The relevant functions in dplyr follow this convention and all mention `join`. The most relevant base R function is `merge()`.

__Lookup__ - Lookups are really just a special case of join. But it's a special case worth making for two reasons:

* If you've ever used `LOOKUP()` and friends in Excel, you already have a mental model for this. Let's exploit that!
* Joins are defined in terms of two tables or data frames. But sometimes this task has a "vector" vibe. You might be creating a vector or variable. Or maybe the secondary data source is a named vector. In any case, there's at least one vector in the mix. I call that a lookup.

Let's explore each type of operation with a few examples.

First, let's load the tidyverse (and expose version information).


```r
library(tidyverse)
#> ── Attaching packages ──────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.3     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ─────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

## Bind

### Row binding

We used word count data from the Lord of the Rings trilogy to explore the concept of tidy data in Chapter \@ref(tidy-data). That kicked off with a quiet, successful row bind. Let's revisit that.

Here's what a perfect row bind of three (untidy!) data frames looks like.


```r
fship <- tribble(
                         ~Film,    ~Race, ~Female, ~Male,
  "The Fellowship Of The Ring",    "Elf",    1229,   971,
  "The Fellowship Of The Ring", "Hobbit",      14,  3644,
  "The Fellowship Of The Ring",    "Man",       0,  1995
)
rking <- tribble(
                         ~Film,    ~Race, ~Female, ~Male,
      "The Return Of The King",    "Elf",     183,   510,
      "The Return Of The King", "Hobbit",       2,  2673,
      "The Return Of The King",    "Man",     268,  2459
)
ttow <- tribble(
                         ~Film,    ~Race, ~Female, ~Male,
              "The Two Towers",    "Elf",     331,   513,
              "The Two Towers", "Hobbit",       0,  2463,
              "The Two Towers",    "Man",     401,  3589
)
(lotr_untidy <- bind_rows(fship, ttow, rking))
#> # A tibble: 9 x 4
#>   Film                       Race   Female  Male
#>   <chr>                      <chr>   <dbl> <dbl>
#> 1 The Fellowship Of The Ring Elf      1229   971
#> 2 The Fellowship Of The Ring Hobbit     14  3644
#> 3 The Fellowship Of The Ring Man         0  1995
#> 4 The Two Towers             Elf       331   513
#> 5 The Two Towers             Hobbit      0  2463
#> 6 The Two Towers             Man       401  3589
#> 7 The Return Of The King     Elf       183   510
#> 8 The Return Of The King     Hobbit      2  2673
#> 9 The Return Of The King     Man       268  2459
```

`dplyr::bind_rows()` works like a charm with these very row-bindable data frames! So does base `rbind()` (try it!).

But what if one of the data frames is somehow missing a variable? Let's mangle one and find out.


```r
ttow_no_Female <- ttow %>% mutate(Female = NULL)
bind_rows(fship, ttow_no_Female, rking)
#> # A tibble: 9 x 4
#>   Film                       Race   Female  Male
#>   <chr>                      <chr>   <dbl> <dbl>
#> 1 The Fellowship Of The Ring Elf      1229   971
#> 2 The Fellowship Of The Ring Hobbit     14  3644
#> 3 The Fellowship Of The Ring Man         0  1995
#> 4 The Two Towers             Elf        NA   513
#> 5 The Two Towers             Hobbit     NA  2463
#> 6 The Two Towers             Man        NA  3589
#> 7 The Return Of The King     Elf       183   510
#> 8 The Return Of The King     Hobbit      2  2673
#> 9 The Return Of The King     Man       268  2459
rbind(fship, ttow_no_Female, rking)
#> Error in rbind(deparse.level, ...): numbers of columns of arguments do not match
```

We see that `dplyr::bind_rows()` does the row bind and puts `NA` in for the missing values caused by the lack of `Female` data from The Two Towers. Base `rbind()` refuses to row bind in this situation.

I invite you to experiment with other realistic, challenging scenarios, e.g.:

* Change the order of variables. Does row binding match variables by name or position?
* Row bind data frames where the variable `x` is of one type in one data frame and another type in the other. Try combinations that you think should work and some that should not. What actually happens?
* Row bind data frames in which the factor `x` has different levels in one data frame and different levels in the other. What happens?

In conclusion, row binding usually works when it should (especially with `dplyr::bind_rows()`) and usually doesn't when it shouldn't. The biggest risk is being aggravated.

### Column binding

Column binding is much more dangerous because it often "works" when it should not. It's **your job** to the rows are aligned and it's all too easy to screw this up.

The data in `gapminder` was originally excavated from 3 messy Excel spreadsheets: one each for life expectancy, population, and GDP per capital. Let's relive some of the data wrangling joy and show a column bind gone wrong.

I create 3 separate data frames, do some evil row sorting, then column bind. There are no errors. The result `gapminder_garbage` sort of looks OK. Univariate summary statistics and exploratory plots will look OK. But I've created complete nonsense!


```r
library(gapminder)

life_exp <- gapminder %>%
  select(country, year, lifeExp)

pop <- gapminder %>%
  arrange(year) %>% 
  select(pop)
  
gdp_percap <- gapminder %>% 
  arrange(pop) %>% 
  select(gdpPercap)

(gapminder_garbage <- bind_cols(life_exp, pop, gdp_percap))
#> # A tibble: 1,704 x 5
#>    country      year lifeExp      pop gdpPercap
#>    <fct>       <int>   <dbl>    <int>     <dbl>
#>  1 Afghanistan  1952    28.8  8425333      880.
#>  2 Afghanistan  1957    30.3  1282697      861.
#>  3 Afghanistan  1962    32.0  9279525     2670.
#>  4 Afghanistan  1967    34.0  4232095     1072.
#>  5 Afghanistan  1972    36.1 17876956     1385.
#>  6 Afghanistan  1977    38.4  8691212     2865.
#>  7 Afghanistan  1982    39.9  6927772     1533.
#>  8 Afghanistan  1987    40.8   120447     1738.
#>  9 Afghanistan  1992    41.7 46886859     3021.
#> 10 Afghanistan  1997    41.8  8730405     1890.
#> # … with 1,694 more rows

summary(gapminder$lifeExp)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    23.6    48.2    60.7    59.5    70.8    82.6
summary(gapminder_garbage$lifeExp)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    23.6    48.2    60.7    59.5    70.8    82.6
range(gapminder$gdpPercap)
#> [1]    241 113523
range(gapminder_garbage$gdpPercap)
#> [1]    241 113523
```

One last cautionary tale about column binding. This one requires the use of `cbind()` and it's why the tidyverse is generally unwilling to recycle when combining things of different length.

I create a tibble with most of the `gapminder` columns. I create another with the remainder, but filtered down to just one country. I am able to `cbind()` these objects! Why? Because the 12 rows for Canada divide evenly into the 1704 rows of `gapminder`. Note that `dplyr::bind_cols()` refuses to column bind here.


```r
gapminder_mostly <- gapminder %>% select(-pop, -gdpPercap)
gapminder_leftovers_filtered <- gapminder %>% 
  filter(country == "Canada") %>% 
  select(pop, gdpPercap)

gapminder_nonsense <- cbind(gapminder_mostly, gapminder_leftovers_filtered)
head(gapminder_nonsense, 14)
#>        country continent year lifeExp      pop gdpPercap
#> 1  Afghanistan      Asia 1952    28.8 14785584     11367
#> 2  Afghanistan      Asia 1957    30.3 17010154     12490
#> 3  Afghanistan      Asia 1962    32.0 18985849     13462
#> 4  Afghanistan      Asia 1967    34.0 20819767     16077
#> 5  Afghanistan      Asia 1972    36.1 22284500     18971
#> 6  Afghanistan      Asia 1977    38.4 23796400     22091
#> 7  Afghanistan      Asia 1982    39.9 25201900     22899
#> 8  Afghanistan      Asia 1987    40.8 26549700     26627
#> 9  Afghanistan      Asia 1992    41.7 28523502     26343
#> 10 Afghanistan      Asia 1997    41.8 30305843     28955
#> 11 Afghanistan      Asia 2002    42.1 31902268     33329
#> 12 Afghanistan      Asia 2007    43.8 33390141     36319
#> 13     Albania    Europe 1952    55.2 14785584     11367
#> 14     Albania    Europe 1957    59.3 17010154     12490
```

This data frame isn't obviously wrong, but it is wrong. See how the Canada's population and GDP per capita repeat for each country?

Bottom line: Row bind when you need to, but inspect the results re: coercion. Column bind only if you must and be extremely paranoid.

## Joins in dplyr

Visit Chapter \@ref(join-cheatsheet) to see concrete examples of all the joins implemented in dplyr, based on comic characters and publishers.

The most recent release of gapminder includes a new data frame, `country_codes`, with country names and ISO codes. Therefore you can also use it to practice joins.


```r
gapminder %>% 
  select(country, continent) %>% 
  group_by(country) %>% 
  slice(1) %>% 
  left_join(country_codes)
#> Joining, by = "country"
#> # A tibble: 142 x 4
#> # Groups:   country [142]
#>    country     continent iso_alpha iso_num
#>    <chr>       <fct>     <chr>       <int>
#>  1 Afghanistan Asia      AFG             4
#>  2 Albania     Europe    ALB             8
#>  3 Algeria     Africa    DZA            12
#>  4 Angola      Africa    AGO            24
#>  5 Argentina   Americas  ARG            32
#>  6 Australia   Oceania   AUS            36
#>  7 Austria     Europe    AUT            40
#>  8 Bahrain     Asia      BHR            48
#>  9 Bangladesh  Asia      BGD            50
#> 10 Belgium     Europe    BEL            56
#> # … with 132 more rows
```

## Table Lookup

See Chapter \@ref(lookup) for examples.


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
