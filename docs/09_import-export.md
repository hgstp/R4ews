# Daten I/O {#import-export}




## Überblick

Wir haben die Gapminder-Daten als tibble aus dem [gapminder] Paket geladen. Wir haben im letzten Abschnitt weder Daten noch abgeleitete Ergebnisse explizit in eine Datei geschrieben. Im wirklichen Leben wirst du aber ständig Daten, die in Tabellenform vorliegen, in R ein- und auslesen. Manchmal muss das sogar für Daten geschehen, die nicht in Tabellenform vorliegen.

Wie macht man das? Worauf muss man aufpassen?

### Daten Import

Für den Daten Import gibt es im Allgemeinen zwei Möglichkeiten:

* *"Überrasche mich!"* Diese Haltung musst du einnehmen, wenn du zum ersten Mal einen Datensatz erhältst. Du musst einfach froh, wenn du die Daten ohne Fehler importieren konntest. Dann schaust du dir das Ergebnis an,  entdeckst Fehler in den Daten und/oder beim Import. Du behebst sie und beginnst nochmal von vorne.
* *"Ein weiterer Tag im Paradies. "* Das ist die Einstellung, wenn du einen aufgeräumten Datensatz einliest, den du vorher in einem oder mehreren Reinigungsskripten wahnsinnig aufgeräumt haben. Es sollte keine Überraschungen geben. 

  
Im zweiten Fall, und im weiteren Verlauf des ersten Falles, lernst du tatsächlich eine Menge darüber, wie die Daten sind/sein sollten. Ein wichtiger Import-Ratschlag: **Verwende die Argumente der Importfunktion, um so weit wie möglich und so schnell wie möglich zu kommen**. Anfängercode hat oft eine Menge unnötigen nachträglichen Aufwand. Lese die Hilfe zu den Importfunktionen und nutzen die Argumente maximal aus, um den Import zu steuern.

### Daten Export

Es wird viele Gelegenheiten geben, bei denen du Daten aus R exportieren willst. Zwei wichtige Beispiele:

* einen gesäuberten Datensatz der bereit ist analysiert zu werden, den du heldenhaft aus recht unordentlichen Daten erstellt hast
* ein numerisches Ergebnis aus einer Datenaggregation oder Modellierung oder einer statistischen Schlussfolgerung 

Erster Tipp: __Der Output von heute ist der Input von morgen__. Denke an all die Schmerzen zurück, die du selbst beim Import von fremden Daten  erlitten hast, und fügen dir nicht selbst solche Schmerzen zu!

Zweiter Tipp: Sei nicht zu clever. Eine einfache Textdatei, die von einem Menschen in einem Texteditor lesbar ist, sollte dein Standard sein, bis du __einen guten Grund__ dafür hast, dass dies nicht funktionieren wird. Das Lesen und Schreiben in exotische Formate wird das erste sein, was in Zukunft oder auf einem anderen Computer kaputtgehen wird. Es schafft auch Barrieren für jeden, der ein anderes Toolkit hat als du. Strebe nach Zukunfts- und Idiotensicherheit.


Wie passt das zu unserer Betonung der dynamischen Berichterstattung über R Markdown? Es gibt für alles eine Zeit und einen Ort. Es gibt Projekte und Dokumente, bei denen du dich intensiv mit [knitr] und [rmarkdown]  beschäftigen kannst/willst/musst. Aber es gibt viele gute Gründe, warum (Teile von) einer Analyse nicht (nur) in einen dynamischen Bericht eingebettet werden sollten. Vielleicht bist du gerade dabei Daten zu bereinigen, um einen Datensatz für eine nachfolgende Analyse zu erzeugen. Vielleicht leistet du einen kleinen, aber entscheidenden Beitrag zu einem gigantischen Multi-Autoren-Papier. Etc. Denke auch daran, dass es natürlich auch noch andere Werkzeuge und Arbeitsabläufe gibt, um etwas reproduzierbar zu machen: z.B. [make]["minimal make: a minimal tutorial on make"].

## Load the tidyverse

Das Hauptpaket, das wir verwenden werden, ist [readr], welches Alternativen zu den Standardfunktionen `read.table()` und `write.table()` bietet. Trotzdem laden wir standardmäßig einfach wieder [tidyverse].


```r
library(tidyverse)
#> ── Attaching packages ───────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.3     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ──────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

## Einlesen der Gapminder Daten

Die Gapminder Daten könnten wir natürlich wie zuvor über das Laden des `gapminder` Pakets verfügbar machen. Da es in diesem Abschnitt aber um das Einlesen von Daten geht, versuchen wir die Daten als `.tsv` Datei (tab-separated values - so sind sie im Paket gespeichert) einzulesen. Aber dies bedeutet natürlich, dass wir die entsprechende `.tsv` Datei erst mal finden müssen. Dabei hilft uns glücklicherweise das [fs] Paket.


```r
library(fs)
(gap_tsv <- path_package("gapminder", "extdata", "gapminder.tsv"))
#> /Users/hgstp/Library/R/4.0/library/gapminder/extdata/gapminder.tsv
```

Nachdem wir jetzt den Speicherort der Datei kennen, können wir versuchen sie einzulesen.


## Einlesen von Daten in Tabellenform

Die Haupt-Funktion zum Einlesen von Daten in readr ist `read_delim()`. Hier verwenden wir eine Variante, `read_tsv()`, für tabulatorgetrennte Daten:


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
glimpse(gapminder)
#> Rows: 1,704
#> Columns: 6
#> $ country   <chr> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan",…
#> $ continent <chr> "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "As…
#> $ year      <dbl> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997,…
#> $ lifeExp   <dbl> 28.8, 30.3, 32.0, 34.0, 36.1, 38.4, 39.9, 40.8, 41.7, 41.8,…
#> $ pop       <dbl> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 1…
#> $ gdpPercap <dbl> 779, 821, 853, 836, 740, 786, 978, 852, 649, 635, 727, 975,…
```


Über den Tabulator Spalten in einer Datentabelle zu trennen, ist natürlich nur eine Variante neben weiteren Alternativen wie Komma, Strichpunkt, Leerzeichen, ...

Für Komma getrennte Daten würde man beispielsweise `read_csv()` verwenden. Für volle Flexibilität bei der Angabe des Trennzeichens kannst du aber jederzeit direkt `read_delim()` verwenden.



Der auffälligste Unterschied zwischen den readr-Funktionen und der Standardfunktion `read.table()`ist, dass readr standardmäßig Characters NICHT in Faktoren umwandelt. Im Großen und Ganzen ist dies ein besseres Standardverhalten, obwohl es natürlich immer wieder vorkommen wird, dass du einzelne Variablen nach dem Einlesen in einen Faktoren umwandeln wirst. Aber lass dich davon nicht täuschen - im Allgemeinen wirst du durch die Verwendung von readr nach dem Einlesen  weniger Anpassungen machen müssen im Vergleich zum Standardvorgehen.

> Fazit: Benutze `readr::read_delim()` und "Freunde".


Die Gapminder-Daten sind zu sauber und einfach, um die großartigen Funktionen von readr zur Geltung zu bringen. Ein Blick in [Introduction to readr](https://cloud.r-project.org/web/packages/readr/vignettes/readr.html) zeigt aber noch viele weitere Anpassungsmöglichkeiten der readr Funktionen.

## Daten exportieren 

Bevor wir etwas exportieren können, müssen (das ist natürlich so nicht richtig - niemand zwingt uns dazu) etwas berechnen, das es wert ist,  exportiert zu werden. Lass uns eine Zusammenfassung der maximalen Lebenserwartung auf Länderebene erstellen.


```r
gap_life_exp <- gapminder %>%
  group_by(country, continent) %>% 
  summarise(life_exp = max(lifeExp)) %>% 
  ungroup()
#> `summarise()` regrouping output by 'country' (override with `.groups` argument)
gap_life_exp
#> # A tibble: 142 x 3
#>    country     continent life_exp
#>    <chr>       <chr>        <dbl>
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

Das `gap_life_exp` data frame ist ein Beispiel für ein Zwischenergebnis, das wir für die Zukunft und für nachgelagerte Analysen oder Visualisierungen speichern wollen.

Die Haupt-Exportfunktion in readr ist `write_delim()`. Für verschiedene Dateiformate gibt es auch hier wieder verschiedene Komfortfunktionen. Lass uns `write_csv()` benutzen, um eine kommagetrennte Datei zu erhalten.


```r
write_csv(gap_life_exp, "gap_life_exp.csv")
```

Schauen wir uns die ersten paar Zeilen von `gap_life_exp.csv` an. Dazu kannst du entweder die Datei öffnen oder, im Terminal, `head` darauf anwenden.


```
country,continent,life_exp
Afghanistan,Asia,43.828
Albania,Europe,76.423
Algeria,Africa,72.301
Angola,Africa,42.731
Argentina,Americas,75.32
```

Das sieht recht ordentlich aus, obwohl es keine sichtbare Ausrichtung oder Trennung in Spalten gibt. Hätten wir die Basisfunktion `read.csv()` benutzt, würden wir Zeilennamen und viele Anführungszeichen sehen, es sei denn, wir hätten diese Features explizit abgeschaltet. Das schönere Standardverhalten ist daher der Hauptgrund, warum wir `readr::write_csv()` gegenüber `write.csv()` bevorzugen.

> Es ist nicht wirklich fair, sich über den Mangel an sichtbarer Ausrichtung zu beklagen, schließlich erzeugen wir Dateien, die der Computer lesen soll. Falls du wirklich in der Datei "herumstöbern" willst, benutze  `View()` in RStudio oder öffnen die Datei mit einem Spreadsheet Programm (!). Aber erliege NIE der Versuchung, dort Datenmanipulationen vorzunehmen ... gehe  zurück zu R und schreibe dort die Befehle, die du die nächsten 15 Mal ausführen kannst, wenn du diesen Datensatz (oder Datensätze derselben Form) importieren/bereinigen/aggregieren/exportieren willst. 


## Daten über eine API

Interessante Datensätze sind der Treibstoff für ein gutes Data Science Projekt. APIs (Application Programming Interface) sind eine weitere sehr nützliche Methode, um auf interessante Daten zuzugreifen.

Anstatt einen Datensatz herunterladen zu müssen, ermöglichen APIs Daten direkt von bestimmten Websites über eine Schnittstelle anzufordern. Viele große Webseiten wie Twitter und Facebook ermöglichen über APIs den Zugriff auf Teile ihrer Daten.

Wir werden die Grundlagen des Zugriffs auf eine API besprechen. Dazu benötigst du aber keine Vorwissen bzgl. APIs.

### Einführung

API ist ein allgemeiner Begriff für den Ort, an dem ein Computerprogramm mit einem anderen oder mit sich selbst interagiert. Wir sprechen über Web-APIs, bei denen zwei verschiedene Computer - ein Client und ein Server - miteinander interagieren, um Daten anzufordern bzw. bereitzustellen.

APIs bieten eine ausgefeilte Möglichkeit Daten von einer Website anzufordern. Wenn eine Website wie Twitter eine API einrichtet, richten sie im Wesentlichen einen Computer ein, der auf Datenanfragen wartet.

Sobald dieser Computer eine Datenanforderung empfängt, verarbeitet er die Daten selbst und sendet sie an den Computer, der sie angefordert hat. Unsere Aufgabe als Anforderer der Daten wird es sein R Code zu schreiben, der die Anforderung erstellt und dem Computer, auf dem die API läuft, mitteilt, was wir benötigen. Dieser Computer liest dann unseren Code, verarbeitet die Anfrage und gibt schön formatierte Daten zurück, die mithilfe existierender R Pakete verarbeitet werden können..


### Erstellen von API-Anforderungen in R

Um mit APIs in R zu arbeiten, müssen wir ein paar neue Pakete laden (und vorher natürlich installieren). Konkret werden wir mit den Paketen  `httr` und `jsonlite` arbeiten. Sie spielen bei der Einbindung der APIs unterschiedliche Rollen, aber beide sind unverzichtbar.

Vermutlich hast du die beiden Pakete bisher nicht installiert. Daher ist der erste Schritt die beiden Pakete zu installieren


```r
install.packages(c("httr", "jsonlite"))

```

und anschließend zu laden


```r
library(httr)
library(jsonlite)
#> 
#> Attaching package: 'jsonlite'
#> The following object is masked from 'package:purrr':
#> 
#>     flatten
```


### Unsere erste API-Anfrage stellen

Der erste Schritt, um Daten von einer API zu erhalten, ist die eigentliche Anfrage in R. Diese Anfrage wird an den Computer-Server geschickt, der über die API verfügt, und wenn alles reibungslos verläuft, wird er eine Antwort zurücksenden. 


Es gibt verschiedene Arten von Anfragen, die man an einen API-Server stellen kann. Diese Arten von Anfragen entsprechen verschiedenen Aktionen, die der Server ausführen soll.

Für unsere Zwecke fragen wir lediglich nach Daten, was einer GET-Anfrage entspricht. Andere Arten von Anfragen sind z.B. POST und PUT, aber diese sind für uns nicht von Interesse und daher brauchen wir uns darum nicht zu kümmern.

Um eine GET-Anfrage zu erstellen, müssen wir die `GET()` Funktion aus dem `httr` Paket verwenden. Die `GET()` Funktion benötigt als Input eine URL, die die Adresse des Servers angibt, an den die Anforderung gesendet werden soll.


Als Beispiel werden wir mit der Open Notify API arbeiten, die Daten zu verschiedenen NASA-Projekten enthält. Mithilfe der Open Notify API können wir uns über den Standort der Internationalen Raumstation informieren und erfahren, wie viele Personen sich derzeit im Weltraum aufhalten.

Wir beginnen damit, dass wir unsere Anfrage mit der `GET()` Funktion stellen und die URL der API angeben:


```r
jdata <- GET("http://api.open-notify.org/astros.json")
```

Die Ausgabe der Funktion `GET()` ist eine Liste, die alle Informationen enthält, die vom API-Server zurückgegeben werden. 


### `GET()` Ausgabe

Schauen wir uns einmal an, wie die Variable jdata in der R-Konsole aussieht:


```r
jdata
#> Response [http://api.open-notify.org/astros.json]
#>   Date: 2020-12-03 16:29
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 356 B
```

Als erstes fällt auf, dass die URL enthalten ist, an die die GET-Anfrage gesendet wurde. Außerdem sehen wir das Datum und die Uhrzeit, zu der die Anfrage gestellt wurde, sowie die Größe der Antwort.

Die Information `Content-Type` gibt uns eine Vorstellung davon, welche Form die Daten haben. Diese spezielle Antwort besagt, dass die Daten ein JSON-Format annehmen, womit auch klar ist warum wir das Paket `jsonlite` ebenfalls geladen haben.

Der Status verdient eine besondere Aufmerksamkeit. `Status` bezieht sich auf den Erfolg oder Misserfolg der API-Anfrage, und er wird in Form einer Zahl angegeben. Die zurückgegebene Nummer gibt Auskunft darüber, ob die Anfrage erfolgreich war oder nicht, und kann auch einige Gründe für einen möglichen Misserfolg nennen.

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

Dazu müssen wir zunächst den rohen Unicode in Character Daten konvertieren, die dem oben gezeigten JSON-Format ähneln. Die Funktion `rawToChar()` führt genau diese Aufgabe aus:



```r
rawToChar(jdata$content)
#> [1] "{\"message\": \"success\", \"number\": 7, \"people\": [{\"craft\": \"ISS\", \"name\": \"Sergey Ryzhikov\"}, {\"craft\": \"ISS\", \"name\": \"Kate Rubins\"}, {\"craft\": \"ISS\", \"name\": \"Sergey Kud-Sverchkov\"}, {\"craft\": \"ISS\", \"name\": \"Mike Hopkins\"}, {\"craft\": \"ISS\", \"name\": \"Victor Glover\"}, {\"craft\": \"ISS\", \"name\": \"Shannon Walker\"}, {\"craft\": \"ISS\", \"name\": \"Soichi Noguchi\"}]}"
```


Die resultierende Zeichenfolge sieht zwar recht unordentlich aus, aber es liegt wirklich die JSON-Struktur vor.

Ausgehend von diesem Character Vektor können wir nun mit `fromJSON()` aus dem `jsonlite` alles in ein Listenformat transformieren.

Die `fromJSON()` Funktion benötigt einen Character Vektor, der die JSON-Struktur enthält, die wir aus der Ausgabe von `rawToChar()` erhalten haben. Wenn wir also diese beiden Funktionen aneinanderreihen, erhalten wir die gewünschten Daten in einem Format, das wir in R leichter bearbeiten können.


```r
data <-  fromJSON(rawToChar(jdata$content))
glimpse(data)
#> List of 3
#>  $ message: chr "success"
#>  $ number : int 7
#>  $ people :'data.frame':	7 obs. of  2 variables:
#>   ..$ craft: chr [1:7] "ISS" "ISS" "ISS" "ISS" ...
#>   ..$ name : chr [1:7] "Sergey Ryzhikov" "Kate Rubins" "Sergey Kud-Sverchkov""..
```

Die Liste `data` hat drei Elemente. Uns interessiert in erster Linie das Data Frame `people`.


```r
data$people
#>   craft                 name
#> 1   ISS      Sergey Ryzhikov
#> 2   ISS          Kate Rubins
#> 3   ISS Sergey Kud-Sverchkov
#> 4   ISS         Mike Hopkins
#> 5   ISS        Victor Glover
#> 6   ISS       Shannon Walker
#> 7   ISS       Soichi Noguchi
```


Also, da haben wir unsere Antwort: Zum Zeitpunkt des letzten Updates Thu Dec  3 17:29:01 2020 von R4ews befanden sich 7 Personen im Weltraum. Aber wenn du alles selbst ausprobierst, könnten es auch schon wieder andere Namen und eine andere Anzahl sein. Das ist einer der Vorteile von APIs - im Gegensatz zu herunterladbaren Datensätzen werden sie im Allgemeinen in Echtzeit oder nahezu in Echtzeit aktualisiert, so dass sie eine großartige Möglichkeit darstellen, Zugang zu sehr aktuellen Daten zu erhalten.


In diesem Beispiel haben wir einen sehr unkomplizierten API-Workflow durchlaufen. Die meisten APIs erfordern, dass Sie demselben allgemeinen Muster folgen, aber dabei können sie durchaus komplexer sein.

In unserem Beispiel war es ausreichen nur die URL anzugeben. Aber einige APIs verlangen durchaus mehr Informationen vom Benutzer. Im letzten Teil dieser Einführung gehen wir darauf ein, wie du der API mit deiner Anfrage zusätzliche Informationen zur Verfügung stellen kannst.

### APIs und Abfrageparameter

Was wäre, wenn wir wissen wollten, wann die ISS einen bestimmten Ort auf der Erde überfliegen würde? Die ISS Pass Times API von Open Notify verlangt von uns, dass wir zusätzliche Parameter angeben, bevor sie die gewünschten Daten zurückgeben kann.

Wir müssen den Längen- und Breitengrad des Ortes angeben, nach dem wir im Rahmen unserer `GET()` Anfrage fragen. Sobald ein Längen- und Breitengrad angegeben ist, werden sie als Abfrageparameter mit der ursprünglichen URL kombiniert.

Lass uns die API verwenden, um herauszufinden, wann die ISS Garching (auf 48.24896 Breiten- und  11.65101 Längengrad) passieren wird:


```r
jdata <-  GET("http://api.open-notify.org/iss-pass.json",
    query = list(lat = 48.24896, lon = 11.65101))
```


Man muss in der Dokumentation für die API, mit man arbeiten will, nachsehen, ob es erforderliche Abfrageparameter gibt. Für die überwiegende Mehrheit der APIs, auf die du möglicherweise zugreifen möchtest, gibt es eine Dokumentation, die du lesen kannst (und lesen solltest), um ein klares Verständnis dafür zu erhalten, welche Parameter deine Anfrage erfordert. 

Wie auch immer, jetzt, da wir unsere Anfrage einschließlich der Standortparameter gestellt haben, können wir die Antwort mit den gleichen Funktionen überprüfen, die wir zuvor verwendet haben. Lass uns die Daten aus der Antwort extrahieren:



```r
data <- fromJSON(rawToChar(jdata$content))
data$response
#>   duration   risetime
#> 1      651 1607012831
#> 2      647 1607018643
#> 3      514 1607024481
#> 4      446 1607079082
#> 5      638 1607084747
```



Diese API gibt uns Zeiten in Form von [Unixzeit](https://de.wikipedia.org/wiki/Unixzeit) zurück. Unixzeit ist die Zeitspanne, die seit dem 1. Januar 1970 vergangen ist. Mithilfe der Funktion `as_datetime()` aus dem [lubridate] Paket können wir die Unixzeit aber leicht umrechnen


```r
lubridate::as_datetime(data$response$risetime)
#> [1] "2020-12-03 16:27:11 UTC" "2020-12-03 18:04:03 UTC"
#> [3] "2020-12-03 19:41:21 UTC" "2020-12-04 10:51:22 UTC"
#> [5] "2020-12-04 12:25:47 UTC"
```


Wir haben hier wirklich nur die Basics in Bezug auf APIs eingeführt. Aber hoffentlich hat dir diese Einführung trotzdem das Vertrauen gegeben, sich mit einigen komplexeren und leistungsfähigeren APIs auseinanderzusetzen, und trägt dadurch dazu bei, eine ganz neue Welt von Daten zu erschließen, die du erforschen kannst!



## Weiteres Material

Hier sein noch auf das Kapitel [Data import](http://r4ds.had.co.nz/data-import.html) im Buch [R for Data Science] von Hadley Wickham und Garrett Grolemund [-@wickham2016] verwiesen für weitere Information zum Daten Import.






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

