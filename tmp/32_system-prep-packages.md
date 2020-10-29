# System preparation for package development {#system-prep}



<!--Original content: https://stat545.com/packages01_system-prep.html-->

Although we'll build a very simple package, we'll use the most modern and powerful tools for R package development. In theory, this could eventually involve compiling C/C++ code, which means you need what's called a *build environment*.

## Update R and RStudio

Embarking on your career as an R package developer is an important milestone. Why not celebrate by updating R and RStudio? This is something we recommended early and we recommend doing it often. Go back to Chapter \@ref(install) for reminders on the process. **DO IT NOW. We are not very interested in solving problems that stem from running outdated versions of R and RStudio.**

*2016-11 FYI: Jenny is running R version 3.3.1 (2016-06-21) Bug in Your Hair and RStudio 1.0.44 at the time of writing.*

## Install devtools from CRAN

We use the [devtools] package to help us develop our R package. Do this:

``` r
install.packages("devtools")
library(devtools)
```

## Windows: system prep

You will probably get an immediate warning from devtools, complaining that you need Rtools in order to build R packages.

You *can ignore* this and successfully develop an R package that consists solely of R code. Such as our toy package.

However, we recommend you install Rtools, so you can take full advantage of devtools. Soon, you will want to use `devtools::install_github()` to install R packages from GitHub, instead of CRAN. You will inevitably need to build a package that includes C/C++ code, which *will require* Rtools.

Rtools is __NOT an R package__ but is rather ["a collection of resources for building packages for R under Microsoft Windows, or for building R itself"](https://cloud.r-project.org/bin/windows/Rtools/).

Go here and do what it says:

<https://cloud.r-project.org/bin/windows/Rtools/>

During the installation of Rtools you will get to a window asking you to "Select Additional Tasks". **It is important that you make sure to select the box for "Edit the system PATH"**.

*Are we going to recommend making sure Git Bash is NOT on `PATH`? See [issue #230](https://github.com/STAT545-UBC/Discussion/issues/230#issuecomment-155236031).*

\begin{figure}
\includegraphics[width=0.65\linewidth]{img/rtools-install} \caption{Rtools installation}(\#fig:unnamed-chunk-2)
\end{figure}

After installing Rtools, restart RStudio, then do:

``` r
library(devtools)
find_rtools()
```

Hopefully you will simply see a message saying `TRUE`, indicating that Rtools is properly installed. But if there was a problem, you will see a longer message with next steps.

## macOS: system prep

You will not get an *immediate* warning from devtools that you need to install anything. But before you can build R package with compiled code, you will also need to install more software. Pick one of the following:

* Minimalist approach (what I do): Install Xcode Command Line Tools.
  - In the shell: `xcode-select --install`
* Install the current release of full Xcode from the Mac App Store. WAY more stuff than you need but advantage is App Store convenience.
* Get older or beta releases of Xcode from <https://developer.apple.com/support/xcode/>.
  
## Linux: system prep

*We've never had this section but [RStudio's devtools guide](https://www.rstudio.com/products/rpackages/devtools/) and [R Packages](https://r-pkgs.org/intro.html#linux) [@wickham-unpub] both say the r-devel or r-base-dev package is required. What gives?*

## Check system prep

devtools offers a diagnostic function to check if your system is ready.

``` r
library(devtools)
has_devel()
```

Hopefully you see `TRUE`!

## R packages to help you build yet more R packages

Install more packages. If you already have them, update them.

* [knitr]
* [roxygen2]
* [testthat]

*2016-11 FYI: Jenny is running these versions of these packages at the time of writing.*

```
#>    package *     version       date                              source
#> 1 devtools * 1.12.0.9000 2016-11-23                               local
#> 2    knitr *      1.14.2 2016-09-07        Github (yihui/knitr@f02600d)
#> 3 roxygen2 *  5.0.1.9000 2016-10-23 Github (klutometis/roxygen@9ffbad0)
#> 4 testthat *  1.0.2.9000 2016-09-09    Github (hadley/testthat@46d15da)
```

How to check which version of a specific package you've got installed:

``` r
packageVersion("devtools")
```

How to install a package and all it's dependencies:

``` r
install.packages("devtools", dependencies = TRUE)
```

See how profound your problem with out-of-date packages is:

``` r
old.packages()
```

Update one package:

``` r
update.packages("knitr")
```

Just update everything:

``` r
update.packages(ask = FALSE)
```
        
__CAVEAT:__ The above examples will only consult your default library and default CRAN mirror. If you want to target a non-default library, use function arguments to say so. Packages that you have installed from GitHub? You'll need to check the current-ness of your version and perform upgrades yourself.

## Optional: install devtools from GitHub

We aren't using bleeding edge features of devtools, but you could upgrade to the development version of devtools at this point.

macOS and Linux users have it easy. Do this:

``` r
devtools::install_github("r-lib/devtools")
```

For Windows instructions, see the [devtools README](https://github.com/r-lib/devtools).



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
