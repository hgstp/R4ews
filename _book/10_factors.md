# (PART) Data analysis 2 {-} 

# Be the boss of your factors {#factors-boss}



<!--Original content: https://stat545.com/block029_factors.html-->

## Factors: where they fit in

We've spent a lot of time working with big, beautiful data frames, like the Gapminder data. But we also need to manage the individual variables housed within.

Factors are the variable type that useRs love to hate. It is how we store truly categorical information in R. The values a factor can take on are called the **levels**. For example, the levels of the factor `continent` in Gapminder are are "Africa", "Americas", etc. and this is what's usually presented to your eyeballs by R. In general, the levels are friendly human-readable character strings, like "male/female" and "control/treated". But *never ever ever* forget that, under the hood, R is really storing integer codes 1, 2, 3, etc.

This [Janus]-like nature of factors means they are rich with booby traps for the unsuspecting but they are a necessary evil. I recommend you learn how to be the boss of your factors. The pros far outweigh the cons. Specifically in modelling and figure-making, factors are anticipated and accommodated by the functions and packages you will want to exploit.

**The worst kind of factor is the stealth factor.** The variable that you think of as character, but that is actually a factor (numeric!!). This is a classic R gotcha. Check your variable types explicitly when things seem weird. It happens to the best of us.

Where do stealth factors come from? Base R has a burning desire to turn character information into factor. The happens most commonly at data import via `read.table()` and friends. But `data.frame()` and other functions are also eager to convert character to factor. To shut this down, use `stringsAsFactors = FALSE` in `read.table()` and `data.frame()` or -- even better -- **use the tidyverse**! For data import, use `readr::read_csv()`, `readr::read_tsv()`, etc. For data frame creation, use `tibble::tibble()`. And so on.

Good articles about how the factor fiasco came to be:

* ["stringsAsFactors: An unauthorized biography"](https://simplystatistics.org/2015/07/24/stringsasfactors-an-unauthorized-biography) by Roger Peng
* ["stringsAsFactors = \<sigh\>"](https://notstatschat.tumblr.com/post/124987394001/stringsasfactors-sigh) by Thomas Lumley

## The forcats package

[forcats] is a core package in the [tidyverse]. It is installed via `install.packages("tidyverse")`, and loaded with `library(tidyverse)`. You can also install via `install.packages("forcats")`and load it yourself separately as needed via `library(forcats)`. Main functions start with `fct_`. There really is no coherent family of base functions that forcats replaces -- that's why it's such a welcome addition.

Currently this lesson will be mostly code vs. prose. See the previous lesson for more discussion during the transition.

## Load forcats and gapminder

I choose to load the tidyverse, which will load forcats, among other packages we use incidentally below. 


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

Also load [gapminder].


```r
library(gapminder)
```

## Factor inspection

Get to know your factor before you start touching it! It's polite. Let's use `gapminder$continent` as our example.


```r
str(gapminder$continent)
#>  Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
levels(gapminder$continent)
#> [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
nlevels(gapminder$continent)
#> [1] 5
class(gapminder$continent)
#> [1] "factor"
```

To get a frequency table as a tibble, from a tibble, use `dplyr::count()`. To get similar from a free-range factor, use `forcats::fct_count()`.


```r
gapminder %>% 
  count(continent)
#> # A tibble: 5 x 2
#>   continent     n
#>   <fct>     <int>
#> 1 Africa      624
#> 2 Americas    300
#> 3 Asia        396
#> 4 Europe      360
#> 5 Oceania      24
fct_count(gapminder$continent)
#> # A tibble: 5 x 2
#>   f            n
#>   <fct>    <int>
#> 1 Africa     624
#> 2 Americas   300
#> 3 Asia       396
#> 4 Europe     360
#> 5 Oceania     24
```

## Dropping unused levels

Just because you drop all the rows corresponding to a specific factor level, the levels of the factor itself do not change. Sometimes all these unused levels can come back to haunt you later, e.g., in figure legends.

Watch what happens to the levels of `country` (= nothing) when we filter Gapminder to a handful of countries.


```r
nlevels(gapminder$country)
#> [1] 142
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries)
nlevels(h_gap$country)
#> [1] 142
```

Even though `h_gap` only has data for a handful of countries, we are still schlepping around all 142 levels from the original `gapminder` tibble.

How can you get rid of them? The base function `droplevels()` operates on all the factors in a data frame or on a single factor. The function `forcats::fct_drop()` operates on a factor.


```r
h_gap_dropped <- h_gap %>% 
  droplevels()
nlevels(h_gap_dropped$country)
#> [1] 5

## use forcats::fct_drop() on a free-range factor
h_gap$country %>%
  fct_drop() %>%
  levels()
#> [1] "Egypt"     "Haiti"     "Romania"   "Thailand"  "Venezuela"
```

__Exercise:__ Filter the gapminder data down to rows where population is less than a quarter of a million, i.e. 250,000. Get rid of the unused factor levels for `country` and `continent` in different ways, such as:

* `droplevels()`
* `fct_drop()` inside `mutate()`
* `fct_dopr()` with `mutate_at()` or `mutate_if()`



## Change order of the levels, principled {#reorder-factors}

By default, factor levels are ordered alphabetically. Which might as well be random, when you think about it! It is preferable to order the levels according to some principle:

* Frequency. Make the most common level the first and so on.
* Another variable. Order factor levels according to a summary statistic for another variable. Example: order Gapminder countries by life expectancy.

First, let's order continent by frequency, forwards and backwards. This is often a great idea for tables and figures, especially frequency barplots.


```r
## default order is alphabetical
gapminder$continent %>%
  levels()
#> [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"

## order by frequency
gapminder$continent %>% 
  fct_infreq() %>%
  levels()
#> [1] "Africa"   "Asia"     "Europe"   "Americas" "Oceania"

## backwards!
gapminder$continent %>% 
  fct_infreq() %>%
  fct_rev() %>% 
  levels()
#> [1] "Oceania"  "Americas" "Europe"   "Asia"     "Africa"
```

These two barcharts of frequency by continent differ only in the order of the continents. Which do you prefer?


\includegraphics[width=0.49\linewidth]{10_factors_files/figure-latex/unnamed-chunk-9-1} \includegraphics[width=0.49\linewidth]{10_factors_files/figure-latex/unnamed-chunk-9-2} 

Now we order `country` by another variable, forwards and backwards. This other variable is usually quantitative and you will order the factor according to a grouped summary. The factor is the grouping variable and the default summarizing function is `median()` but you can specify something else.


```r
## order countries by median life expectancy
fct_reorder(gapminder$country, gapminder$lifeExp) %>% 
  levels() %>% head()
#> [1] "Sierra Leone"  "Guinea-Bissau" "Afghanistan"   "Angola"       
#> [5] "Somalia"       "Guinea"

## order accoring to minimum life exp instead of median
fct_reorder(gapminder$country, gapminder$lifeExp, min) %>% 
  levels() %>% head()
#> [1] "Rwanda"       "Afghanistan"  "Gambia"       "Angola"      
#> [5] "Sierra Leone" "Cambodia"

## backwards!
fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>% 
  levels() %>% head()
#> [1] "Iceland"     "Japan"       "Sweden"      "Switzerland"
#> [5] "Netherlands" "Norway"
```

Example of why we reorder factor levels: often makes plots much better! When a factor is mapped to x or y, it should almost always be reordered by the quantitative variable you are mapping to the other one.



Compare the interpretability of these two plots of life expectancy in Asian countries in 2007. The *only difference* is the order of the `country` factor. Which one do you find easier to learn from?


```r
gap_asia_2007 <- gapminder %>% filter(year == 2007, continent == "Asia")
ggplot(gap_asia_2007, aes(x = lifeExp, y = country)) + geom_point()
ggplot(gap_asia_2007, aes(x = lifeExp, y = fct_reorder(country, lifeExp))) +
  geom_point()
```


\includegraphics[width=0.49\linewidth]{10_factors_files/figure-latex/alpha-order-silly-1} \includegraphics[width=0.49\linewidth]{10_factors_files/figure-latex/alpha-order-silly-2} 

Use `fct_reorder2()` when you have a line chart of a quantitative x against another quantitative y and your factor provides the color. This way the legend appears in some order as the data! Contrast the legend on the left with the one on the right.


```r
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries) %>% 
  droplevels()
ggplot(h_gap, aes(x = year, y = lifeExp, color = country)) +
  geom_line()
ggplot(h_gap, aes(x = year, y = lifeExp,
                  color = fct_reorder2(country, year, lifeExp))) +
  geom_line() +
  labs(color = "country")
```


\includegraphics[width=0.49\linewidth]{10_factors_files/figure-latex/legends-made-for-humans-1} \includegraphics[width=0.49\linewidth]{10_factors_files/figure-latex/legends-made-for-humans-2} 

## Change order of the levels, "because I said so"

Sometimes you just want to hoist one or more levels to the front. Why? Because I said so. This resembles what we do when we move variables to the front with `dplyr::select(special_var, everything())`.


```r
h_gap$country %>% levels()
#> [1] "Egypt"     "Haiti"     "Romania"   "Thailand"  "Venezuela"
h_gap$country %>% fct_relevel("Romania", "Haiti") %>% levels()
#> [1] "Romania"   "Haiti"     "Egypt"     "Thailand"  "Venezuela"
```

This might be useful if you are preparing a report for, say, the Romanian government. The reason for always putting Romania first has nothing to do with the *data*, it is important for external reasons and you need a way to express this.

## Recode the levels

Sometimes you have better ideas about what certain levels should be. This is called recoding.


```r
i_gap <- gapminder %>% 
  filter(country %in% c("United States", "Sweden", "Australia")) %>% 
  droplevels()
i_gap$country %>% levels()
#> [1] "Australia"     "Sweden"        "United States"
i_gap$country %>%
  fct_recode("USA" = "United States", "Oz" = "Australia") %>% levels()
#> [1] "Oz"     "Sweden" "USA"
```

__Exercise:__ Isolate the data for `"Australia"`, `"Korea, Dem. Rep."`, and `"Korea, Rep."` in the 2000x. Revalue the country factor levels to `"Oz"`, `"North Korea"`, and `"South Korea"`.

## Grow a factor

Let's create two data frames, each with data from two countries, dropping unused factor levels.


```r
df1 <- gapminder %>%
  filter(country %in% c("United States", "Mexico"), year > 2000) %>%
  droplevels()
df2 <- gapminder %>%
  filter(country %in% c("France", "Germany"), year > 2000) %>%
  droplevels()
```

The `country` factors in `df1` and `df2` have different levels.


```r
levels(df1$country)
#> [1] "Mexico"        "United States"
levels(df2$country)
#> [1] "France"  "Germany"
```

Can you just combine them?


```r
c(df1$country, df2$country)
#> [1] 1 1 2 2 1 1 2 2
```

Umm, no. That is wrong on many levels! Use `fct_c()` to do this.


```r
fct_c(df1$country, df2$country)
#> [1] Mexico        Mexico        United States United States
#> [5] France        France        Germany       Germany      
#> Levels: Mexico United States France Germany
```

__Exercise:__ Explore how different forms of row binding work behave here, in terms of the `country` variable in the result.


```r
bind_rows(df1, df2)
#> # A tibble: 8 x 6
#>   country       continent  year lifeExp       pop gdpPercap
#>   <fct>         <fct>     <int>   <dbl>     <int>     <dbl>
#> 1 Mexico        Americas   2002    74.9 102479927    10742.
#> 2 Mexico        Americas   2007    76.2 108700891    11978.
#> 3 United States Americas   2002    77.3 287675526    39097.
#> 4 United States Americas   2007    78.2 301139947    42952.
#> 5 France        Europe     2002    79.6  59925035    28926.
#> 6 France        Europe     2007    80.7  61083916    30470.
#> 7 Germany       Europe     2002    78.7  82350671    30036.
#> 8 Germany       Europe     2007    79.4  82400996    32170.
rbind(df1, df2)
#> # A tibble: 8 x 6
#>   country       continent  year lifeExp       pop gdpPercap
#>   <fct>         <fct>     <int>   <dbl>     <int>     <dbl>
#> 1 Mexico        Americas   2002    74.9 102479927    10742.
#> 2 Mexico        Americas   2007    76.2 108700891    11978.
#> 3 United States Americas   2002    77.3 287675526    39097.
#> 4 United States Americas   2007    78.2 301139947    42952.
#> 5 France        Europe     2002    79.6  59925035    28926.
#> 6 France        Europe     2007    80.7  61083916    30470.
#> 7 Germany       Europe     2002    78.7  82350671    30036.
#> 8 Germany       Europe     2007    79.4  82400996    32170.
```



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
