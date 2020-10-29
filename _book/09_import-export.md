# Writing and reading files {#import-export}



<!--Original content: https://stat545.com/block026_file-out-in.html-->

## File I/O overview

We've been loading the Gapminder data as a data frame from the [gapminder] data package. We haven't been explicitly writing any data or derived results to file. In real life, you'll bring rectangular data into and out of R all the time. Sometimes you'll need to do same for non-rectangular objects.

How do you do this? What issues should you think about?

### Data import mindset

Data import generally feels one of two ways:

* *"Surprise me!"* This is the attitude you must adopt when you first get a dataset. You are just happy to import without an error. You start to explore. You discover flaws in the data and/or the import. You address them. Lather, rinse, repeat.
* *"Another day in paradise."* This is the attitude when you bring in a tidy dataset you have maniacally cleaned in one or more cleaning scripts. There should be no surprises. You should express your expectations about the data in formal assertions at the very start of these downstream scripts.
  
In the second case, and as the first cases progresses, you actually know a lot about how the data is/should be. My main import advice: **use the arguments of your import function to get as far as you can, as fast as possible**. Novice code often has a great deal of unnecessary post import fussing around. Read the docs for the import functions and take maximum advantage of the arguments to control the import.

### Data export mindset

There will be many occasions when you need to write data from R. Two main examples:

* a tidy ready-to-analyze dataset that you heroically created from messy data
* a numerical result from data aggregation or modelling or statistical inference 

First tip: __today's outputs are tomorrow's inputs__. Think back on all the pain you have suffered importing data and don't inflict such pain on yourself!

Second tip: don't be too cute or clever. A plain text file that is readable by a human being in a text editor should be your default until you have __actual proof__ that this will not work. Reading and writing to exotic or proprietary formats will be the first thing to break in the future or on a different computer. It also creates barriers for anyone who has a different toolkit than you do. Be software-agnostic. Aim for future-proof and moron-proof.

How does this fit with our emphasis on dynamic reporting via R Markdown? There is a time and place for everything. There are projects and documents where the scope and personnel will allow you to geek out with knitr and R Markdown. But there are lots of good reasons why (parts of) an analysis should not (only) be embedded in a dynamic report. Maybe you are just doing data cleaning to produce a valid input dataset. Maybe you are making a small but crucial contribution to a giant multi-author paper. Etc. Also remember there are other tools and workflows for making something reproducible. I'm looking at you, [make]["minimal make: a minimal tutorial on make"].

## Load the tidyverse

The main package we will be using is [readr], which provides drop-in substitute functions for `read.table()` and friends. However, to make some points about data export and import, it is nice to reorder factor levels. For that, we will use the [forcats] package, which is also included in the [tidyverse] meta-package.


```r
library(tidyverse)
#> ── Attaching packages ──────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.3     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ─────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

## Locate the Gapminder data

We could load the data from the package as usual, but instead we will load it from tab delimited file. The gapminder package includes the data normally found in the `gapminder` data frame as a `.tsv`. So let's get the path to that file on *your* system using the [fs] package.


```r
library(fs)
(gap_tsv <- path_package("gapminder", "extdata", "gapminder.tsv"))
#> /Users/hgstp/Library/R/4.0/library/gapminder/extdata/gapminder.tsv
```

## Bring rectangular data in

The workhorse data import function of readr is `read_delim()`. Here we'll use a variant, `read_tsv()`, that anticipates tab-delimited data:


```r
gapminder <- read_tsv(gap_tsv)
#> Parsed with column specification:
#> cols(
#>   country = col_character(),
#>   continent = col_character(),
#>   year = col_double(),
#>   lifeExp = col_double(),
#>   pop = col_double(),
#>   gdpPercap = col_double()
#> )
str(gapminder, give.attr = FALSE)
#> tibble [1,704 × 6] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>  $ country  : chr [1:1704] "Afghanistan" "Afghanistan" "Afghanistan" "Afghani"..
#>  $ continent: chr [1:1704] "Asia" "Asia" "Asia" "Asia" ...
#>  $ year     : num [1:1704] 1952 1957 1962 1967 1972 ...
#>  $ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#>  $ pop      : num [1:1704] 8425333 9240934 10267083 11537966 13079460 ...
#>  $ gdpPercap: num [1:1704] 779 821 853 836 740 ...
```

For full flexibility re: specifying the delimiter, you can always use `readr::read_delim()`.

There's a similar convenience wrapper for comma-separated values: `read_csv()`.

The most noticeable difference between the readr functions and base is that readr does NOT convert strings to factors by default. In the grand scheme of things, this is better default behavior, although we go ahead and convert them to factor here. Do not be deceived -- in general, you will do less post-import fussing if you use readr.


```r
gapminder <- gapminder %>%
  mutate(country = factor(country),
         continent = factor(continent))
str(gapminder)
#> tibble [1,704 × 6] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#>  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
#>  $ year     : num [1:1704] 1952 1957 1962 1967 1972 ...
#>  $ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#>  $ pop      : num [1:1704] 8425333 9240934 10267083 11537966 13079460 ...
#>  $ gdpPercap: num [1:1704] 779 821 853 836 740 ...
#>  - attr(*, "spec")=
#>   .. cols(
#>   ..   country = col_character(),
#>   ..   continent = col_character(),
#>   ..   year = col_double(),
#>   ..   lifeExp = col_double(),
#>   ..   pop = col_double(),
#>   ..   gdpPercap = col_double()
#>   .. )
```

### Bring rectangular data in -- summary

Default to `readr::read_delim()` and friends. Use the arguments!

The Gapminder data is too clean and simple to show off the great features of readr, so I encourage you to check out the part of the introduction vignette on [column types](https://cloud.r-project.org/web/packages/readr/vignettes/readr.html). There are many variable types that you will be able to parse correctly upon import, thereby eliminating a great deal of post-import fussing.

## Compute something worthy of export

We need compute something worth writing to file. Let's create a country-level summary of maximum life expectancy.


```r
gap_life_exp <- gapminder %>%
  group_by(country, continent) %>% 
  summarise(life_exp = max(lifeExp)) %>% 
  ungroup()
#> `summarise()` regrouping output by 'country' (override with `.groups` argument)
gap_life_exp
#> # A tibble: 142 x 3
#>    country     continent life_exp
#>    <fct>       <fct>        <dbl>
#>  1 Afghanistan Asia          43.8
#>  2 Albania     Europe        76.4
#>  3 Algeria     Africa        72.3
#>  4 Angola      Africa        42.7
#>  5 Argentina   Americas      75.3
#>  6 Australia   Oceania       81.2
#>  7 Austria     Europe        79.8
#>  8 Bahrain     Asia          75.6
#>  9 Bangladesh  Asia          64.1
#> 10 Belgium     Europe        79.4
#> # … with 132 more rows
```

The `gap_life_exp` data frame is an example of an intermediate result that we want to store for the future and for downstream analyses or visualizations.

## Write rectangular data out

The workhorse export function for rectangular data in readr is `write_delim()` and friends. Let's use `write_csv()` to get a comma-delimited file.


```r
write_csv(gap_life_exp, "gap_life_exp.csv")
```

Let's look at the first few lines of `gap_life_exp.csv`. If you're following along, you should be able to open this file or, in a shell, use `head()` on it.


```
country,continent,life_exp
Afghanistan,Asia,43.828
Albania,Europe,76.423
Algeria,Africa,72.301
Angola,Africa,42.731
Argentina,Americas,75.32
```

This is pretty decent looking, though there is no visible alignment or separation into columns. Had we used the base function `read.csv()`, we would be seeing rownames and lots of quotes, unless we had explicitly shut that down. Nicer default behavior is the main reason we are using `readr::write_csv()` over `write.csv()`.

* It's not really fair to complain about the lack of visible alignment. Remember we are ["writing data for computers"]. If you really want to browse around the file, use `View()` in RStudio or open it in Microsoft Excel (!) but don't succumb to the temptation to start doing artisanal data manipulations there ... get back to R and construct commands that you can re-run the next 15 times you import/clean/aggregate/export the same dataset. Trust me, it will happen.

## Invertibility

It turns out these self-imposed rules are often in conflict with one another:

* Write to plain text files
* Break analysis into pieces: the output of script `i` is an input for script `i + 1`
* Be the boss of factors: order the levels in a meaningful, usually non-alphabetical way
* Avoid duplication of code and data

Example: after performing the country-level summarization, we reorder the levels of the country factor, based on life expectancy. This reordering operation is conceptually important and must be embodied in R commands stored in a script. However, as soon as we write `gap_life_exp` to a plain text file, that meta-information about the countries is lost. Upon re-import with `read_delim()` and friends, we are back to alphabetically ordered factor levels. Any measure we take to avoid this loss immediately breaks another one of our rules.

So what do I do? I must admit I save (and re-load) R-specific binary files. Right after I save the plain text file. [Belt and suspenders](https://www.wisegeek.com/what-does-it-mean-to-wear-belt-and-suspenders.htm).

I have toyed with the idea of writing import helper functions for a specific project, that would re-order factor levels in principled ways. They could be defined in one file and called from many. This would also have a very natural implementation within [a workflow where each analytical project is an R package](https://www.carlboettiger.info/2012/05/06/research-workflow.html). But so far it has seemed too much like [yak shaving](https://seths.blog/2005/03/dont_shave_that/). I'm intrigued by a recent discussion of putting such information in YAML frontmatter (see Martin Fenner blog post, ["Using YAML frontmatter with CSV"](https://blog.datacite.org/using-yaml-frontmatter-with-csv/)).

## Reordering the levels of the country factor

The topic of factor level reordering is covered in Chapter \@ref(factors-boss), so let's Just. Do. It. I reorder the country factor levels according to the life expectancy summary we've already computed.


```r
head(levels(gap_life_exp$country)) # alphabetical order
#> [1] "Afghanistan" "Albania"     "Algeria"     "Angola"      "Argentina"  
#> [6] "Australia"
gap_life_exp <- gap_life_exp %>% 
  mutate(country = fct_reorder(country, life_exp))
head(levels(gap_life_exp$country)) # in increasing order of maximum life expectancy
#> [1] "Sierra Leone" "Angola"       "Afghanistan"  "Liberia"      "Rwanda"      
#> [6] "Mozambique"
head(gap_life_exp)
#> # A tibble: 6 x 3
#>   country     continent life_exp
#>   <fct>       <fct>        <dbl>
#> 1 Afghanistan Asia          43.8
#> 2 Albania     Europe        76.4
#> 3 Algeria     Africa        72.3
#> 4 Angola      Africa        42.7
#> 5 Argentina   Americas      75.3
#> 6 Australia   Oceania       81.2
```

Note that the __row order of `gap_life_exp` has not changed__. I could choose to reorder the rows of the data frame if, for example, I was about to prepare a table to present to people. But I'm not, so I won't.

## `saveRDS()` and `readRDS()`

If you have a data frame AND you have exerted yourself to rationalize the factor levels, you have my blessing to save it to file in a way that will preserve this hard work upon re-import. Use `saveRDS()`.


```r
saveRDS(gap_life_exp, "gap_life_exp.rds")
```

`saveRDS()` serializes an R object to a binary file. It's not a file you will able to open in an editor, diff nicely with Git(Hub), or share with non-R friends. It's a special purpose, limited use function that I use in specific situations.

The opposite of `saveRDS()` is `readRDS()`. You must assign the return value to an object. I highly recommend you assign back to the same name as before. Why confuse yourself?!?


```r
rm(gap_life_exp)
gap_life_exp
#> Error in eval(expr, envir, enclos): object 'gap_life_exp' not found
gap_life_exp <- readRDS("gap_life_exp.rds")
gap_life_exp
#> # A tibble: 142 x 3
#>    country     continent life_exp
#>    <fct>       <fct>        <dbl>
#>  1 Afghanistan Asia          43.8
#>  2 Albania     Europe        76.4
#>  3 Algeria     Africa        72.3
#>  4 Angola      Africa        42.7
#>  5 Argentina   Americas      75.3
#>  6 Australia   Oceania       81.2
#>  7 Austria     Europe        79.8
#>  8 Bahrain     Asia          75.6
#>  9 Bangladesh  Asia          64.1
#> 10 Belgium     Europe        79.4
#> # … with 132 more rows
```

`saveRDS()` has more arguments, in particular `compress` for controlling compression, so read the help for more advanced usage. It is also very handy for saving non-rectangular objects, like a fitted regression model, that took a nontrivial amount of time to compute.

You will eventually hear about `save()` + `load()` and even `save.image()`. You may even see them in documentation and tutorials, but don't be tempted. Just say no. These functions encourage unsafe practices, like storing multiple objects together and even entire workspaces. There are legitimate uses of these functions, but not in your typical data analysis.

## Retaining factor levels upon re-import

Concrete demonstration of how non-alphabetical factor level order is lost with `write_delim()` / `read_delim()` workflows but maintained with `saveRDS()` / `readRDS()`.


```r
(country_levels <- tibble(original = head(levels(gap_life_exp$country))))
#> # A tibble: 6 x 1
#>   original    
#>   <chr>       
#> 1 Sierra Leone
#> 2 Angola      
#> 3 Afghanistan 
#> 4 Liberia     
#> 5 Rwanda      
#> 6 Mozambique
write_csv(gap_life_exp, "gap_life_exp.csv")
saveRDS(gap_life_exp, "gap_life_exp.rds")
rm(gap_life_exp)
head(gap_life_exp) # will cause error! proving gap_life_exp is really gone 
#> Error in head(gap_life_exp): object 'gap_life_exp' not found
gap_via_csv <- read_csv("gap_life_exp.csv") %>% 
  mutate(country = factor(country))
#> Parsed with column specification:
#> cols(
#>   country = col_character(),
#>   continent = col_character(),
#>   life_exp = col_double()
#> )
gap_via_rds <- readRDS("gap_life_exp.rds")
country_levels <- country_levels %>% 
  mutate(via_csv = head(levels(gap_via_csv$country)),
         via_rds = head(levels(gap_via_rds$country)))
country_levels
#> # A tibble: 6 x 3
#>   original     via_csv     via_rds     
#>   <chr>        <chr>       <chr>       
#> 1 Sierra Leone Afghanistan Sierra Leone
#> 2 Angola       Albania     Angola      
#> 3 Afghanistan  Algeria     Afghanistan 
#> 4 Liberia      Angola      Liberia     
#> 5 Rwanda       Argentina   Rwanda      
#> 6 Mozambique   Australia   Mozambique
```

Note how the original, post-reordering country factor levels are restored using the `saveRDS()` / `readRDS()` strategy but revert to alphabetical ordering using `write_csv()` / `read_csv()`.

## `dput()` and `dget()`

One last method of saving and restoring data deserves a mention: `dput()` and `dget()`. `dput()` offers this odd combination of features: it creates a plain text representation of an R object which still manages to be quite opaque. If you use the `file =` argument, `dput()` can write this representation to file but you won't be tempted to actually read that thing. `dput()` creates an R-specific-but-not-binary representation. Let's try it out.


```r
## first restore gap_life_exp with our desired country factor level order
gap_life_exp <- readRDS("gap_life_exp.rds")
dput(gap_life_exp, "gap_life_exp-dput.txt")
```

Now let's look at the first few lines of the file `gap_life_exp-dput.txt`.


```
structure(list(country = structure(c(3L, 107L, 74L, 2L, 98L, 
138L, 128L, 102L, 49L, 125L, 26L, 56L, 96L, 47L, 75L, 85L, 18L, 
12L, 37L, 24L, 133L, 13L, 16L, 117L, 84L, 82L, 53L, 9L, 28L, 
120L, 22L, 104L, 114L, 109L, 115L, 23L, 73L, 97L, 66L, 71L, 15L, 
29L, 20L, 122L, 134L, 40L, 35L, 123L, 38L, 126L, 60L, 25L, 7L, 
39L, 59L, 141L, 86L, 140L, 51L, 63L, 64L, 52L, 121L, 135L, 132L, 
```

Huh? Don't worry about it. Remember we are ["writing data for computers"]. The partner function `dget()` reads this representation back in.


```r
gap_life_exp_dget <- dget("gap_life_exp-dput.txt")
country_levels <- country_levels %>% 
  mutate(via_dput = head(levels(gap_life_exp_dget$country)))
country_levels
#> # A tibble: 6 x 4
#>   original     via_csv     via_rds      via_dput    
#>   <chr>        <chr>       <chr>        <chr>       
#> 1 Sierra Leone Afghanistan Sierra Leone Sierra Leone
#> 2 Angola       Albania     Angola       Angola      
#> 3 Afghanistan  Algeria     Afghanistan  Afghanistan 
#> 4 Liberia      Angola      Liberia      Liberia     
#> 5 Rwanda       Argentina   Rwanda       Rwanda      
#> 6 Mozambique   Australia   Mozambique   Mozambique
```

Note how the original, post-reordering country factor levels are restored using the `dput()` / `dget()` strategy.

But why on earth would you ever do this?

The main application of this is [the creation of highly portable, self-contained minimal examples](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example). For example, if you want to pose a question on a forum or directly to an expert, it might be required or just plain courteous to NOT attach any data files. You will need a monolithic, plain text blob that defines any necessary objects and has the necessary code. `dput()` can be helpful for producing the piece of code that defines the object. If you `dput()` without specifying a file, you can copy the return value from Console and paste into a script. Or you can write to file and copy from there or add R commands below.

## Other types of objects to use `dput()` or `saveRDS()` on

My special dispensation to abandon human-readable, plain text files is even broader than I've let on. Above, I give my blessing to store data.frames via `dput()` and/or `saveRDS()`, when you've done some rational factor level re-ordering. The same advice and mechanics apply a bit more broadly: you're also allowed to use R-specific file formats to save vital non-rectangular objects, such as a fitted nonlinear mixed effects model or a classification and regression tree.

## Clean up

We've written several files in this tutorial. Some of them are not of lasting value or have confusing filenames. I choose to delete them, while demonstrating some of the many functions R offers for interacting with the filesystem. It's up to you whether you want to submit this command or not.


```r
file.remove(list.files(pattern = "^gap_life_exp"))
#> [1] TRUE TRUE TRUE
```

## Pitfalls of delimited files

If a delimited file contains fields where a human being has typed, be crazy paranoid because people do really nutty things. Especially people who aren't in the business of programming and have never had to compute on text. Claim: a person's regular expression skill is inversely proportional to the skill required to handle the files they create. Implication: if someone has never heard of regular expressions, prepare for lots of pain working with their files.

When the header fields (often, but not always, the variable names) or actual data contain the delimiter, it can lead to parsing and import failures. Two popular delimiters are the comma `,` and the TAB `\t` and humans tend to use these when typing. If you can design this problem away during data capture, such as by using a drop down menu on an input form, by all means do so. Sometimes this is impossible or undesirable and you must deal with fairly free form text. That's a good time to allow/force text to be protected with quotes, because it will make parsing the delimited file go more smoothly.

Sometimes, instead of rigid tab-delimiting, whitespace is used as the delimiter. That is, in fact, the default for both `read.table()` and `write.table()`. Assuming you will write/read variable names from the first line (a.k.a. the `header` in `write.table()` and `read.table()`), they must be valid R variable names ... or they will be coerced into something valid. So, for these two reasons, it is good practice to use "one word" variable names whenever possible. If you need to evoke multiple words, use `snake_case` or `camelCase` to cope. Example: the header entry for the field holding the subject's last name should be `last_name` or `lastName` NOT `last name`. With the readr package, "column names are left as is, not munged into valid R identifiers (i.e. there is no `check.names = TRUE`)". So you can get away with whitespace in variable names and yet I recommend that you do not.

## Resources

[Data import](http://r4ds.had.co.nz/data-import.html) chapter of [R for Data Science] by Hadley Wickham and Garrett Grolemund [-@wickham2016].

White et al.'s "Nine simple ways to make it easier to (re)use your data" [-@white2013]. 

* First appeared [in PeerJ Preprints](https://doi.org/10.7287/peerj.preprints.7v2)
* Published in [Ideas in Ecology and Evolution in 2013](https://ojs.library.queensu.ca/index.php/IEE/article/view/4608)
* Section 4 "Use Standard Data Formats" is especially good reading.
  
Wickham's paper on tidy data in the Journal of Statistical Software [-@wickham2014]. 

* Available as a PDF [here](http://vita.had.co.nz/papers/tidy-data.pdf)

Data Manipulation in R by Phil Spector [-@spector2008].

* Available via [SpringerLink](https://www.springer.com/gp/book/9780387747309)
* [Author's webpage](https://www.stat.berkeley.edu/%7Espector/)
* [GoogleBooks search](https://books.google.com/books?id=grfuq1twFe4C&lpg=PP1&dq=data%2520manipulation%2520spector&pg=PP1#v=onepage&q&f=false)
* See Chapter 2 ("Reading and Writing Data")


<!--Links-->
["writing data for computers"]: https://twitter.com/vsbuffalo/statuses/358699162679787521



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
