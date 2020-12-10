# Einführung in dplyr  {#dplyr-intro}




## Einstieg

[dplyr] ist ein Paket zur Datenmanipulation, entwickelt von Hadley Wickham und Romain Francois. In erster Linie will es schnell und  ausdrucksstark sein. Es wird als Teil des "Metapakets" [tidyverse] installiert und gehört als Kernpaket zu den Paketen, die über `library(tidyverse)` geladen werden.

Die Wurzeln von `dplyr` liegen in einem früheren Paket mit dem Namen [plyr], das zum Ziel hat die ["split-apply-combine"-Strategie der Datenanalyse](https://www.jstatsoft.org/article/view/v040i01) [@wickham2011a] umzusetzen. Wo `plyr` noch einen vielfältigen Satz von Ein- und Ausgaben abdeckt (z.B. Arrays, data frames, Listen), hat `dplyr` einen klaren Fokus auf data frames oder, im Tidyverse, __tibbles__. 

`dplyr` bietet schnelle Alternativen zu den R Standardfunktionen: `subset()`, `apply()`, `[sl]apply()`, `tapply()`, `aggregate()`, `split()`, `do.call()`, `with()`, `within()`, und mehr. Ferner kann man `dplyr` nutzen um über Zeilen oder Gruppen von Zeilen zu iterieren, was eine schnelle Alternative zur Nutzung von `for` Schleifen darstellt.

### Wie immer, laden wir zu Beginn `tidyverse`


Der Fokus liegt in diesem Abschnitt auf `dplyr`. Aber da wir immer wieder auch Funktionen aus anderen "tidyverse-Paketen" nutzen, laden wir stets `tidyverse`.


```r
library(tidyverse)
#> ── Attaching packages ──────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.4     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.4.0     ✓ forcats 0.5.0
#> ── Conflicts ─────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

Zusätzlich wollen wir auch noch [gapminder] laden.


```r
library(gapminder)
```



## `filter()`: Indizieren von Zeilen

`filter()` nimmt logische Ausdrücke und gibt die Zeilen zurück, für die der logische Ausdruck ein `TRUE` ergibt.


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

Zum Vergleich kann man sich einen R Standardbefehl anschauen, der zum gleichen Ergebnis führt:


```r
gapminder[gapminder$lifeExp < 29, ] 
subset(gapminder, country == "Rwanda" & year > 1979) ## subset funktioniert ähnlich wir filter
```

Unter keinen Umständen solltest du allerdings deine Daten so unterteilen, wie hier:


```r
auswahl <- gapminder[241:252, ]
```

Warum ist das eine blöde Idee?

* Es ist nicht selbstdokumentierend. Was ist das Besondere an den Zeilen 241 bis 252?
* Es ist fehleranfällig. Diese Codezeile wird zu anderen Ergebnissen führen, wenn jemand die Zeilenreihenfolge von `gapminder` ändert, z.B. die Daten früher im Skript sortiert.
  

```r
filter(gapminder, country == "Canada")
```

Dieser Aufruf erklärt sich von selbst und ist ziemlich robust.

## Der Pipe-Operator

Bevor es weitergeht, wollen wir aber den Pipe-Operator, den das Tidyverse aus dem [magrittr]-Paket von Stefan Bache importiert, vorstellen. Mithilfe des Pipe-Operators ist man in der Lage Befehle für mehrere Operationen auszuführen, ohne sie ineinander zu verschachteln. Diese neue Syntax führt zu Code, der viel einfacher zu schreiben und zu lesen ist.

Und so sieht er aus: `%>%`. Das entsprechende RStudio Tastenkürzel lautet: Ctrl+Shift+M (Windows), Cmd+Shift+M (Mac).

Erstmal ein Beispiel


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

Du siehst, der Befehl ist äquivalent zu `head(gapminder)`. Der Pipe-Operator nimmt das Objekt auf der linken Seite und leitet es in den Funktionsaufruf auf der rechten Seite weiter - er gibt es buchstäblich als erstes Argument ein.

Keine Angst, du kannst immer noch weitere Argumente für die Funktion auf der rechten Seite angeben! Um die ersten 3 Reihen von `gapminder` zu sehen, könnte man sagen: `head(gapminder, 3)` oder:


```r
gapminder %>% head(3)
#> # A tibble: 3 x 6
#>   country     continent  year lifeExp      pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Afghanistan Asia       1952    28.8  8425333      779.
#> 2 Afghanistan Asia       1957    30.3  9240934      821.
#> 3 Afghanistan Asia       1962    32.0 10267083      853.
```


Du bist wahrscheinlich noch nicht sehr beeindruckt, aber das sollte sich noch ändern.

## Mit `select()` Variablen auswählen

Nun zurück zu `dplyr`....

Verwende  `select()`, um aus den Daten verschiedene Variablen (Spalten) auszuwählen. Hier kommt eine typische Verwendung von `select()`:


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

Und nun noch kombiniert mit `head()` über den Pipe-Operator:



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

In Worten: "Nimm `gapminder`, wähle die Variablen `year` und `lifeExp` und zeige dann die ersten 4 Zeilen an."

## Jetzt nochmal ein Vergleich zu R Standardbefehlen

Hier sind die Daten für Kambodscha, aber nur bestimmte Variablen:


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

und so würde ein typischer R Standardbefehl aussehen:


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

der zum gleichen Ergebnis führt. Wir würden sagen, dass der `dplyr` Befehl deutlich leichter zu lesen ist.

## Pure, predictable, pipeable

Bisher haben wir nur etwas an der Oberfläche von `dplyr` gekratzt, trotzdem möchten wir auf ein Schlüsselprinzipien hinweisen, die du vielleicht langsam zu schätzen lernen wirst. 

Die Verben (Hauptfunktionen) von dplyr, wie z.B. `filter()` und `select()`, sind [pure functions](https://en.wikipedia.org/wiki/Pure_function). Dazu schreibt Hadley Wickham [Functions chapter](http://adv-r.had.co.nz/Functions.html) in seinem [Advanced R] Buch [-@wickham2015a]:

> The functions that are the easiest to understand and reason about are pure functions: functions that always map the same input to the same output and have no other impact on the workspace. In other words, pure functions have no side effects: they don’t affect the state of the world in any way apart from the value they return.

Tatsächlich sind diese Verben ein Spezialfall reiner Funktionen: sie nehmen als Input und Output denselben Objekttyp an, i.d.R. ein data frame.

Die Daten sind für all diese Funktionen aus __stets__ das erste Inputargument.


Die `dplyr` Einführung geht weiter im Kapitel [Mehr zu `dplyr`](#dplyr-single).





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
[rmarkdown]: https://rmarkdown.rstudio.com/
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
