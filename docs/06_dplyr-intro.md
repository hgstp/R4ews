# Introduction to dplyr {#dplyr-intro}



<!--Original content: https://stat545.com/block009_dplyr-intro.html-->

## Intro

[dplyr] is a package for data manipulation, developed by Hadley Wickham and Romain Francois. It is built to be fast, highly expressive, and open-minded about how your data is stored. It is installed as part of the [tidyverse] meta-package and, as a core package, it is among those loaded via `library(tidyverse)`.

dplyr's roots are in an earlier package called [plyr], which implements the ["split-apply-combine" strategy for data analysis](https://www.jstatsoft.org/article/view/v040i01) [@wickham2011a]. Where plyr covers a diverse set of inputs and outputs (e.g., arrays, data frames, lists), dplyr has a laser-like focus on data frames or, in the tidyverse, "tibbles". dplyr is a package-level treatment of the `ddply()` function from plyr, because "data frame in, data frame out" proved to be so incredibly important.

Have no idea what I'm talking about? Not sure if you care? If you use these base R functions: `subset()`, `apply()`, `[sl]apply()`, `tapply()`, `aggregate()`, `split()`, `do.call()`, `with()`, `within()`, then you should keep reading. Also, if you use `for()` loops a lot, you might enjoy learning other ways to iterate over rows or groups of rows or variables in a data frame.

### Load dplyr and gapminder

I choose to load the tidyverse, which will load dplyr, among other packages we use incidentally below. 


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

### Say hello to the `gapminder` tibble

The `gapminder` data frame is a special kind of data frame: a tibble.


```r
gapminder
#> # A tibble: 1,704 x 6
#>    country     continent  year lifeExp      pop gdpPercap
#>    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#>  1 Afghanistan Asia       1952    28.8  8425333      779.
#>  2 Afghanistan Asia       1957    30.3  9240934      821.
#>  3 Afghanistan Asia       1962    32.0 10267083      853.
#>  4 Afghanistan Asia       1967    34.0 11537966      836.
#>  5 Afghanistan Asia       1972    36.1 13079460      740.
#>  6 Afghanistan Asia       1977    38.4 14880372      786.
#>  7 Afghanistan Asia       1982    39.9 12881816      978.
#>  8 Afghanistan Asia       1987    40.8 13867957      852.
#>  9 Afghanistan Asia       1992    41.7 16317921      649.
#> 10 Afghanistan Asia       1997    41.8 22227415      635.
#> # … with 1,694 more rows
```

It's tibble-ness is why we get nice compact printing. For a reminder of the problems with base data frame printing, go type `iris` in the R Console or, better yet, print a data frame to screen that has lots of columns.

Note how `gapminder`'s `class()` includes `tbl_df`; the "tibble" terminology is a nod to this.


```r
class(gapminder)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

There will be some functions, like `print()`, that know about tibbles and do something special. There will others that do not, like `summary()`. In which case the regular data frame treatment will happen, because every tibble is also a regular data frame.

To turn any data frame into a tibble use `as_tibble()`:


```r
as_tibble(iris)
#> # A tibble: 150 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # … with 140 more rows
```

## Think before you create excerpts of your data ...

If you feel the urge to store a little snippet of your data:


```r
(canada <- gapminder[241:252, ])
#> # A tibble: 12 x 6
#>    country continent  year lifeExp      pop gdpPercap
#>    <fct>   <fct>     <int>   <dbl>    <int>     <dbl>
#>  1 Canada  Americas   1952    68.8 14785584    11367.
#>  2 Canada  Americas   1957    70.0 17010154    12490.
#>  3 Canada  Americas   1962    71.3 18985849    13462.
#>  4 Canada  Americas   1967    72.1 20819767    16077.
#>  5 Canada  Americas   1972    72.9 22284500    18971.
#>  6 Canada  Americas   1977    74.2 23796400    22091.
#>  7 Canada  Americas   1982    75.8 25201900    22899.
#>  8 Canada  Americas   1987    76.9 26549700    26627.
#>  9 Canada  Americas   1992    78.0 28523502    26343.
#> 10 Canada  Americas   1997    78.6 30305843    28955.
#> 11 Canada  Americas   2002    79.8 31902268    33329.
#> 12 Canada  Americas   2007    80.7 33390141    36319.
```

Stop and ask yourself ...

> Do I want to create mini datasets for each level of some factor (or unique combination of several factors) ... in order to compute or graph something?  

If YES, __use proper data aggregation techniques__ or faceting in [ggplot2] -- __don’t subset the data__. Or, more realistic, only subset the data as a temporary measure while you develop your elegant code for computing on or visualizing these data subsets.

If NO, then maybe you really do need to store a copy of a subset of the data. But seriously consider whether you can achieve your goals by simply using the `subset =` argument of, e.g., the `lm()` function, to limit computation to your excerpt of choice. Lots of functions offer a `subset =` argument!

Copies and excerpts of your data clutter your workspace, invite mistakes, and sow general confusion. Avoid whenever possible.

Reality can also lie somewhere in between. You will find the workflows presented below can help you accomplish your goals with minimal creation of temporary, intermediate objects.

## Use `filter()` to subset data row-wise

`filter()` takes logical expressions and returns the rows for which all are `TRUE`.


```r
filter(gapminder, lifeExp < 29)
#> # A tibble: 2 x 6
#>   country     continent  year lifeExp     pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>   <int>     <dbl>
#> 1 Afghanistan Asia       1952    28.8 8425333      779.
#> 2 Rwanda      Africa     1992    23.6 7290203      737.
filter(gapminder, country == "Rwanda", year > 1979)
#> # A tibble: 6 x 6
#>   country continent  year lifeExp     pop gdpPercap
#>   <fct>   <fct>     <int>   <dbl>   <int>     <dbl>
#> 1 Rwanda  Africa     1982    46.2 5507565      882.
#> 2 Rwanda  Africa     1987    44.0 6349365      848.
#> 3 Rwanda  Africa     1992    23.6 7290203      737.
#> 4 Rwanda  Africa     1997    36.1 7212583      590.
#> 5 Rwanda  Africa     2002    43.4 7852401      786.
#> 6 Rwanda  Africa     2007    46.2 8860588      863.
filter(gapminder, country %in% c("Rwanda", "Afghanistan"))
#> # A tibble: 24 x 6
#>    country     continent  year lifeExp      pop gdpPercap
#>    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#>  1 Afghanistan Asia       1952    28.8  8425333      779.
#>  2 Afghanistan Asia       1957    30.3  9240934      821.
#>  3 Afghanistan Asia       1962    32.0 10267083      853.
#>  4 Afghanistan Asia       1967    34.0 11537966      836.
#>  5 Afghanistan Asia       1972    36.1 13079460      740.
#>  6 Afghanistan Asia       1977    38.4 14880372      786.
#>  7 Afghanistan Asia       1982    39.9 12881816      978.
#>  8 Afghanistan Asia       1987    40.8 13867957      852.
#>  9 Afghanistan Asia       1992    41.7 16317921      649.
#> 10 Afghanistan Asia       1997    41.8 22227415      635.
#> # … with 14 more rows
```

Compare with some base R code to accomplish the same things:

```r
gapminder[gapminder$lifeExp < 29, ] ## repeat `gapminder`, [i, j] indexing is distracting
subset(gapminder, country == "Rwanda") ## almost same as filter; quite nice actually
```

Under no circumstances should you subset your data the way I did at first:


```r
excerpt <- gapminder[241:252, ]
```

Why is this a terrible idea?

* It is not self-documenting. What is so special about rows 241 through 252?
* It is fragile. This line of code will produce different results if someone changes the row order of `gapminder`, e.g. sorts the data earlier in the script.
  

```r
filter(gapminder, country == "Canada")
```

This call explains itself and is fairly robust.

## Meet the new pipe operator

Before we go any further, we should exploit the new pipe operator that the tidyverse imports from the [magrittr] package by Stefan Bache. This is going to change your data analytical life. You no longer need to enact multi-operation commands by nesting them inside each other, like so many [Russian nesting dolls](https://en.wikipedia.org/wiki/Matryoshka_doll). This new syntax leads to code that is much easier to write and to read.

Here's what it looks like: `%>%`. The RStudio keyboard shortcut: Ctrl+Shift+M (Windows), Cmd+Shift+M (Mac).

Let's demo then I'll explain.


```r
gapminder %>% head()
#> # A tibble: 6 x 6
#>   country     continent  year lifeExp      pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Afghanistan Asia       1952    28.8  8425333      779.
#> 2 Afghanistan Asia       1957    30.3  9240934      821.
#> 3 Afghanistan Asia       1962    32.0 10267083      853.
#> 4 Afghanistan Asia       1967    34.0 11537966      836.
#> 5 Afghanistan Asia       1972    36.1 13079460      740.
#> 6 Afghanistan Asia       1977    38.4 14880372      786.
```

This is equivalent to `head(gapminder)`. The pipe operator takes the thing on the left-hand-side and __pipes__ it into the function call on the right-hand-side -- literally, drops it in as the first argument.

Never fear, you can still specify other arguments to this function! To see the first 3 rows of `gapminder`, we could say `head(gapminder, 3)` or this:


```r
gapminder %>% head(3)
#> # A tibble: 3 x 6
#>   country     continent  year lifeExp      pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Afghanistan Asia       1952    28.8  8425333      779.
#> 2 Afghanistan Asia       1957    30.3  9240934      821.
#> 3 Afghanistan Asia       1962    32.0 10267083      853.
```

I've advised you to think "gets" whenever you see the assignment operator, `<-`. Similarly, you should think "then" whenever you see the pipe operator, `%>%`.

You are probably not impressed yet, but the magic will soon happen.

## Use `select()` to subset the data on variables or columns.

Back to dplyr....

Use `select()` to subset the data on variables or columns. Here's a conventional call:


```r
select(gapminder, year, lifeExp)
#> # A tibble: 1,704 x 2
#>     year lifeExp
#>    <int>   <dbl>
#>  1  1952    28.8
#>  2  1957    30.3
#>  3  1962    32.0
#>  4  1967    34.0
#>  5  1972    36.1
#>  6  1977    38.4
#>  7  1982    39.9
#>  8  1987    40.8
#>  9  1992    41.7
#> 10  1997    41.8
#> # … with 1,694 more rows
```

And here's the same operation, but written with the pipe operator and piped through `head()`:

```r
gapminder %>%
  select(year, lifeExp) %>%
  head(4)
#> # A tibble: 4 x 2
#>    year lifeExp
#>   <int>   <dbl>
#> 1  1952    28.8
#> 2  1957    30.3
#> 3  1962    32.0
#> 4  1967    34.0
```

Think: "Take `gapminder`, then select the variables `year` and `lifeExp`, then show the first 4 rows."

## Revel in the convenience

Here's the data for Cambodia, but only certain variables:


```r
gapminder %>%
  filter(country == "Cambodia") %>%
  select(year, lifeExp)
#> # A tibble: 12 x 2
#>     year lifeExp
#>    <int>   <dbl>
#>  1  1952    39.4
#>  2  1957    41.4
#>  3  1962    43.4
#>  4  1967    45.4
#>  5  1972    40.3
#>  6  1977    31.2
#>  7  1982    51.0
#>  8  1987    53.9
#>  9  1992    55.8
#> 10  1997    56.5
#> 11  2002    56.8
#> 12  2007    59.7
```

and what a typical base R call would look like:


```r
gapminder[gapminder$country == "Cambodia", c("year", "lifeExp")]
#> # A tibble: 12 x 2
#>     year lifeExp
#>    <int>   <dbl>
#>  1  1952    39.4
#>  2  1957    41.4
#>  3  1962    43.4
#>  4  1967    45.4
#>  5  1972    40.3
#>  6  1977    31.2
#>  7  1982    51.0
#>  8  1987    53.9
#>  9  1992    55.8
#> 10  1997    56.5
#> 11  2002    56.8
#> 12  2007    59.7
```

## Pure, predictable, pipeable

We've barely scratched the surface of dplyr but I want to point out key principles you may start to appreciate. If you're new to R or "programming with data", feel free skip this section and [move on](#dplyr-single).

dplyr's verbs, such as `filter()` and `select()`, are what's called [pure functions](https://en.wikipedia.org/wiki/Pure_function). To quote from the [Functions chapter](http://adv-r.had.co.nz/Functions.html) of Wickham's [Advanced R] book [-@wickham2015a]:

> The functions that are the easiest to understand and reason about are pure functions: functions that always map the same input to the same output and have no other impact on the workspace. In other words, pure functions have no side effects: they don’t affect the state of the world in any way apart from the value they return.

In fact, these verbs are a special case of pure functions: they take the same flavor of object as input and output. Namely, a data frame or one of the other data receptacles dplyr supports.

And finally, the data is __always__ the very first argument of the verb functions.

This set of deliberate design choices, together with the new pipe operator, produces a highly effective, low friction [domain-specific language](http://adv-r.had.co.nz/dsl.html) for data analysis.

Go to the next Chapter, [dplyr functions for a single dataset](#dplyr-single), for more dplyr!

## Resources

[dplyr] official stuff:

* Package home [on CRAN][dplyr-cran].
  - Note there are several vignettes, with the [Introduction to dplyr] being the most relevant right now.
  - The [Window functions] one will also be interesting to you now.
* Development home [on GitHub][dplyr-github].
* [Tutorial HW delivered][useR-2014-dropbox] (note this links to a DropBox folder) at useR! 2014 conference.     
    
[RStudio Data Transformation Cheat Sheet], covering dplyr. Remember you can get to these via *Help > Cheatsheets.* 

[Data transformation][r4ds-transform] chapter of [R for Data Science] [@wickham2016].

<!--TODO: This should probably be updated with something more recent-->
["Let the Data Flow: Pipelines in R with dplyr and magrittr"] - Excellent slides on pipelines and dplyr by TJ Mahr, talk given to the Madison R Users Group.

<!--TODO: This should probably be updated with something more recent-->
Blog post ["Hands-on dplyr tutorial for faster data manipulation in R"] by Data School, that includes a link to an R Markdown document and links to videos.

Chapter \@ref(join-cheatsheet) - cheatsheet I made for dplyr join functions (not relevant yet but soon).



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
