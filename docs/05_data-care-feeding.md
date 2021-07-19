# (PART) Datenanalyse Intro {-} 

# Letzte Vorbereitungen ... {#basic-data-care}







Jetzt ist es an der Zeit, sich zu vergewissern in welchem Verzeichnis auf deinem Computer du dich befindest. Falls du ein  [RStudio Projekt](#rprojs) nutzt, sollte diese Frage leicht zu beantworten sein. Falls du trotzdem unsicher bist, gib `getwd()` in der Konsole ein, um das aktuelle Arbeitsverzeichnis zu sehen.

Alle nachfolgenden Code Beispiele wollen wir abspeichern in einer `.R` Datei, die wir im aktuellen Arbeitsverzeichnis abspeichern wollen. Idealerweise geben wir dieser Datei noch einen Namen, wie etwa `datenanalyse_teil_1.R`, der uns schon viel über den möglichen Inhalt erzählt.
Alternativ können wir alle Befehle natürlich auch in eine R Markdown Datei schreiben, siehe [Test drive R Markdown](#r-markdown).


Prinzipiell geht es in den folgenden Abschnitten um Datenmanagement. Es werden aber auch immer wieder ein paar Grafiken zu sehen sein. Dies ist aber kein Problem, da wir ja bereits den [Data Visualization Basics Primer](https://rstudio.cloud/learn/primers/1.1)

<img src="img/data_vis_basics.png" width="100%" />

besucht haben und so den nötigen Background haben.

## Data Frames sind fantastisch

Das Standardformat für Daten ist ein data frame. Die meisten Funktionen zur Inferenz, Modellierung und graphischen Darstellung erwarten, dass ihnen über ein `data =` Argument ein data frame übergeben wird. Dies gilt für die Basis R schon seit langem.

Die als [tidyverse] bekannte Kollektion von Paketen geht noch einen Schritt weiter und priorisiert ausdrücklich die Verarbeitung von data frames. Tatsächlich priorisiert [tidyverse] eine besondere Art von data frames, die als "tibble" bezeichnet wird.

Data frames - im Gegensatz zu allgemeinen Arrays oder speziell Matrizen in R - können Variablen unterschiedlicher Typen enthalten, wie z. B. Textdaten (Subjekt-ID oder Name), quantitative Daten (Anzahl der weißen Blutkörperchen) und kategoriale Informationen (behandelt vs. unbehandelt). Genauer gesagt können in data frames unterschiedliche Spalten aus unterschiedlichen Datentypen bestehen. Innerhalb einer Spalte müssen aber alle Einträge vom gleichen Typ sein.

Daten aus einer Datenanalyse bestehen immer aus mehr als einem Datentyp. Aus diesem Grund können Matrizen oder Arrays nicht zur Datenanalyse verwendet werden, da man sonst mit verschiedenen, unverbundenen Objekten (Matrizen, Arrays) arbeiten müsste und diese nur schwer koordinieren kann.


## Gapminder data

Wir werden mit einigen der Daten aus dem [Gapminder-Projekt] (https://www.gapminder.org) 

<img src="img/gapminder.png" width="406" style="display: block; margin: auto;" />

arbeiten. Die Daten sind im [gapminder] Paket enthalten, welches wir über CRAN installieren können:


```r
install.packages("gapminder")
```

Um die Daten zu verwenden, müssen wir das Paket natürlich auch noch laden


```r
library(gapminder)
```

## Die `gapminder` Daten sind ein "tibble"

Durch das Laden des `gapminder` Pakets haben wir nun Zugriff auf einen Datenobjekt mit demselben Namen. Schau dir nun mithilfe der Funktion `str()` die Struktur des Objekts an.


```r
str(gapminder)
#> tibble [1,704 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#>  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
#>  $ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
#>  $ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#>  $ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880372..
#>  $ gdpPercap: num [1:1704] 779 821 853 836 740 ...
```

`str()` liefert eine vernünftige Beschreibung von fast allem, und im schlimmsten Fall kann tatsächlich auch nichts "Schlimmes" passieren. Aus dem Output erkennen wir, dass der Datensatz 1704 Beobachtungen enthält.


Auf der anderen Seite hätten wir durch direkten Aufruf von `gapminder` den Inhalt auch direkt auf den Bildschirm schreiben können. Aber vielleicht hast du schon mal einen größeren Datensatz aufgerufen und zögerst nun etwas, da große Datensätze einfach die Konsole füllen und nur sehr wenig Einblick bieten.

Dies ist der erste große Sieg für **tibbles**. Tidyverse bietet eine spezielle data frame Variante an: ein "tibble". Dies wird auch verdeutlicht, wenn man sich z.B. die Klasse des `gapminder` Objekts anschaut




```r
class(gapminder)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

Schau, es ist immer noch ein reguläres data frame, aber eben auch ein tibble.



Jetzt können wir `gapminder` einfach auf den Bildschirm anzeigen! Da es sich um ein tibble handelt, wird nur das Wichtigste angezeigt und deine Konsole läuft nicht voll.


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

Wenn du mit einem reinen data frame arbeitest - und dieses Feature magst - kannst du es mit `as_tibble()` in ein tibble transformieren.


```r
library(tidyverse)
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

Weitere Möglichkeiten, grundlegende Informationen zu einem data frame abzufragen:


```r
names(gapminder)
#> [1] "country"   "continent" "year"      "lifeExp"   "pop"       "gdpPercap"
ncol(gapminder)
#> [1] 6
length(gapminder)
#> [1] 6
dim(gapminder)
#> [1] 1704    6
nrow(gapminder)
#> [1] 1704
```

Ein bisschen deskriptive Statistik zum Inhalt eines data frames erhältst du mit `summary()`:


```r
summary(gapminder)
#>         country        continent        year         lifeExp    
#>  Afghanistan:  12   Africa  :624   Min.   :1952   Min.   :23.6  
#>  Albania    :  12   Americas:300   1st Qu.:1966   1st Qu.:48.2  
#>  Algeria    :  12   Asia    :396   Median :1980   Median :60.7  
#>  Angola     :  12   Europe  :360   Mean   :1980   Mean   :59.5  
#>  Argentina  :  12   Oceania : 24   3rd Qu.:1993   3rd Qu.:70.8  
#>  Australia  :  12                  Max.   :2007   Max.   :82.6  
#>  (Other)    :1632                                               
#>       pop             gdpPercap     
#>  Min.   :6.00e+04   Min.   :   241  
#>  1st Qu.:2.79e+06   1st Qu.:  1202  
#>  Median :7.02e+06   Median :  3532  
#>  Mean   :2.96e+07   Mean   :  7215  
#>  3rd Qu.:1.96e+07   3rd Qu.:  9325  
#>  Max.   :1.32e+09   Max.   :113523  
#> 
```


> **Bemerkung:** `summary()` ist eine generische Funktion. Für eine gegebene Klasse (des Inputs) bestimmt die generische Funktion die passende Methode. Die Funktion `summary()` besitzt die folgenden Methoden:

```r
methods(summary)
#>  [1] summary,ANY-method             summary,DBIObject-method      
#>  [3] summary.aov                    summary.aovlist*              
#>  [5] summary.aspell*                summary.check_packages_in_dir*
#>  [7] summary.connection             summary.data.frame            
#>  [9] summary.Date                   summary.default               
#> [11] summary.Duration*              summary.ecdf*                 
#> [13] summary.factor                 summary.ggplot*               
#> [15] summary.glm                    summary.haven_labelled*       
#> [17] summary.hcl_palettes*          summary.infl*                 
#> [19] summary.Interval*              summary.lm                    
#> [21] summary.loess*                 summary.manova                
#> [23] summary.matrix                 summary.mlm*                  
#> [25] summary.nls*                   summary.packageStatus*        
#> [27] summary.Period*                summary.POSIXct               
#> [29] summary.POSIXlt                summary.ppr*                  
#> [31] summary.prcomp*                summary.princomp*             
#> [33] summary.proc_time              summary.rlang_error*          
#> [35] summary.rlang_trace*           summary.srcfile               
#> [37] summary.srcref                 summary.stepfun               
#> [39] summary.stl*                   summary.table                 
#> [41] summary.tukeysmooth*           summary.vctrs_sclr*           
#> [43] summary.vctrs_vctr*            summary.warnings              
#> see '?methods' for accessing help and source code
```


Obwohl wir uns formell noch nicht eingehender mit der Visualisierung beschäftigt haben, ist es wichtig ein paar Grafiken zu erzeugen um einen ersten Eindruck über den Datensatz zu bekommen. Auf der anderen Seite werden die Grafiken aber auch nicht (viel) aufwendiger als im Data Visualisation Basics Primer


```r
ggplot(gapminder, mapping = aes(x = year, y = lifeExp)) +
         geom_point()
```

<img src="05_data-care-feeding_files/figure-html/first-plots-base-R-1.png" width="672" />

```r
ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
         geom_point()
```

<img src="05_data-care-feeding_files/figure-html/first-plots-base-R-2.png" width="672" />

```r
ggplot(gapminder, mapping = aes(x = log(gdpPercap), y = lifeExp)) +
         geom_point()
```

<img src="05_data-care-feeding_files/figure-html/first-plots-base-R-3.png" width="672" />


Grafiken dieser Art werden wir zu einem späteren Zeitpunkt noch genauer behandeln. Dann sprechen wir auch über deren Inhalt.


Wir schauen uns nochmal die Ausgabe von `str()` an, um darüber zu sprechen, was ein data frame genau ist.


```r
str(gapminder)
#> tibble [1,704 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#>  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
#>  $ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
#>  $ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#>  $ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880372..
#>  $ gdpPercap: num [1:1704] 779 821 853 836 740 ...
```

Ein data frame ist ein Sonderfall einer *Liste*, die in R verwendet wird, um so gut wie alles aufzunehmen. Data frames sind ein Spezialfall, bei dem die Länge jedes Listenelements gleich ist. 

Nehmen wir mal an, dass wir eine Beschreibung der Variablen


```r
names(gapminder)
#> [1] "country"   "continent" "year"      "lifeExp"   "pop"       "gdpPercap"
```

zusammen mit den Daten abspeichern wollen. Dazu könnten wir ein tibble


```r
(desc <- tibble(variables = names(gapminder),
               desc = c("factor with 142 levels", "factor with 5 levels",
                        "ranges from 1952 to 2007 in increments of 5 years",
                        "life expectancy at birth, in years",
                        "population","GDP per capita (US$, inflation-adjusted)")))
#> # A tibble: 6 x 2
#>   variables desc                                             
#>   <chr>     <chr>                                            
#> 1 country   factor with 142 levels                           
#> 2 continent factor with 5 levels                             
#> 3 year      ranges from 1952 to 2007 in increments of 5 years
#> 4 lifeExp   life expectancy at birth, in years               
#> 5 pop       population                                       
#> 6 gdpPercap GDP per capita (US$, inflation-adjusted)
```

erzeugen, das die Beschreibungen enthält. Dieses data frame hat nun die Dimension 6x2. Trotzdem können wir es mit `gapminder` kombinieren, wenn wir beide tibbles in einer Liste abspeichern


```r
gapminder_desc <- list(gapminder, desc)
str(gapminder_desc)
#> List of 2
#>  $ : tibble [1,704 × 6] (S3: tbl_df/tbl/data.frame)
#>   ..$ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 ..
#>   ..$ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 199..
#>   ..$ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#>   ..$ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880..
#>   ..$ gdpPercap: num [1:1704] 779 821 853 836 740 ...
#>  $ : tibble [6 × 2] (S3: tbl_df/tbl/data.frame)
#>   ..$ variables: chr [1:6] "country" "continent" "year" "lifeExp" ...
#>   ..$ desc     : chr [1:6] "factor with 142 levels" "factor with 5 levels" "r"..
```



## Variablen in einem Data Frame

Um eine einzelne Variable aus einem data frame anzusprechen, kann man mit dem Dollarzeichen `$` arbeiten. Wir schauen uns dazu die numerische Variable `lifeExp` an.


```r
head(gapminder$lifeExp)
#> [1] 28.8 30.3 32.0 34.0 36.1 38.4
summary(gapminder$lifeExp)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    23.6    48.2    60.7    59.5    70.8    82.6
```

Zusätzlich wollen wir die noch die Verteilung von `lifeExp` visualisieren und plotten dazu ein Histogramm. Da wir dazu `ggplot()` verwenden, können wir `lifeExp` wieder direkt aufrufen.


```r
ggplot(gapminder, mapping = aes(x = lifeExp)) + 
  geom_histogram()
#> `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="05_data-care-feeding_files/figure-html/unnamed-chunk-17-1.png" width="672" />

Alternativ können wir die Einträge eines data frames auch über die eckigen Klammern `[]` indizieren.


```r
summary(gapminder[,"lifeExp"])
#>     lifeExp    
#>  Min.   :23.6  
#>  1st Qu.:48.2  
#>  Median :60.7  
#>  Mean   :59.5  
#>  3rd Qu.:70.8  
#>  Max.   :82.6
```

Dabei spezifiziert der Eintrag links vom Komma die Zeilen und der Wert rechts davon die Spalten. Dies ist hilfreich, wenn man auf einzelne Werte zugreifen will. Aber beim Aufruf einer kompletten Variable (Spalte) ist die `$` Notation sicherlich vorteilhaft.




Die Variable `year` ist eine ganzzahlige Variable, aber da es so wenige unterschiedliche Werte gibt, funktioniert sie auch ein wenig wie eine kategoriale Variable.


```r
summary(gapminder$year)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    1952    1966    1980    1980    1993    2007
table(gapminder$year)
#> 
#> 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 2002 2007 
#>  142  142  142  142  142  142  142  142  142  142  142  142
```

Die Variablen `country` und  `continent` enthalten rein kategorische Informationen, die in R (häufig) als *factor* gespeichert werden.


```r
class(gapminder$continent)
#> [1] "factor"
summary(gapminder$continent)
#>   Africa Americas     Asia   Europe  Oceania 
#>      624      300      396      360       24
levels(gapminder$continent)
#> [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
nlevels(gapminder$continent)
#> [1] 5
```

Die __Levels__ von `continent` sind "Afrika", "America" usw., und das ist es, was einem normalerweise in R angezeigt werden sollte, wenn man eine Faktorvariable aufruft. Im Allgemeinen sind die Levels von Menschen lesbare Zeichenfolgen, wie "male/female" und "control/treated". Aber vergiss *niemals*, dass R diese Information in kodierter Form speichert. Schauen dir zum Beispiel das Ergebnis von `str(gapminder$continent)` an, falls du skeptisch sein solltest.


```r
str(gapminder$continent)
#>  Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
```

Faktorvariablen haben Vor- und Nachteil. Im weiteren Verlauf zeigen wir sowohl die Vor- wie auch die Nachteile. Generell ist aber durchaus so, dass die Vorteile überwiegen.


Als Nächstes erstellen wir mit der Funktion `table()` eine Häufigkeitstabelle für die Variable `count`. Dieser Inhalt wird anschließend visualisiert über die Funktion `geom_bar()`. Die entsprechende Berechnung der Häufigkeitstabelle wird dabei aber sowohl von `table()` wie auch von `geom_bar()` (über die statistische Transformation `stat_count()`) durchgeführt, oder anders gesagt, wir können an `geom_bar()` den Datensatz (hier `gapminder`) anstatt von vorab berechneten Werten übergeben.




```r
table(gapminder$continent)
#> 
#>   Africa Americas     Asia   Europe  Oceania 
#>      624      300      396      360       24
ggplot(gapminder, aes(x = continent)) + geom_bar()
```

<img src="05_data-care-feeding_files/figure-html/tabulate-continent-1.png" width="672" />

In den folgenden Abbildungen sehen wir, wie Faktoren in Zahlen umgesetzt werden können. Der `continent`-Faktor lässt sich durch das [ggplot2]-Paket leicht in "Facetten" oder Farben und eine Legende abbilden. 

*Die Erstellung von Grafiken mit ggplot2 werden wir noch genauer besprechen. Daher kannst du dich also ruhig zurücklehnen und die Plots genießen oder blind kopieren/einfügen.*


```r
# wir initialisieren ein grafik (ohne inhalt)
p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp))  
p <- p + scale_x_log10() # auf der x-achse soll eine log skala verwendet werden
p + geom_point() # ein scatterplot
p + geom_point(aes(color = continent)) # für verschiedene kontinente werden verschiedene farben verwendet
p + geom_point(alpha = (1/3), size = 3) + # punkte mit transparenz
  geom_smooth(lwd = 3, se = FALSE) # geglätter zusammenhang
#> `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
p + geom_point(alpha = (1/3), size = 3) + 
  facet_wrap(~ continent) + # für jeden kontinent wird eine eigener
  # plot (innerhalb einer grafik) erzeugt
  geom_smooth(lwd = 1.5, se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="05_data-care-feeding_files/figure-html/factors-nice-for-plots-1.png" width="49%" /><img src="05_data-care-feeding_files/figure-html/factors-nice-for-plots-2.png" width="49%" /><img src="05_data-care-feeding_files/figure-html/factors-nice-for-plots-3.png" width="49%" /><img src="05_data-care-feeding_files/figure-html/factors-nice-for-plots-4.png" width="49%" />


## Recap

* Benutze data frames!!!

* Benutze [tidyverse]!!! Dadurch wird eine spezielle Art von data frames, ein "tibble", bereitgestellt, die neben anderen Vorteilen ein nettes Standarddruckverhalten aufweist.

* Im Zweifelsfall kannst du dir immer Inhalte anzeigen lassen über `str()` oder im Fall eines tibbles, einfach das tibble selbst aufrufen.

* Sei dir immer über die Anzahl an  Zeilen und Spalten deiner data frames bewusst.

* Sei dir im Klaren welche Art (numerisch, kategorial,  ...) von Variablen in deinen data frames enthalten sind.

* Benutze factors!!! Aber mach das bewusst und mit Vorsicht.

* Führe für jede Variable eine grundlegende statistische und visuelle Überprüfung durch.

* Ruf Variablen mit ihrem Namen auf, z.B. `gapminder$lifeExp`, nicht mit der Spaltennummer. Dein Code wird dadurch robuster und lesbarer sein.




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
