# Taking control of qualitative colors in ggplot2 {#qualitative-colors}



<!--Original content: https://stat545.com/block019_enforce-color-scheme.html-->

## Load packages and prepare the Gapminder data

Load the [ggplot2] and [dplyr] packages and bring in the usual Gapminder data but drop Oceania, which only has two countries. 

We also sort the country factor based on population and then sort the data as well. Why? In the bubble plots below, we don't want large countries to hide small countries. This is a case where, sadly, the row order of the data truly affects the visual output.


```r
library(ggplot2)
library(dplyr)
library(gapminder)

jdat <- gapminder %>% 
  filter(continent != "Oceania") %>% 
  droplevels() %>% 
  mutate(country = reorder(country, -1 * pop)) %>% 
  arrange(year, country)  
```

## Take control of the size and color of points

Let's use ggplot2 to move towards the classic Gapminder bubble chart. Crawl then walk then run.

First, make a simple scatterplot for a single year.


```r
j_year <- 2007

q <- jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  scale_x_log10(limits = c(230, 63000))

q + geom_point()
```

![](26_qualitative-colors_files/figure-latex/scatterplot-1.pdf)<!-- --> 

Take control of the plotting symbol, its size, and its color. Use obnoxious settings so that success versus failure is completely obvious. Now is not the time for the delicate operation of inserting your fancy color scheme. Be bold!


```r
## do I have control of size and fill color? YES!
q + geom_point(pch = 21, size = 8, fill = I("darkorchid1"))
```

![](26_qualitative-colors_files/figure-latex/scatterplot-obnoxious-points-1.pdf)<!-- --> 

## Circle area = population

We want the size of the circle to reflect population. I have two complaints with my first attempt: the circles are still too small for my taste and I don't want the size legend. So in my second attempt, I suppress the legend with `show.legend = FALSE` and I increase the range of sizes by explicitly setting the range for the scale that maps `pop` into circle size.


```r
q + geom_point(aes(size = pop), pch = 21)
(r <- q +
   geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
   scale_size_continuous(range = c(1,40)))
```


\includegraphics[width=0.5\linewidth]{26_qualitative-colors_files/figure-latex/scatterplot-population-area-1} \includegraphics[width=0.5\linewidth]{26_qualitative-colors_files/figure-latex/scatterplot-population-area-2} 

## Circle fill color determined by a factor

Now I use `aes()` to map a factor to color. For the moment, I settle for the `continent` factor and for the automatic color scheme. I also facet by continent. Why? Because it will be helpful below for checking my progress on using my custom color scheme. Since all the countries, say, in Europe, are some shade of green, if the continent facets have circles of many colors, I'll know something's wrong.


```r
(r <- r + facet_wrap(~ continent) + ylim(c(39, 87)))
r + aes(fill = continent)
```


\includegraphics[width=0.5\linewidth]{26_qualitative-colors_files/figure-latex/scatterplot-continent-fill-1} \includegraphics[width=0.5\linewidth]{26_qualitative-colors_files/figure-latex/scatterplot-continent-fill-2} 

## Get the color scheme for the countries

The gapminder package comes with color palettes for the continents and the individual countries. For example, here's the country color scheme:

\begin{figure}
\includegraphics[width=29.17in]{img/gapminder-color-scheme-ggplot2} \caption{From <https://github.com/jennybc/gapminder>}(\#fig:unnamed-chunk-3)
\end{figure}



```r
str(country_colors)
#>  Named chr [1:142] "#7F3B08" "#833D07" "#873F07" "#8B4107" ...
#>  - attr(*, "names")= chr [1:142] "Nigeria" "Egypt" "Ethiopia" "Con"..
head(country_colors)
#>          Nigeria            Egypt         Ethiopia Congo, Dem. Rep. 
#>        "#7F3B08"        "#833D07"        "#873F07"        "#8B4107" 
#>     South Africa            Sudan 
#>        "#8F4407"        "#934607"
```

`country_colors` is a named character vector, with one element per country, holding the RGB hex strings encoding the color scheme.

Note: The order of `country_colors` is not alphabetical. The countries are actually sorted by size (in which particular year, I don't recall) within continent, reflecting the logic by which the scheme was created. No problem. Ideally, nothing in your analysis should depend on row order, although that's not always possible in reality.

## Prepare the color scheme for use with ggplot2

In a [grammar of graphics]["A layered grammar of graphics"], a __scale__ controls the mapping from a variable in the data to an aesthetic [@wickham2010]. So far we've let the coloring / filling scale be determined automatically by ggplot2. But to use our custom color scheme, we need to take control of the mapping of the `country` factor into fill color in `geom_point()`.

We will use `scale_fill_manual()`, a member of a family of functions for customization of the discrete scales. The main argument is `values =`, which is a vector of aesthetic values -- fill colors, in our case. If this vector has names, they will be consulted during the mapping. This is incredibly useful! This is why `country_colors` does **exactly that**. This saves us from any worry about the order of levels of the `country` factor, the row order of the data, or exactly which countries are being plotted.

## Make the ggplot bubble chart

This is deceptively simple at this point. Like many things, it looks really easy, once we figure everything out! The last two bits we add are to use `aes()` to specify that the country should be mapped to color and to use `scale_fill_manual()` to specify our custom color scheme.


```r
r + aes(fill = country) + scale_fill_manual(values = country_colors)
```

![](26_qualitative-colors_files/figure-latex/scatterplot-country-fill-1.pdf)<!-- --> 

## All together now

The complete code to make the plot.


```r
j_year <- 2007
jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp, fill = country)) +
  scale_fill_manual(values = country_colors) +
  facet_wrap(~ continent) +
  geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
  scale_x_log10(limits = c(230, 63000)) +
  scale_size_continuous(range = c(1,40)) + ylim(c(39, 87))
```

![](26_qualitative-colors_files/figure-latex/scatterplot-country-fill-final-1.pdf)<!-- --> 



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
