# Einführung in dplyr  {#dplyr-intro}




## Einstieg

[dplyr] ist ein Paket zur Datenmanipulation, entwickelt von Hadley Wickham und Romain Francois. Das Paket ist Teil des  [tidyverse] und gehört als Kernpaket zu den Paketen, die über `library(tidyverse)` geladen werden.


Die Autoren des Pakets verstehen `dplyr`  als eine _Grammatik_ der Datenmanipulation. Daher werden die wichtigsten `dplyr` Funktionen auch oft als Verben bezeichnet. Diese Verben sollen euch helfen, die häufigsten Herausforderungen bei der Datenmanipulation zu lösen:

+ `mutate()`: fügt neue Variablen zum Datensatz hinzu, die Funktionen von bestehenden Variablen sind
    
+ `select()`: wählt Variablen (Spalten) basierend auf ihren Namen aus
    
+ `filter()`: wählt Zeilen basierend auf anzugebenden Bedingungen aus
    
+ `summarise()`: reduziert mehrere Werte auf eine einzige Zusammenfassung
    
+ `arrange()`: ändert die Reihenfolge der Zeilen




Der Ursprung von `dplyr` liegt in einem früheren Paket mit dem Namen [plyr], das zum Ziel hat die ["split-apply-combine"-Strategie der Datenanalyse](https://www.jstatsoft.org/article/view/v040i01) [@wickham2011a] umzusetzen. Wo `plyr` noch einen vielfältigen Satz von Ein- und Ausgabetypen abdeckt (z.B. Arrays, data frames, Listen), hat `dplyr` einen klaren Fokus auf data frames oder __tibbles__ (wenn man sich im tidyverse befindet). 

`dplyr` bietet schnelle Alternativen zu den R Standardfunktionen:

+ `subset()`

+ `apply()`, `sapply()`, `lapply()`, `tapply()`

+ `aggregate()` 
+ `split()`

+ `do.call()`

+ `with()`, `within()`

und mehr. Ferner bietet `dplyr` die Möglichkeit schnell über Zeilen oder Gruppen von Zeilen zu iterieren, was eine schnelle Alternative zur Nutzung von `for` Schleifen darstellt.



:::: {.content-box-grey}
__Wie immer, laden wir zu Beginn__ 
<img src="img/tidyverse.png" width="30%" style="display: block; margin: auto 0 auto auto;" />
::::

Der Fokus liegt in diesem Abschnitt auf `dplyr`. Aber da wir immer wieder auch Funktionen aus anderen "tidyverse-Paketen" nutzen, laden wir stets `tidyverse`.


``` r
library(tidyverse)
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

Zusätzlich laden wir auch noch wieder das [gapminder] Paket, da wir erneut mit dem `gapminder` Datensatz arbeiten wollen.


``` r
library(gapminder)
```



## `filter()`: Indizieren von Zeilen

Die Funktion `filter()` erwartet neben dem Datensatz logische Ausdrücke als Input und gibt die Zeilen des Datensatzes zurück, für die die Kombination der verwendeten logischen Ausdrücke ein `TRUE` ergibt.


``` r
# beobachtungen mit einer lebenserwartung unter 29 jahren
filter(gapminder, lifeExp < 29)
## # A tibble: 2 × 6
##   country     continent  year lifeExp     pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>   <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8 8425333      779.
## 2 Rwanda      Africa     1992    23.6 7290203      737.
```


``` r
# beobachtungen aus ruanda nach dem jahr 1979
filter(gapminder, country == "Rwanda", year > 1979)
## # A tibble: 6 × 6
##   country continent  year lifeExp     pop gdpPercap
##   <fct>   <fct>     <int>   <dbl>   <int>     <dbl>
## 1 Rwanda  Africa     1982    46.2 5507565      882.
## 2 Rwanda  Africa     1987    44.0 6349365      848.
## 3 Rwanda  Africa     1992    23.6 7290203      737.
## 4 Rwanda  Africa     1997    36.1 7212583      590.
## 5 Rwanda  Africa     2002    43.4 7852401      786.
## 6 Rwanda  Africa     2007    46.2 8860588      863.
```


Am letzten Befehl erkennt man, dass die verschiedenen logischen Ausdrücke mit einem `& ` verknüpft werden. Will man eine "oder Abfrage" gestalten, so muss diese in einem logischen Ausdruck enthalten sein. So kann man mit nachfolgendem Befehl beispielsweise nach allen Beobachtungen aus Ruanda oder Beobachachtungen nach 1979 fragen:


``` r
filter(gapminder, country == "Rwanda" | year > 1979)
## # A tibble: 858 × 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1982    39.9 12881816      978.
##  2 Afghanistan Asia       1987    40.8 13867957      852.
##  3 Afghanistan Asia       1992    41.7 16317921      649.
##  4 Afghanistan Asia       1997    41.8 22227415      635.
##  5 Afghanistan Asia       2002    42.1 25268405      727.
##  6 Afghanistan Asia       2007    43.8 31889923      975.
##  7 Albania     Europe     1982    70.4  2780097     3631.
##  8 Albania     Europe     1987    72    3075321     3739.
##  9 Albania     Europe     1992    71.6  3326498     2497.
## 10 Albania     Europe     1997    73.0  3428038     3193.
## # ℹ 848 more rows
```


Will man einen Vergleich mit mehr als einem Wert durchführen, so kann man natürlich alle Abfragen mit einem `|` verknüpfen, oder gleich den `%in%` Operator verwenden.


``` r
# beobachtungen aus ruanda und afghanistan
filter(gapminder, country %in% c("Rwanda", "Afghanistan"))
## # A tibble: 24 × 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.
##  2 Afghanistan Asia       1957    30.3  9240934      821.
##  3 Afghanistan Asia       1962    32.0 10267083      853.
##  4 Afghanistan Asia       1967    34.0 11537966      836.
##  5 Afghanistan Asia       1972    36.1 13079460      740.
##  6 Afghanistan Asia       1977    38.4 14880372      786.
##  7 Afghanistan Asia       1982    39.9 12881816      978.
##  8 Afghanistan Asia       1987    40.8 13867957      852.
##  9 Afghanistan Asia       1992    41.7 16317921      649.
## 10 Afghanistan Asia       1997    41.8 22227415      635.
## # ℹ 14 more rows
```


Wir erkennen sofort, dass wir mithilfe von `dplyr` sehr leicht den Datensatz aufteilen können, basierend auf der Tatsache ob Bedingungen erfüllt werden oder eben nicht.    

Daher solltet ihr unter keinen Umständen mit Befehlen wie diesem


``` r
auswahl <- gapminder[241:252, ]
```

arbeiten.


Warum ist das eine __blöde Idee__?

* Der Befehl dokumentiert sich nicht selbst. Was ist das Besondere an den Zeilen 241 bis 252?

* Der Befehl ist fehleranfällig. Diese Codezeile wird zu anderen Ergebnissen führen, wenn jemand die Zeilenreihenfolge von `gapminder` ändert, z.B. die Daten vor diesem Befehl erst sortiert.

Ganz anders verhält es sich mit diesem Befehl


``` r
filter(gapminder, country == "Canada")
```

Er erklärt sich von selbst und ist ziemlich robust.



## Der Pipe-Operator

Bevor es weitergeht, wollen wir aber den Pipe-Operator vorstellen. Dafür gibt es zwei Optionen. Zuerst wurde der Pipe-Operator `%>%` eingeführt, den das Tidyverse aus dem [magrittr]-Paket von Stefan Bache importiert. In Version 4.1 von R wurde auch der native Pipe-Operator `|>` eingeführt. Zwischen den beiden Operatoren gibt es einige Unterschiede. Da der neue Pipe-Operator `|>` schneller und nicht von einem Pakett abhängig ist, werden wir ihn bevorzugen.


<div class="figure" style="text-align: center">
<img src="https://upload.wikimedia.org/wikipedia/en/b/b9/MagrittePipe.jpg" alt="Quelle https://en.wikipedia.org/wiki/The_Treachery_of_Images" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-10)Quelle https://en.wikipedia.org/wiki/The_Treachery_of_Images</p>
</div>


Mithilfe des __Pipe-Operators__ ist man in der Lage aufeinanderfolgende Befehle von Daten-Operationen strukturiert anzugeben, ohne sie ineinander zu verschachteln. Diese neue Syntax führt zu Code, der viel einfacher zu schreiben und zu lesen ist.


:::: {.content-box-blue}

Das entsprechende RStudio Tastenkürzel lautet:     
Ctrl+Shift+M (Windows), Cmd+Shift+M (Mac).

::::

Die Standardeinstellung in RStudio ist, dass man mit der obigen Tastenkürzel den Operator `%>%` bekommt. Um den neuen Operator `|>` zu bekommen, kann man die Tastenkürzel unter `Global Options -> Code` umstellen.

Erstmal ein Beispiel


``` r
gapminder |>  head()
## # A tibble: 6 × 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.
## 2 Afghanistan Asia       1957    30.3  9240934      821.
## 3 Afghanistan Asia       1962    32.0 10267083      853.
## 4 Afghanistan Asia       1967    34.0 11537966      836.
## 5 Afghanistan Asia       1972    36.1 13079460      740.
## 6 Afghanistan Asia       1977    38.4 14880372      786.
```

Man erkennt sofort, der Befehl ist äquivalent zu `head(gapminder)`. Der Pipe-Operator nimmt das Objekt auf der linken Seite und leitet es in den Funktionsaufruf auf der rechten Seite weiter - er gibt es buchstäblich als erstes Argument ein.

Und natürlich kann man der Funktion auf der rechten Seite auch noch weitere Argumente übergeben. Um die ersten 3 Zeilen von `gapminder` auszugeben, könnte man  `head(gapminder, 3)` nutzen oder:


``` r
gapminder |>  head(3)
## # A tibble: 3 × 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.
## 2 Afghanistan Asia       1957    30.3  9240934      821.
## 3 Afghanistan Asia       1962    32.0 10267083      853.
```


Der bisherige Einsatz des Pipe-Operators `|>` war sicherlich noch nicht sehr beeindruckend, aber das sollte sich noch ändern.


## Mit `select()` Variablen auswählen


Verwendet  `select()`, um aus den Daten verschiedene Variablen (Spalten) auszuwählen. Hier kommt eine typische Verwendung von `select()`:


``` r
select(gapminder, year, lifeExp)
## # A tibble: 1,704 × 2
##     year lifeExp
##    <int>   <dbl>
##  1  1952    28.8
##  2  1957    30.3
##  3  1962    32.0
##  4  1967    34.0
##  5  1972    36.1
##  6  1977    38.4
##  7  1982    39.9
##  8  1987    40.8
##  9  1992    41.7
## 10  1997    41.8
## # ℹ 1,694 more rows
```

und nun noch kombiniert mit `head()` über den Pipe-Operator:



``` r
gapminder |> 
  select(year, lifeExp) |> 
  head(4)
## # A tibble: 4 × 2
##    year lifeExp
##   <int>   <dbl>
## 1  1952    28.8
## 2  1957    30.3
## 3  1962    32.0
## 4  1967    34.0
```

Der letzte Befehl nochmal in Worten: 

_"Nimm `gapminder`, wähle die Variablen `year` und `lifeExp` und zeige dann die ersten 4 Zeilen an."_



Natürlich kann man all diese Operationen auch mit R Standardbefehlen ausführen. Die `dplyr` Befehle haben aber klare Vorteile bei der Lesbarkeit des Codes, wie man im nächsten Beispiel sieht.

Wir wählen aus dem `gapminder` Datensatz die Variablen  `year` und `lifeExp` der Kambodscha Beobachtungen


``` r
gapminder |> 
  filter(country == "Cambodia") |> 
  select(year, lifeExp)
## # A tibble: 12 × 2
##     year lifeExp
##    <int>   <dbl>
##  1  1952    39.4
##  2  1957    41.4
##  3  1962    43.4
##  4  1967    45.4
##  5  1972    40.3
##  6  1977    31.2
##  7  1982    51.0
##  8  1987    53.9
##  9  1992    55.8
## 10  1997    56.5
## 11  2002    56.8
## 12  2007    59.7
```

Das gleiche Ergebnis würde man mit diesem R Standardbefehl erhalten:


``` r
gapminder[gapminder$country == "Cambodia", c("year", "lifeExp")]
## # A tibble: 12 × 2
##     year lifeExp
##    <int>   <dbl>
##  1  1952    39.4
##  2  1957    41.4
##  3  1962    43.4
##  4  1967    45.4
##  5  1972    40.3
##  6  1977    31.2
##  7  1982    51.0
##  8  1987    53.9
##  9  1992    55.8
## 10  1997    56.5
## 11  2002    56.8
## 12  2007    59.7
```

Ich hoffe, ihr stimmt mir zu,  dass der `dplyr` Befehl deutlich leichter zu lesen ist.

## select() Hilfsfunktionen

Der `gapminder` Datensatz ist klein und damit leicht überschaubar. Daher ist eine strukturierte Auswahl von Variablen hier nicht notwendig. In größeren Datensätzen kann dies aber ganz anders sein. Dort bietet es sich an mit __Hilfsfunktionen__ wie

- `:` wählt einen Bereich von Spalten aus

- `-` wählt alle Spalten außer  ...

- `starts_with()` wählt alle Spalten, die mit ... starten

- `ends_with()` wählt alle Spalten, die mit ... enden


- `contains()` wählt alle Spalten, die  ... enthalten


- `matches()` wählte alle Spalten, die den regulären Ausdruck ... enthalten


- ...


zu arbeiten.



``` r
select(gapminder, 
       matches(        # von beginn ^
         "^.{4}$"      # bis ende $
         )             # enthält der namen irgendwelche . character
       )
## # A tibble: 1,704 × 1
##     year
##    <int>
##  1  1952
##  2  1957
##  3  1962
##  4  1967
##  5  1972
##  6  1977
##  7  1982
##  8  1987
##  9  1992
## 10  1997
## # ℹ 1,694 more rows
```






## Pure, predictable, pipeable

Bisher haben wir nur etwas an der Oberfläche von `dplyr` gekratzt, trotzdem möchten wir auf ein Schlüsselprinzip hinweisen, das du mit der Zeit schätzen lernen wirst. 

Die Verben (Hauptfunktionen) von dplyr, wie z.B. `filter()` und `select()`, sind [pure functions](https://en.wikipedia.org/wiki/Pure_function). Dazu schreibt Hadley Wickham im Kapitel [Functions](https://adv-r.hadley.nz/functions.html) in seinem [Advanced R] Buch [-@wickham2019]:

> The functions that are the easiest to understand and reason about are pure functions: functions that always map the same input to the same output and have no other impact on the workspace. In other words, pure functions have no side effects: they don’t affect the state of the world in any way apart from the value they return.

Tatsächlich sind diese Verben ein Spezialfall reiner Funktionen: sie nehmen als Input und Output denselben Objekttyp an, i.d.R. ein data frame.

Die Daten sind für all diese Funktionen auch __stets__ das erste Inputargument.



## Aufgabe

Die `dplyr` Einführung geht weiter im Kapitel [Mehr zu `dplyr`](#dplyr-single). Bearbeitet aber vorher den letzten Abschnitt des _Work with Data_ Primers:


_Deriving Information with dplyr_ zeigt euch wie ihr über bestehenden Variablen neue Variablen definiert und leicht zusammenfassende Statistiken innerhalb vorab definierter Gruppen berechnet.


``` r
learnr::run_tutorial("deriving", package = "idsst.rtutorials")
```




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
[Advanced R]: https://adv-r.hadley.nz/
[Tidyverse design principles]: https://principles.tidyverse.org
[R Packages]: https://r-pkgs.org/index.html
[R Graphics Cookbook]: http://shop.oreilly.com/product/0636920023135.do
[Cookbook for R]: http://www.cookbook-r.com 
[ggplot2: Elegant Graphics for Data Analysis]: https://ggplot2-book.org/index.html
[Statistical Inference via Data Science]: https://moderndive.com/index.html

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
