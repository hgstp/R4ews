# Daten I/O {#import-export}




## Überblick

Im letzten Abschnitt haben wir die Gapminder-Daten als tibble aus dem [gapminder] Paket geladen. Dabei haben wir dann weder Daten, noch abgeleitete Ergebnisse, explizit in eine Datei geschrieben. Im wirklichen Leben werdet ihr aber ständig Daten, die in Tabellenform vorliegen, in R ein- und auslesen. Manchmal muss das sogar für Daten geschehen, die nicht in Tabellenform vorliegen.

> Wie macht man das? Worauf muss man aufpassen?

### Daten Import

Für das Importieren von Daten gibt es im Allgemeinen zwei Szenarien:

* *"Überrasche mich!"* Diese Haltung müsst ihr einnehmen, wenn ihr einen Datensatz erhaltet und zum ersten Mal versucht diesen einzulesen. Man muss froh sein, wenn man die Daten ohne Fehlermeldung importieren kann. Dann schaust man sich  das Ergebnis an und   entdeckt vermutlich Fehler in den Daten und/oder beim Import. Anschließend behebt ihr die Fehler und beginnt nochmal von vorne.

* *"Ein weiterer Tag im Paradies. "* Das wird vermutlich euer Gefühl sein, wenn ihr versucht einen [aufgeräumten Datensatz](#tidy) einzulesen (den jemand vorher in einem oder mehreren Reinigungsskripten  aufgeräumt hat). Es sollte keine Überraschungen geben. 

  
Im zweiten Fall, und im weiteren Verlauf des ersten Falles, lernt ihr tatsächlich eine Menge darüber, wie die Daten strukturiert sind/sein sollten. 

:::: {.content-box-orange}
__Ein wichtiger Import-Ratschlag:__ _Verwende die Argumente der Importfunktion, um so weit wie möglich und so schnell wie möglich zu kommen_. Macht man dies nicht, so sind oft nach dem Einlesen der Daten noch eine Reihe von weiteren Schritten nötig, bevor man mit der eigentlichen Analyse beginnen kann. Daher lest die Hilfe zu den Importfunktionen und nutzt die Argumente maximal aus, um den Import zu steuern.
::::

### Daten Export

Es wird viele Gelegenheiten geben, bei denen ihr Daten aus R exportieren wollt. Zwei wichtige Beispiele:

* einen gesäuberten Datensatz, der bereit ist analysiert zu werden

* ein numerisches Ergebnis aus einer Datenaggregation oder Modellierung oder einer statistischen Schlussfolgerung 


:::: {.content-box-gray}
__Erster Tipp:__  _Der Output von heute ist der Input von morgen_. Denkt an all die Schmerzen zurück, die ihr selbst beim Import von fremden Daten  erlitten habt, und fügt euch nicht selbst solche Schmerzen zu!

__Zweiter Tipp:__ Seid nicht zu clever. Eine einfache Textdatei, die von einem Menschen in einem Texteditor lesbar ist, sollte euer _Standard_ sein, bis es _einen guten Grund_ dafür gibt, dass dies nicht ausreichend ist. Das Lesen und Schreiben in exotische Formate wird das erste sein, was in Zukunft oder auf einem anderen Computer nicht mehr funktionieren wird. Es schafft auch Barrieren für jeden, der ein anderes Toolkit hat als ihr. Strebe also nach Zukunfts- und Idiotensicherheit.
::::

Wie passt das zu unserer Betonung der dynamischen Berichterstattung über R Markdown? Es gibt für alles eine Zeit und einen Ort. Es gibt Projekte und Dokumente, bei denen ihr euch intensiv mit [knitr] und [rmarkdown]  beschäftigen könnt/wollt/müsst. Aber es gibt viele gute Gründe, warum (Teile) einer Analyse nicht (nur) in einen dynamischen Bericht eingebettet werden sollten. Vielleicht wollt ihr Daten bereinigen, um einen Datensatz für eine nachfolgende Analyse zu erzeugen. Vielleicht leistet ihr einen kleinen, aber entscheidenden Beitrag zu einem gigantischen Multi-Autoren-Papier, usw. .... 

Denkt zudem daran, dass es natürlich auch noch andere Werkzeuge und Arbeitsabläufe gibt, um etwas reproduzierbar zu machen: z.B. [make]["minimal make: a minimal tutorial on make"].

## `readr`

Zur Einlesen und Ausgeben von Datensätzen verwenden wir das [readr] Paket, welches Alternativen zu den Standardfunktionen `read.table()` und `write.table()` bietet. `readr` ist Teil des [tidyverse] und daher laden wir standardmäßig einfach wieder 


```r
library(tidyverse)
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.2     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   2.0.1     ✓ forcats 0.5.1
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

__Einlesen der Gapminder Daten__

Die Gapminder Daten könnten wir natürlich wie zuvor über das Laden des `gapminder` Pakets verfügbar machen. Da es in diesem Abschnitt aber um das Einlesen von Daten geht, versuchen wir die Daten als `.tsv` Datei (Tab getrennte Werte - so sind die Daten im Paket gespeichert) einzulesen. Aber dies bedeutet natürlich, dass wir die entsprechende `.tsv` Datei erst mal finden müssen. Dabei hilft uns glücklicherweise das [fs] Paket.


```r
library(fs)
(gap_tsv <- path_package("gapminder", "extdata", "gapminder.tsv"))
## /Library/Frameworks/R.framework/Versions/4.0/Resources/library/gapminder/extdata/gapminder.tsv
```

Nachdem wir jetzt den Speicherort der Datei kennen, können wir versuchen sie einzulesen.


## Einlesen von Daten in Tabellenform

Die Haupt-Funktion zum Einlesen von Daten in readr ist `read_delim()`. Hier verwenden wir eine Variante, `read_tsv()`, für Tab getrennte Daten:


```r
gapminder <- read_tsv(gap_tsv)
## Rows: 1704 Columns: 6
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: "\t"
## chr (2): country, continent
## dbl (4): year, lifeExp, pop, gdpPercap
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
glimpse(gapminder)
## Rows: 1,704
## Columns: 6
## $ country   <chr> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan", …
## $ continent <chr> "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asi…
## $ year      <dbl> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, …
## $ lifeExp   <dbl> 28.8, 30.3, 32.0, 34.0, 36.1, 38.4, 39.9, 40.8, 41.7, 41.8, …
## $ pop       <dbl> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 12…
## $ gdpPercap <dbl> 779, 821, 853, 836, 740, 786, 978, 852, 649, 635, 727, 975, …
```


Über den Tabulator Spalten in einer Datentabelle zu trennen, ist natürlich nur eine Variante neben weiteren Alternativen wie 

+ Komma: `read_csv()`

+ Strichpunkt: `read_csv2()`

+ Leerzeichen: `read_table()`

+ ...


Für volle Flexibilität bei der Angabe des Trennzeichens kann aber jederzeit direkt `read_delim()` verwendet werden.



Der auffälligste Unterschied zwischen den [readr]-Funktionen und der Standardfunktion `read.table()`ist, dass [readr] standardmäßig characters __NICHT__ in Faktoren umwandelt. Im Großen und Ganzen ist dies schon vorteilhafter, obwohl es natürlich auch immer wieder vorkommen wird, dass ihr einzelne Variablen beim Einlesen explizit als Faktorvariable einlesen werdet. 


> Fazit: Benutzt `readr::read_delim()` und "Freunde".


Die Gapminder-Daten sind zu sauber und einfach, um die großartigen Funktionen von readr zur Geltung zu bringen. Ein Blick in [Introduction to readr](https://cloud.r-project.org/web/packages/readr/vignettes/readr.html) zeigt aber noch viele weitere Anpassungsmöglichkeiten der readr Funktionen.

## Daten exportieren 

Bevor wir etwas exportieren können, müssen wir natürlich (was so sicher nicht richtig ist - niemand zwingt uns dazu 😉) etwas berechnen, das es wert ist,  exportiert zu werden. Lasst uns doch eine Zusammenfassung der maximalen Lebenserwartung auf Länderebene erstellen.


```r
gap_life_exp <- gapminder %>%
  group_by(country, continent) %>% 
  summarise(life_exp = max(lifeExp)) %>% 
  ungroup()
## `summarise()` has grouped output by 'country'. You can override using the `.groups` argument.
gap_life_exp
## # A tibble: 142 x 3
##    country     continent life_exp
##    <chr>       <chr>        <dbl>
##  1 Afghanistan Asia          43.8
##  2 Albania     Europe        76.4
##  3 Algeria     Africa        72.3
##  4 Angola      Africa        42.7
##  5 Argentina   Americas      75.3
##  6 Australia   Oceania       81.2
##  7 Austria     Europe        79.8
##  8 Bahrain     Asia          75.6
##  9 Bangladesh  Asia          64.1
## 10 Belgium     Europe        79.4
## # … with 132 more rows
```

Das Objekt `gap_life_exp` ist nun ein Beispiel für ein Zwischenergebnis, das wir für die Zukunft und für nachgelagerte Analysen oder Visualisierungen speichern wollen.

Die Haupt-Exportfunktion in readr ist `write_delim()`. Für verschiedene Dateiformate gibt es auch hier wieder verschiedene Komfortfunktionen. Mithilfe von `write_csv()` können wir den Inhalt von `gap_life_exp` in einer kommagetrennten Datei abspeichern.



```r
write_csv(gap_life_exp, "data/gap_life_exp.csv")
```

Schauen wir uns die ersten paar Zeilen von `gap_life_exp.csv` an. Dazu können wir entweder die Datei öffnen oder, im Terminal, `head` darauf anwenden.


```
country,continent,life_exp
Afghanistan,Asia,43.828
Albania,Europe,76.423
Algeria,Africa,72.301
Angola,Africa,42.731
Argentina,Americas,75.32
```

Das sieht recht ordentlich aus, obwohl es keine sichtbare Ausrichtung oder Trennung in Spalten gibt. Hätten wir die Basisfunktion `read.csv()` benutzt, würden wir Zeilennamen und viele Anführungszeichen sehen, es sei denn, wir hätten diese Features explizit abgeschaltet. Das schönere Standardverhalten ist daher der Hauptgrund, warum wir `readr::write_csv()` gegenüber `write.csv()` bevorzugen.

:::: {.content-box-grey}
Es ist nicht wirklich fair, sich über den Mangel an sichtbarer Ausrichtung zu beklagen, schließlich erzeugen wir Dateien, die der Computer lesen soll. Falls ihr aber wirklich in der Datei "herumstöbern" wollt, benutzt  `View()` in RStudio oder öffnen die Datei mit einem Spreadsheet Programm (!). Aber erliegt __NIE__ der Versuchung, dort Datenmanipulationen vorzunehmen ... kehrt zurück zu R und schreibt dort die entsprechenden Befehle, die ihr die nächsten 15 Mal (oder so oft wie nötig) ausführen könnt, wenn ihr diesen Datensatz (oder Datensätze derselben Form) importieren/bereinigen/aggregieren/exportieren wollt. 
::::


## Daten über eine API

Interessante Datensätze sind der _Treibstoff_ für ein gutes Data Science Projekt. APIs (Application Programming Interface) sind eine weitere sehr nützliche Methode, um auf interessante Daten zuzugreifen.

Anstatt einen Datensatz herunterladen zu müssen, ermöglichen APIs Daten direkt von bestimmten Webseiten über eine Schnittstelle anzufordern. Viele große Webseiten wie [Twitter](https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/intro-to-social-media-text-mining-r/) und Facebook ermöglichen über APIs den Zugriff auf Teile ihrer Daten.

Wir werden die Grundlagen des Zugriffs auf eine API besprechen. Dazu benötigt ihr aber kein Vorwissen bzgl. APIs.

### Einführung

API ist ein allgemeiner Begriff für den Ort, an dem ein Computerprogramm mit einem anderen oder mit sich selbst interagiert. Wir sprechen über Web-APIs, bei denen zwei verschiedene Computer - ein Client und ein Server - miteinander interagieren, um Daten anzufordern bzw. bereitzustellen.

APIs bieten eine ausgefeilte Möglichkeit Daten von einer Webseite anzufordern. Wenn eine Webseite wie Twitter eine API einrichtet, richten sie im Wesentlichen einen Computer ein, der auf Datenanfragen wartet.

Sobald dieser Computer eine Datenanforderung empfängt, verarbeitet er die Daten selbst und sendet sie an den Computer, der sie angefordert hat. Unsere Aufgabe als Anforderer der Daten wird es sein R Code zu schreiben, der die Anforderung erstellt und dem Computer, auf dem die API läuft, mitteilt, was wir benötigen. Dieser Computer liest dann unseren Code, verarbeitet die Anfrage und gibt schön formatierte Daten zurück, die mithilfe existierender R Pakete verarbeitet werden können..


### Erstellen von API-Anforderungen in R

Um mit APIs in R zu arbeiten, müssen wir ein paar neue Pakete laden (und vorher natürlich installieren). Konkret werden wir mit den Paketen  `httr` und `jsonlite` arbeiten. Sie spielen bei der Einbindung der APIs unterschiedliche Rollen, aber beide sind unverzichtbar.

Vermutlich habt ihr die beiden Pakete bisher nicht installiert. Dahersstarten wir mit dem Installieren dieser beiden Pakete


```r
install.packages(c("httr", "jsonlite"))

```

und laden sie anschließend 


```r
library(httr)
library(jsonlite)
## 
## Attaching package: 'jsonlite'
## The following object is masked from 'package:purrr':
## 
##     flatten
```


### Unsere erste API-Anfrage stellen

Der erste Schritt, um Daten von einer API zu erhalten, ist die eigentliche Anfrage in R. Diese Anfrage wird an den Server geschickt, der über die API verfügt, und wenn alles reibungslos verläuft, wird er uns eine Antwort zurücksenden. 


Es gibt verschiedene Arten von Anfragen, die man an einen API-Server stellen kann. Diese verschiedenen Typen von Anfragen entsprechen verschiedenen Aktionen, die der Server ausführen soll.

Für unsere Zwecke fragen wir lediglich nach Daten, was einer __GET__-Anfrage entspricht. Andere Arten von Anfragen sind z.B. POST und PUT, aber diese sind für uns nicht von Interesse und daher brauchen wir uns darum nicht zu kümmern.

Um eine GET-Anfrage zu erstellen, müssen wir die `GET()` Funktion aus dem `httr` Paket verwenden. Die `GET()` Funktion benötigt als Input eine URL, die die Adresse des Servers angibt, an den die Anforderung gesendet werden soll.


Als Beispiel werden wir mit der [Open Notify](http://open-notify.org/) API arbeiten, die Daten zu verschiedenen NASA-Projekten enthält. Mithilfe der Open Notify API können wir uns über den Standort der Internationalen Raumstation informieren und erfahren, wie viele Personen sich derzeit im Weltraum aufhalten.

Wir beginnen damit, dass wir unsere Anfrage mit der `GET()` Funktion stellen und die URL der API angeben:


```r
jdata <- GET("http://api.open-notify.org/astros.json")
```

Die Ausgabe der Funktion `GET()` ist eine Liste, die alle Informationen enthält, die vom API-Server zurückgegeben werden. 


### `GET()` Ausgabe

Schauen wir uns einmal an, wie die Variable jdata in der R-Konsole aussieht:


```r
jdata
## Response [http://api.open-notify.org/astros.json]
##   Date: 2021-12-07 22:11
##   Status: 200
##   Content-Type: application/json
##   Size: 497 B
```

Als erstes fällt auf, dass die URL enthalten ist, an die die GET-Anfrage gesendet wurde. Außerdem erkennen wir das Datum und die Uhrzeit, zu der die Anfrage gestellt wurde, sowie die Größe der Antwort.

Die Information `Content-Type` gibt uns eine Vorstellung davon, welche Form die Daten haben. Diese spezielle Antwort besagt, dass die Daten ein JSON-Format annehmen, womit auch klar ist warum wir das Paket `jsonlite` geladen haben.

Der Status verdient eine besondere Aufmerksamkeit. `Status` bezieht sich auf den Erfolg oder Misserfolg der API-Anfrage, und er wird in Form einer Zahl angegeben. Die zurückgegebene Nummer gibt Auskunft darüber, ob die Anfrage erfolgreich war oder nicht. Dort können auch Gründe für einen möglichen Misserfolg enthalten sein.

Die Zahl 200 ist das, was wir sehen wollen. Sie entspricht einem erfolgreichen Antrag, und das ist es, was wir hier haben. Eine Übersicht über weitere Status Codes findet man z.B. auf dieser [Webseite](https://www.restapitutorial.com/httpstatuscodes.html.


### Handling JSON Data

[JSON](https://www.json.org/json-en.html) steht für JavaScript Object Notation. Während JavaScript eine weitere Programmiersprache ist, liegt unser Schwerpunkt bei JSON auf seiner Struktur. JSON ist nützlich, weil es von einem Computer leicht lesbar ist, und aus diesem Grund ist es zur primären Art und Weise geworden, wie Daten über APIs transportiert werden. Die meisten APIs senden ihre Antworten im JSON-Format.

JSON ist als eine Reihe von Schlüssel-Werte-Paaren formatiert, wobei ein bestimmtes Wort ("Schlüssel") mit einem bestimmten Wert assoziiert ist. Ein Beispiel für diese Schlüssel-Wert-Struktur ist unten dargestellt:

```
{
    “name”: “Jane Doe”,
    “number_of_skills”: 2
}
```

In ihrem aktuellen Zustand sind die Daten in der Variablen `jdata` nicht verwendbar. Die Daten sind als Unicode-Rohdaten in `jdata` enthalten, und müssen in das JSON-Format konvertiert werden.

Dazu müssen wir zunächst den rohen Unicode in character Daten konvertieren, die dem oben gezeigten JSON-Format ähneln. Die Funktion `rawToChar()` führt genau diese Aufgabe aus:



```r
rawToChar(jdata$content)
## [1] "{\"message\": \"success\", \"people\": [{\"name\": \"Mark Vande Hei\", \"craft\": \"ISS\"}, {\"name\": \"Pyotr Dubrov\", \"craft\": \"ISS\"}, {\"name\": \"Anton Shkaplerov\", \"craft\": \"ISS\"}, {\"name\": \"Zhai Zhigang\", \"craft\": \"Shenzhou 13\"}, {\"name\": \"Wang Yaping\", \"craft\": \"Shenzhou 13\"}, {\"name\": \"Ye Guangfu\", \"craft\": \"Shenzhou 13\"}, {\"name\": \"Raja Chari\", \"craft\": \"ISS\"}, {\"name\": \"Tom Marshburn\", \"craft\": \"ISS\"}, {\"name\": \"Kayla Barron\", \"craft\": \"ISS\"}, {\"name\": \"Matthias Maurer\", \"craft\": \"ISS\"}], \"number\": 10}"
```


Die resultierende Zeichenfolge sieht zwar recht unordentlich aus, aber es liegt wirklich die JSON-Struktur vor.

Ausgehend von diesem character Vektor können wir nun mit `fromJSON()`, aus dem `jsonlite` Paket, alles in ein Listenformat transformieren.

Die `fromJSON()` Funktion benötigt einen character Vektor, der die JSON-Struktur enthält, die wir aus der Ausgabe von `rawToChar()` erhalten haben. Wenn wir also diese beiden Funktionen nacheinander anwenden, erhalten wir die gewünschten Daten in einem Format, das wir in R leicht bearbeiten können.


```r
data <-  fromJSON(rawToChar(jdata$content))
glimpse(data)
## List of 3
##  $ message: chr "success"
##  $ people :'data.frame':	10 obs. of  2 variables:
##   ..$ name : chr [1:10] "Mark Vande Hei" "Pyotr Dubrov" "Anton Shkaplerov" "Z"..
##   ..$ craft: chr [1:10] "ISS" "ISS" "ISS" "Shenzhou 13" ...
##  $ number : int 10
```

Die Liste `data` hat drei Elemente. Uns interessiert in erster Linie das Data Frame `people`.


```r
data$people
##                name       craft
## 1    Mark Vande Hei         ISS
## 2      Pyotr Dubrov         ISS
## 3  Anton Shkaplerov         ISS
## 4      Zhai Zhigang Shenzhou 13
## 5       Wang Yaping Shenzhou 13
## 6        Ye Guangfu Shenzhou 13
## 7        Raja Chari         ISS
## 8     Tom Marshburn         ISS
## 9      Kayla Barron         ISS
## 10  Matthias Maurer         ISS
```


Also, da haben wir unsere Antwort: Zum Zeitpunkt des letzten Updates Dec 07, 2021 von R4ews befanden sich 10 Personen im Weltraum. Aber wenn ihr den Code zu einem späteren Zeitpunkt ausprobiert, könnten es auch schon wieder andere Namen und eine andere Anzahl sein. Das ist einer der Vorteile von APIs - im Gegensatz zu Datensätzen, die man im Spreadsheet Format herunterladen kann, werden sie in der Regel in Echtzeit oder nahezu in Echtzeit aktualisiert. APIs bieten somit die Möglichkeit leicht auf sehr aktuellen Daten zuzugreifen.


In diesem Beispiel haben wir einen sehr unkomplizierten API-Workflow durchlaufen. Die meisten APIs fordern, dass man demselben allgemeinen Muster folgt, aber dabei können die jeweilgen Aufrufe/Befehle durchaus deutlich komplexer sein.

In unserem Beispiel war es ausreichen nur die URL anzugeben. Aber einige APIs verlangen mehr Informationen vom Benutzer. Im letzten Teil dieser Einführung gehen wir darauf ein, wie ihr der API in eurer Anfrage zusätzliche Informationen zur Verfügung stellen könnt.

### APIs und Abfrageparameter

Was wäre, wenn wir wissen wollten, wann die ISS einen bestimmten Ort auf der Erde überfliegen würde? Die ISS Pass Times API von Open Notify verlangt von uns, dass wir zusätzliche Parameter angeben, bevor sie die gewünschten Daten zurückgeben kann.

Wir müssen den Längen- und Breitengrad des Ortes angeben, nach dem wir im Rahmen unserer `GET()` Anfrage fragen. Sobald ein Längen- und Breitengrad angegeben ist, werden sie als Abfrageparameter mit der ursprünglichen URL kombiniert.

Lasst uns die API verwenden, um herauszufinden, wann die ISS Garching (auf 48.24896 Breiten- und  11.65101 Längengrad) passieren wird:


```r
jdata <-  GET("http://api.open-notify.org/iss-pass.json",
    query = list(lat = 48.24896, lon = 11.65101))
```


Man muss in der Dokumentation für die API, mit der man arbeiten will, nachsehen, ob es erforderliche Abfrageparameter gibt. Für die überwiegende Mehrheit der APIs, auf die ihr möglicherweise zugreifen möchtet, existiert eine Dokumentation, die beschreibt welche Parameter in der Anfrage enthalten sein müssen, um ein gewünschtes Ergebnis zurückzugeben. 

Wie auch immer, jetzt, da wir unsere Anfrage einschließlich der Standortparameter gestellt haben, können wir die Antwort mit den gleichen Funktionen überprüfen, die wir zuvor verwendet haben. Lasst uns die Daten aus der Antwort extrahieren:



```r
data <- fromJSON(rawToChar(jdata$content))
data$response
##   duration   risetime
## 1      456 1638954002
## 2      642 1638959671
## 3      657 1638965469
## 4      653 1638971299
## 5      657 1638977115
```



Diese API gibt uns die Zeit in Form von [Unixzeit](https://de.wikipedia.org/wiki/Unixzeit) zurück. Unixzeit ist die Zeitspanne, die seit dem 1. Januar 1970 vergangen ist. Mithilfe der Funktion `as_datetime()` aus dem [lubridate] Paket können wir die Unixzeit aber leicht umrechnen


```r
lubridate::as_datetime(data$response$risetime)
## [1] "2021-12-08 09:00:02 UTC" "2021-12-08 10:34:31 UTC"
## [3] "2021-12-08 12:11:09 UTC" "2021-12-08 13:48:19 UTC"
## [5] "2021-12-08 15:25:15 UTC"
```



Damit wollen wir den Abschnitt zu APIs beenden. Macht euch bewusst, dass wir hier wirklich nur die Basics in Bezug auf APIs eingeführt haben. Aber hoffentlich hat euch diese Einführung trotzdem ausreichend Vertrauen gegeben, sich mit einigen komplexeren und leistungsfähigeren APIs auseinanderzusetzen. Hoffentlich seid ihr nun in der Lage euch eine ganz neue Welt von Daten zu erschließen, die darauf warten erforscht zu werden!



## Weiteres Material

Wer noch mehr zum Thema Daten Import lesen will, der soll einen Blick in das Kapitel [Data import](http://r4ds.had.co.nz/data-import.html) im Buch [R for Data Science] von Hadley Wickham und Garrett Grolemund [-@wickham2016] werfen.







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



