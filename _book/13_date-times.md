# Dates and times {#date-time}



<!--JB: *Under development ... really just a placeholder / collection of links*-->

<!--Original content: https://stat545.com/block030_date-times.html--> 

## Date-time vectors: where they fit in

We've spent a lot of time working with big, beautiful data frames. That are clean and wholesome, like the Gapminder data. With crude temporal information like, "THE YEAR IS 1952".

But real life will be much nastier. This information will come to you with much greater precision, reported to the last second or worse, complicated by time zones and daylight savings time idiosyncrasies. Or in some weird format.

Here we discuss common remedial tasks for dealing with date-times.

## Resources

I start with this because we cannot possibly do this topic justice in a short amount of time. Our goal is to make you aware of specific problems and solutions. Once you have a character problem in real life, these resources will be extremely helpful as you delve deeper.

* [Dates and times](https://r4ds.had.co.nz/dates-and-times.html) chapter from [R for Data Science] by Hadley Wickham and Garrett Grolemund [-@wickham2016]. 
  + See also the subsection on dates and times in the [Data import chapter](http://r4ds.had.co.nz/data-import.html).
* The [lubridate] package.
  + On [CRAN](https://cloud.R-project.org/package=lubridate).
  + On [GitHub](https://github.com/tidyverse/lubridate).
  + Main vignette: [Do more with dates and times in R].
* Grolemund and Wickham's paper on lubridate in the Journal of Statistical Software: ["Dates and Times Made Easy with lubridate"] [-@grolemund2011].
* Exercises to push you to learn lubridate (*posts include links to answers!*)
  + [Part 1](https://www.r-exercises.com/2016/08/15/dates-and-times-simple-and-easy-with-lubridate-part-1/)
  + [Part 2](https://www.r-exercises.com/2016/08/29/dates-and-times-simple-and-easy-with-lubridate-exercises-part-2/)
  + [Part 3](https://www.r-exercises.com/2016/10/04/dates-and-times-simple-and-easy-with-lubridate-exercises-part-3/) 


## Load the tidyverse and lubridate


```r
library(tidyverse)
library(lubridate)
```


## Get your hands on some dates or date-times

Use base `Sys.Date()` or lubridate's `today()` to get today's date, without any time.


```r
Sys.Date()
#> [1] "2020-10-27"
today()
#> [1] "2020-10-27"
```

They both give you something of class `Date`.


```r
str(Sys.Date())
#>  Date[1:1], format: "2020-10-27"
class(Sys.Date())
#> [1] "Date"
str(today())
#>  Date[1:1], format: "2020-10-27"
class(today())
#> [1] "Date"
```

Use base `Sys.time()` or lubridate's `now()` to get RIGHT NOW, meaning the date and the time.


```r
Sys.time()
#> [1] "2020-10-27 17:42:38 CET"
now()
#> [1] "2020-10-27 17:42:38 CET"
```

They both give you something of class `POSIXct` in R jargon.


```r
str(Sys.time())
#>  POSIXct[1:1], format: "2020-10-27 17:42:38"
class(Sys.time())
#> [1] "POSIXct" "POSIXt"
str(now())
#>  POSIXct[1:1], format: "2020-10-27 17:42:38"
class(now())
#> [1] "POSIXct" "POSIXt"
```

## Get date or date-time from character

One of the main ways dates and date-times come into your life:

<http://r4ds.had.co.nz/dates-and-times.html#creating-datetimes#from-strings>

## Build date or date-time from parts

Second most common way dates and date-times come into your life:

<http://r4ds.had.co.nz/dates-and-times.html#creating-datetimes#from-individual-components>

Once you have dates, you might want to edit them in a non-annoying way:

<http://r4ds.had.co.nz/dates-and-times.html#setting-components>

## Get parts from date or date-time

<http://r4ds.had.co.nz/dates-and-times.html#date-time-components#getting-components>

## Arithmetic with date or date-time

<http://r4ds.had.co.nz/dates-and-times.html#time-spans>

## Get character from date or date-time

Eventually you will need to print this stuff in, say, a report.

*I always use `format()` but assumed lubridate had something else/better. Am I missing something here? Probably. For now, read the help: `?format.POSIXct`.*



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
