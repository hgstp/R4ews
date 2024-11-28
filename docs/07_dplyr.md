# Mehr zu `dplyr` {#dplyr-single}



## Wo stehen wir?

In Kapitel \@ref(dplyr-intro)  haben wir bereits zwei sehr wichtige Verben und den Pipe Operator kennengelernt  und verwendet:

* `filter()` zur Auswahl spezieller Zeilen eines Datensatzes
* `select()` zur Auswahl spezieller Variablen eines Datensatzes
* der Pipe-Operator `|>` bzw. `%>%` überführt das Objekt auf der linken Seite des Operators in das  erste Funktionsargument der Funktion auf der rechten Seite des Aufrufs
  
Wir haben zudem auch noch die Rolle von `dplyr` innerhalb des tidyverse besprochen:


:::: {.content-box-gray}
[dplyr] ist ein Kernpaket der [tidyverse] Kollektion von Paketen. Da wir die anderen oft beiläufig benutzen, werden wir stets dplyr und die anderen über `library(tidyverse)` laden.
:::


Wir starten wieder mit dem Laden von `dplyr` (über `tidyverse`)


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

und `gapminder`


``` r
library(gapminder)
```




## Mit `mutate()` neue Variablen erstellen

Wir starten mit dem Anlegen einer Kopie von `gapminder`, die wir dann nach unseren Vorstellungen verändern (es wäre aber auch nichts passiert, wenn wir alles mit `gapminder` durchführen würden; mit dem Befehl `gapminder::gapminder` können wir immer auf die Originalversion zurückgreifen).


``` r
my_gap <- gapminder
```

Unser __Ziel__ ist es, dass GDP pro Land anzugeben. Das sollte machbar sein, da schließlich das Pro-Kopf-GDP wie auch die Bevölkerungszahl im Datensatz enthalten sind. Multiplizieren beider Variablen liefert uns das gewünschte Ergebnis.

`mutate()` ist eine Funktion, die neue Variablen definiert und in ein tibble einfügt. Dabei können wir auf bestehende Variablen einfach über ihren Namen zugreifen.


``` r
my_gap |> 
  mutate(gdp = pop * gdpPercap)
## # A tibble: 1,704 × 7
##    country     continent  year lifeExp      pop gdpPercap          gdp
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.  6567086330.
##  2 Afghanistan Asia       1957    30.3  9240934      821.  7585448670.
##  3 Afghanistan Asia       1962    32.0 10267083      853.  8758855797.
##  4 Afghanistan Asia       1967    34.0 11537966      836.  9648014150.
##  5 Afghanistan Asia       1972    36.1 13079460      740.  9678553274.
##  6 Afghanistan Asia       1977    38.4 14880372      786. 11697659231.
##  7 Afghanistan Asia       1982    39.9 12881816      978. 12598563401.
##  8 Afghanistan Asia       1987    40.8 13867957      852. 11820990309.
##  9 Afghanistan Asia       1992    41.7 16317921      649. 10595901589.
## 10 Afghanistan Asia       1997    41.8 22227415      635. 14121995875.
## # ℹ 1,694 more rows
```

Hmmmm ... diese GDP-Zahlen sind ziemlich groß und abstrakt. In dem Zusammenhang, bedenke den Ratschlag von [Randall Munroe](https://fivethirtyeight.com/features/xkcd-randall-munroe-qanda-what-if/):

>One thing that bothers me is large numbers presented without context... "If I added a zero to this number, would the sentence containing it mean something different to me?" If the answer is "no", maybe the number has no business being in the sentence in the first place.

Vielleicht wäre es doch sinnvoller, wenn wir beim Pro-Kopf-GDP bleiben. Aber was wäre, wenn wir das Pro-Kopf-GDP angeben würden  _in Relation zu irgendeinem Vergleichsland_. Wir könnten alles in Bezug auf die entsprechenden Daten aus Deutschland angeben. 

Dazu müssen wir eine neue Variable erstellen, die aus den `gdpPercap` Werten , geteilt durch die deutschen `gdpPercap` Werte, besteht. Beim Erstellen der Variable müssen wir aber darauf achten, dass wir immer zwei Zahlen teilen, die sich auf dasselbe Jahr beziehen.

__Wie können wir das schaffen?__

1. Beobachtungen für Deutschland in einem Objekt `ger_gap` speichern
1. Erstellen einer neue _temporären_ Variable `tmp` in `my_gap`, die definiert wird durch:
    i) die `gdpPercap`-Variable aus `ger_gap` aufrufen
    i) mit `rep()` die `gdpPercap` Wert aus `ger_gap` einmal pro Land im `my_gap` reproduzieren, damit ein Vektor entsteht, der die gleiche Anzahl an Beobachtungen wie `my_gap` hat
1. Dividieren der `gdpPercap` Werte durch die deutschen Zahlen
1. Löschen der  temporären Variable `tmp` in `my_gap`


``` r
ger_gap <- my_gap |> 
  filter(country == "Germany")

my_gap <- my_gap |> 
  mutate(tmp = rep(ger_gap$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)
```

Beachte, dass `mutate()` neue Variablen sequentiell erstellt, so dass man auf frühere Variablen (wie `tmp`) verweisen kann um spätere Variablen (wie `gdpPercapRel`) zu definieren. Nachdem eine Variable nicht mehr benötigt wird, kann man sie einfach auf `NULL` setzen.

Bleibt die Frage ob das alles so richtig war. Um diese Frage zu beantworten, können wir uns aber einfach mal die Werte von `gdpPercapRel` für Deutschland anschauen. Die sollten besser alle 1 sein!


``` r
my_gap |> 
  filter(country == "Germany") |> 
  select(country, year, gdpPercapRel)
## # A tibble: 12 × 3
##    country  year gdpPercapRel
##    <fct>   <int>        <dbl>
##  1 Germany  1952            1
##  2 Germany  1957            1
##  3 Germany  1962            1
##  4 Germany  1967            1
##  5 Germany  1972            1
##  6 Germany  1977            1
##  7 Germany  1982            1
##  8 Germany  1987            1
##  9 Germany  1992            1
## 10 Germany  1997            1
## 11 Germany  2002            1
## 12 Germany  2007            1
```

Ich glaube, wir können annehmen, dass Deutschland ein Land mit einem "hohen GDP" pro Kopf ist. Daher sollte die Verteilung von `gdpPercapRel` auf Werten unter 1 konzentriert sein, möglicherweise sogar weit darunter. Aber besser mal nachschauen ob dem so ist:


``` r
summary(my_gap$gdpPercapRel)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.01    0.07    0.19    0.37    0.51   15.17
```

Die Zahlen des relativen Pro-Kopf-GDP liegen deutlich unter 1. Wir sehen, dass die meisten Länder, die in diesem Datensatz erfasst werden, über den gesamten Zeitraum im Vergleich zu Deutschland ein wesentlich niedrigeres Pro-Kopf-GDP aufweisen.

:::: {.content-box-yellow}
__Tipp:__ Vertraut niemandem - einschließlich (besonders?) euch selbst. Versucht immer, einen Weg zu finden, um zu überprüfen, ob ihr das gemacht habt, was ihr tun wolltet. Seid aber nicht schockiert, wenn ihr manchmal feststellen müsst, dass dem nicht so ist. 😉
::::

##  Mit `arrange()` die Zeilenreihenfolge ändern

`arrange()` ordnet die Zeilen in einem data frame neu an. Stellen wir uns mal vor, dass wir die Daten nach Jahr und Land und nicht nach Land und Jahr ordnen wollen.


``` r
my_gap |> 
  arrange(year, country)
## # A tibble: 1,704 × 7
##    country     continent  year lifeExp      pop gdpPercap gdpPercapRel
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.       0.109 
##  2 Albania     Europe     1952    55.2  1282697     1601.       0.224 
##  3 Algeria     Africa     1952    43.1  9279525     2449.       0.343 
##  4 Angola      Africa     1952    30.0  4232095     3521.       0.493 
##  5 Argentina   Americas   1952    62.5 17876956     5911.       0.827 
##  6 Australia   Oceania    1952    69.1  8691212    10040.       1.41  
##  7 Austria     Europe     1952    66.8  6927772     6137.       0.859 
##  8 Bahrain     Asia       1952    50.9   120447     9867.       1.38  
##  9 Bangladesh  Asia       1952    37.5 46886859      684.       0.0958
## 10 Belgium     Europe     1952    68    8730405     8343.       1.17  
## # ℹ 1,694 more rows
```

Oder vielleicht interessieren euch nur die Daten aus 2007, angeordnet entsprechend der Lebenserwartung.


``` r
my_gap |> 
  filter(year == 2007) |> 
  arrange(lifeExp)
## # A tibble: 142 × 7
##    country                 continent  year lifeExp    pop gdpPercap gdpPercapRel
##    <fct>                   <fct>     <int>   <dbl>  <int>     <dbl>        <dbl>
##  1 Swaziland               Africa     2007    39.6 1.13e6     4513.       0.140 
##  2 Mozambique              Africa     2007    42.1 2.00e7      824.       0.0256
##  3 Zambia                  Africa     2007    42.4 1.17e7     1271.       0.0395
##  4 Sierra Leone            Africa     2007    42.6 6.14e6      863.       0.0268
##  5 Lesotho                 Africa     2007    42.6 2.01e6     1569.       0.0488
##  6 Angola                  Africa     2007    42.7 1.24e7     4797.       0.149 
##  7 Zimbabwe                Africa     2007    43.5 1.23e7      470.       0.0146
##  8 Afghanistan             Asia       2007    43.8 3.19e7      975.       0.0303
##  9 Central African Republ… Africa     2007    44.7 4.37e6      706.       0.0219
## 10 Liberia                 Africa     2007    45.7 3.19e6      415.       0.0129
## # ℹ 132 more rows
```

Das war nun aber nicht das Ergebnis, welches ihr sehen wolltet. Ihr wolltet eigentlich nach absteigender Lebenserwartung sortieren. Dazu müsst ihr  `desc()` verwenden.


``` r
my_gap |> 
  filter(year == 2007) |> 
  arrange(desc(lifeExp))
## # A tibble: 142 × 7
##    country          continent  year lifeExp       pop gdpPercap gdpPercapRel
##    <fct>            <fct>     <int>   <dbl>     <int>     <dbl>        <dbl>
##  1 Japan            Asia       2007    82.6 127467972    31656.        0.984
##  2 Hong Kong, China Asia       2007    82.2   6980412    39725.        1.23 
##  3 Iceland          Europe     2007    81.8    301931    36181.        1.12 
##  4 Switzerland      Europe     2007    81.7   7554661    37506.        1.17 
##  5 Australia        Oceania    2007    81.2  20434176    34435.        1.07 
##  6 Spain            Europe     2007    80.9  40448191    28821.        0.896
##  7 Sweden           Europe     2007    80.9   9031088    33860.        1.05 
##  8 Israel           Asia       2007    80.7   6426679    25523.        0.793
##  9 France           Europe     2007    80.7  61083916    30470.        0.947
## 10 Canada           Americas   2007    80.7  33390141    36319.        1.13 
## # ℹ 132 more rows
```


:::: {.content-box-yellow}
__Tipp:__ Verlasst euch  NIEMALS darauf, dass Zeilen oder Variablen in einer bestimmten Reihenfolge stehen. Aber manchmal will man Tabellen anderen präsentieren und dabei macht es durchaus Sinn die  Zeilenreihenfolge je nach Fragestellung anzupassen.
::::

## Mit `rename()` "schöne" Namen vergeben

Ein paar der Namen in `gapminder` sind nicht besonders hübsch, wie z.B. `lifeExp`. life expectancy wären ja schließlich zwei Worte und daher finde ich (persönliche Meinung) es schöner, dies auch im Variablennamen zu sehen


``` r
my_gap |> 
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)
## # A tibble: 1,704 × 7
##    country     continent  year life_exp      pop gdp_percap gdp_percap_rel
##    <fct>       <fct>     <int>    <dbl>    <int>      <dbl>          <dbl>
##  1 Afghanistan Asia       1952     28.8  8425333       779.         0.109 
##  2 Afghanistan Asia       1957     30.3  9240934       821.         0.0806
##  3 Afghanistan Asia       1962     32.0 10267083       853.         0.0661
##  4 Afghanistan Asia       1967     34.0 11537966       836.         0.0567
##  5 Afghanistan Asia       1972     36.1 13079460       740.         0.0411
##  6 Afghanistan Asia       1977     38.4 14880372       786.         0.0383
##  7 Afghanistan Asia       1982     39.9 12881816       978.         0.0444
##  8 Afghanistan Asia       1987     40.8 13867957       852.         0.0346
##  9 Afghanistan Asia       1992     41.7 16317921       649.         0.0245
## 10 Afghanistan Asia       1997     41.8 22227415       635.         0.0229
## # ℹ 1,694 more rows
```


Die Änderungen haben wir jetzt aber nicht abgespeichert (auch wenn sie schön waren), da wir den nachfolgenden Code auch weiterhin ausführen möchten, ohne die Variablennamen entsprechend zu ändern.


:::: {.content-box-grey}

__Bemerkung:__ Mit `select()` könnten wir bei der Auswahl von Variablen auch deren Namen ändern 

``` r
my_gap |> 
  filter(country == "Burundi", year > 1996) |> 
  select(yr = year, lifeExp, gdpPercap) |> 
  select(gdpPercap, everything())
## # A tibble: 3 × 3
##   gdpPercap    yr lifeExp
##       <dbl> <int>   <dbl>
## 1      463.  1997    45.3
## 2      446.  2002    47.4
## 3      430.  2007    49.6
```

`everything()` wählt alle übrigen (außer `gdpPercap`) Variablen. Da `gdpPercap` an erster Stelle gewählt wurde, wird die Variable auch zur ersten Spalte. 

::::

## `summarise()` in Kombination mit `group_by()` 

Nehmen wir mal an, dass uns die Antwort auf die Frage 

:::: {.content-box-green}

"In welchem Land ist die Lebenserwartung innerhalb von 5 Jahren am stärksten gesunken?" 
::::


interessiert.


`dplyr` bietet uns mächtige Hilfsmittel zur Beantwortung der Frage:

* `group_by()` fügt dem Datensatz eine zusätzliche Struktur hinzu -- Gruppierungsinformationen -- die die Grundlage für Berechnungen innerhalb der Gruppen bilden.

* `summarise()` nimmt einen Datensatz mit $n$-Beobachtungen, berechnet die angeforderten Zusammenfassungen und gibt einen Datensatz mit einer Beobachtung (falls nur eine Zusammenfassung angefordert wurde) zurück.


* `mutate()` und `summarise()` berücksichtigen Gruppen.


Kombiniert mit den Verben, die wir bereits kennen, könnt ihr mit diesen neuen Werkzeugen eine extrem vielfältige Reihe von Problemen relativ einfach lösen.

### Dinge aufzählen

Beginnen wir mit dem einfachen Zählen.  Wie viele Beobachtungen haben wir pro Kontinent?


``` r
my_gap |> 
  group_by(continent) |> 
  summarise(n = n())
## # A tibble: 5 × 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
```

Lasst uns hier kurz innehalten und über das tidyverse nachdenken. Ihr könntet  die gleichen absoluten Häufigkeiten natürlich auch mit `table()` berechnen.


``` r
table(gapminder$continent)
## 
##   Africa Americas     Asia   Europe  Oceania 
##      624      300      396      360       24
str(table(gapminder$continent))
##  'table' int [1:5(1d)] 624 300 396 360 24
##  - attr(*, "dimnames")=List of 1
##   ..$ : chr [1:5] "Africa" "Americas" "Asia" "Europe" ...
```

Das Ergebnis ist ein Objekt der Klasse `table`. Dies macht nachfolgende Berechnungen leider etwas kniffliger, als es euch lieb ist. Zum Beispiel ist es  schade, dass die Namen der Kontinente nur als *Attribute* und nicht als richtiger Faktor zusammen mit den berechneten Werten zurückgegeben werden.     
Dies ist ein Beispiel dafür, wie das tidyverse Übergänge glättet, bei denen die Ausgabe von Schritt `i` die Eingabe von Schritt `i + 1` werden soll.

Die `tally()` Funktion ist eine Komfortfunktion, die weiß, wie man Zeilen zählt und dabei Gruppen berücksichtigt.


``` r
my_gap |> 
  group_by(continent) |> 
  tally()
## # A tibble: 5 × 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
```

Die Funktion `count()` bietet noch mehr Komfort. Sie kann sowohl gruppieren als auch zählen.


``` r
my_gap |> 
  count(continent)
## # A tibble: 5 × 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
```

Was wäre, wenn uns nicht nur die Anzahl an Beobachtungen pro Kontinent interessiert, sondern auch die Anzahl an unterschiedlichen Ländern pro Kontinent. Dazu bestimmen wir einfach mehrere Zusammenfassungen innerhalb von `summarise()`. Dabei verwenden wir die Funktion `n_distinct()`, um die Anzahl der einzelnen Länder innerhalb jedes Kontinents zu zählen.


``` r
my_gap |> 
  group_by(continent) |> 
  summarise(n = n(),
            n_countries = n_distinct(country))
## # A tibble: 5 × 3
##   continent     n n_countries
##   <fct>     <int>       <int>
## 1 Africa      624          52
## 2 Americas    300          25
## 3 Asia        396          33
## 4 Europe      360          30
## 5 Oceania      24           2
```

### Deskriptive Statistiken mit `summarise()`


In Kombination mit `summarise()` können wir eine Vielzahl an verschiedenen Funktionen verwenden. Einige davon berechnen klassische __deskriptive Statistiken__:

In allen betrachteten Fällen seien $x_1,\dots,x_n$ numerische Beobachtungen.


+  `mean()` berechnet das arithmetische Mittel der Beobachtungen
$$\overline x_n = \frac{1}{n} \sum_{i=1}^n x_i\,.$$

+ `median()` berechnet den Median
$$x_{0.5} = \begin{cases}
  x_{\left(\frac{n+1}{2}\right)}, &  n\ \text{ungerade},\\
  \frac{1}{2}\left(x_{\left(\frac{n}{2}\right)} + x_{\left(\frac{n}{2}+1\right)}\right), & n\ \text{gerade}
  \end{cases}\,.$$

+  `var()` berechnet die empirische Varianz
$$s_n^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \overline x_n)^2\,.$$

+ `sd()` berechnet die empirische Standardabweichung
$$s_n = \sqrt{s_n^2}\,.$$
+ `IQR()` berechnet den Interquartilsabstand
$$IQR = x_{0.75} - x_{0.25}\,,$$
wobei $x_{0.25}$ und $x_{0.75}$ das empirische 0.25 bzw. 0.75 Quantil bezeichnen. 

+ `min()` berechnet das Minimum
$$x_{(1)} = \min(x_1,\dots,x_n)\,.$$

+ und `max()` berechnet demnach das Maximum
$$x_{(n)} = \max(x_1,\dots,x_n)\,.$$


Auch wenn dies statistisch gesehen unklug sein mag, lasst uns die durchschnittliche Lebenserwartung pro Kontinent berechnen.


``` r
my_gap |> 
  group_by(continent) |> 
  summarise(avg_lifeExp = mean(lifeExp))
## # A tibble: 5 × 2
##   continent avg_lifeExp
##   <fct>           <dbl>
## 1 Africa           48.9
## 2 Americas         64.7
## 3 Asia             60.1
## 4 Europe           71.9
## 5 Oceania          74.3
```


`summarise_at()` wendet die gleiche(n) Zusammenfassungs-Funktion(en) auf mehrere Variablen an. Lasst uns die durchschnittliche  Lebenserwartung sowie den Median und das Pro-Kopf-GDP nach Kontinenten pro Jahr berechnen... aber nur für 1952 und 2007.


``` r
my_gap |> 
  filter(year %in% c(1952, 2007)) |> 
  group_by(continent, year) |> 
  summarise_at(vars(lifeExp, gdpPercap), list(mean, median))
## # A tibble: 10 × 6
## # Groups:   continent [5]
##    continent  year lifeExp_fn1 gdpPercap_fn1 lifeExp_fn2 gdpPercap_fn2
##    <fct>     <int>       <dbl>         <dbl>       <dbl>         <dbl>
##  1 Africa     1952        39.1         1253.        38.8          987.
##  2 Africa     2007        54.8         3089.        52.9         1452.
##  3 Americas   1952        53.3         4079.        54.7         3048.
##  4 Americas   2007        73.6        11003.        72.9         8948.
##  5 Asia       1952        46.3         5195.        44.9         1207.
##  6 Asia       2007        70.7        12473.        72.4         4471.
##  7 Europe     1952        64.4         5661.        65.9         5142.
##  8 Europe     2007        77.6        25054.        78.6        28054.
##  9 Oceania    1952        69.3        10298.        69.3        10298.
## 10 Oceania    2007        80.7        29810.        80.7        29810.
```

Im nächsten Schritt konzentrieren wir uns nur auf Asien. Wie hoch ist die minimale und maximale Lebenserwartung pro Jahr?


``` r
my_gap |>
  filter(continent == "Asia")  |> 
  group_by(year) |>
  summarise(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))
## # A tibble: 12 × 3
##     year min_lifeExp max_lifeExp
##    <int>       <dbl>       <dbl>
##  1  1952        28.8        65.4
##  2  1957        30.3        67.8
##  3  1962        32.0        69.4
##  4  1967        34.0        71.4
##  5  1972        36.1        73.4
##  6  1977        31.2        75.4
##  7  1982        39.9        77.1
##  8  1987        40.8        78.7
##  9  1992        41.7        79.4
## 10  1997        41.8        80.7
## 11  2002        42.1        82  
## 12  2007        43.8        82.6
```

Natürlich wäre es viel interessanter zu sehen, *welches* Land bzw. welche Länder diese extremen Beobachtungen beigetragen haben. Kommt das Minimum (Maximum) immer aus dem gleichen Land? Wir gehen dem in Kürze mithilfe von Window Funktionen nach.

## Gruppierte Veränderungen

Manchmal möchte man die $n$-Zeilen für jede Gruppe nicht zu einer Zeile zusammenfassen. Stattdessen möchte man die Gruppen behalten, aber innerhalb dieser Gruppen rechnen.

### Berechnungen innerhalb der Gruppen

Lasst uns eine neue Variable definieren, die die gewonnenen (verlorenen) Lebenserwartungsjahre im Vergleich zu 1952 für jedes einzelne Land angibt. Wir gruppieren nach Ländern und verwenden `mutate()`, um eine neue Variable zu erstellen. Die Funktion `first()` extrahiert dabei den ersten Wert aus einem Vektor. Beachtet, dass `first()` mit dem Vektor der Lebenserwartungen *in jeder Ländergruppe* arbeitet.


``` r
my_gap |> 
  group_by(country) |> 
  select(country, year, lifeExp) |> 
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) |> 
  filter(year < 1963)
## # A tibble: 426 × 4
## # Groups:   country [142]
##    country      year lifeExp lifeExp_gain
##    <fct>       <int>   <dbl>        <dbl>
##  1 Afghanistan  1952    28.8         0   
##  2 Afghanistan  1957    30.3         1.53
##  3 Afghanistan  1962    32.0         3.20
##  4 Albania      1952    55.2         0   
##  5 Albania      1957    59.3         4.05
##  6 Albania      1962    64.8         9.59
##  7 Algeria      1952    43.1         0   
##  8 Algeria      1957    45.7         2.61
##  9 Algeria      1962    48.3         5.23
## 10 Angola       1952    30.0         0   
## # ℹ 416 more rows
```

Innerhalb eines Landes nehmen wir die Differenz zwischen der Lebenserwartung im Jahr $i$ und der Lebenserwartung im Jahr 1952. Daher sehen wir für 1952 immer Nullen und für die meisten Länder eine Folge von positiven und steigenden Zahlen.

### Window Funktionen {#window-functions}

Window Funktionen nehmen eine Eingabe der Länge $n$ und berechnen eine Ausgabe derselben Länge. Diese Ausgabewerte hängen dabei von allen Eingabewerten ab. So ist z.B. `rank()` eine Window Funktion, aber `log()` ist es nicht. 


Betrachten wir noch einmal die schlechtesten und besten Lebenserwartungen in Asien im Laufe der Zeit, behalten aber Informationen darüber bei, *welches* Land diese Extremwerte beisteuert.


``` r
my_gap |>
  filter(continent == "Asia") |>
  select(year, country, lifeExp) |>
  group_by(year) |>
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) |> 
  arrange(year) |>
  print(n = Inf)  # erzwingt eine Ausgabe aller Zeilen
## # A tibble: 24 × 3
## # Groups:   year [12]
##     year country     lifeExp
##    <int> <fct>         <dbl>
##  1  1952 Afghanistan    28.8
##  2  1952 Israel         65.4
##  3  1957 Afghanistan    30.3
##  4  1957 Israel         67.8
##  5  1962 Afghanistan    32.0
##  6  1962 Israel         69.4
##  7  1967 Afghanistan    34.0
##  8  1967 Japan          71.4
##  9  1972 Afghanistan    36.1
## 10  1972 Japan          73.4
## 11  1977 Cambodia       31.2
## 12  1977 Japan          75.4
## 13  1982 Afghanistan    39.9
## 14  1982 Japan          77.1
## 15  1987 Afghanistan    40.8
## 16  1987 Japan          78.7
## 17  1992 Afghanistan    41.7
## 18  1992 Japan          79.4
## 19  1997 Afghanistan    41.8
## 20  1997 Japan          80.7
## 21  2002 Afghanistan    42.1
## 22  2002 Japan          82  
## 23  2007 Afghanistan    43.8
## 24  2007 Japan          82.6
```

Wir sehen, dass (min = Afghanistan, max = Japan) das häufigste Ergebnis ist, aber Kambodscha und Israel tauchen auch jeweils mindestens einmal als min bzw. max auf. 


> Aber wäre es nicht schön eine Zeile pro Jahr zu haben?

Zuerst sollten wir uns aber vielleicht nochmal fragen wie das eigentlich funktioniert hat? Dazu schauen wir uns die Beobachtungen aus Asien mal direkt an.


``` r
(asia <- my_gap |>
  filter(continent == "Asia") |>
  select(year, country, lifeExp) |>
  group_by(year))
## # A tibble: 396 × 3
## # Groups:   year [12]
##     year country     lifeExp
##    <int> <fct>         <dbl>
##  1  1952 Afghanistan    28.8
##  2  1957 Afghanistan    30.3
##  3  1962 Afghanistan    32.0
##  4  1967 Afghanistan    34.0
##  5  1972 Afghanistan    36.1
##  6  1977 Afghanistan    38.4
##  7  1982 Afghanistan    39.9
##  8  1987 Afghanistan    40.8
##  9  1992 Afghanistan    41.7
## 10  1997 Afghanistan    41.8
## # ℹ 386 more rows
```

Jetzt wenden wir die Window Funktion `min_rank()` an. Da `asia` nach Jahren gruppiert ist, operiert `min_rank()` innerhalb von Mini-Datensätzen. Auf die Variable `lifeExp` angewandt, liefert `min_rank()` den Rang der beobachteten Lebenserwartung jedes Landes. 


:::: {.content-box-gray}

__Bemerkung:__ Der `min`-Teil im Funktionsnamen `min_rank()` gibt nur an, wie im Fall von gleichen Beobachtungswerten die Ränge bestimmt werden.


``` r
rank(c(1,3,3,5), ties.method = "min")
## [1] 1 2 2 4
```

Neben dem Minimum gibt es aber auch noch eine Reihe weiterer Alternativen, wie z.B. den Durchschnitt


``` r
rank(c(1,3,3,5))
## [1] 1.0 2.5 2.5 4.0
```

::::



Im nächsten Schritt schauen wir uns die Ränge der Lebenserwartung innerhalb eines Jahres mal explizit für ein paar Länder (Afghanistan, Japan und Thailand) an - sowohl in der (Standard-) aufsteigenden als auch in der absteigenden Reihenfolge.




``` r
asia |>
  mutate(le_rank = min_rank(lifeExp),
         le_desc_rank = min_rank(desc(lifeExp))) |> 
  filter(country %in% c("Afghanistan", "Japan", "Thailand"), year > 1995)
## # A tibble: 9 × 5
## # Groups:   year [3]
##    year country     lifeExp le_rank le_desc_rank
##   <int> <fct>         <dbl>   <int>        <int>
## 1  1997 Afghanistan    41.8       1           33
## 2  2002 Afghanistan    42.1       1           33
## 3  2007 Afghanistan    43.8       1           33
## 4  1997 Japan          80.7      33            1
## 5  2002 Japan          82        33            1
## 6  2007 Japan          82.6      33            1
## 7  1997 Thailand       67.5      12           22
## 8  2002 Thailand       68.6      12           22
## 9  2007 Thailand       70.6      12           22
```

Afghanistan neigt dazu, 1 in der `le_rank`-Variablen zu haben, Japan neigt dazu, 1 in der `le_desc_rank`-Variablen zu haben und andere Länder, wie Thailand, zeigen deutlich  weniger extreme Ränge.

Damit sollte der ursprüngliche `filter()` Befehl


``` r
filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2)
```

auch klar sein.

Diese beiden Sätze von Rängen werden on-the-fly, innerhalb der Jahresgruppe, gebildet, und `filter()` behält alle Zeilen, die einen Rangwert kleiner als 2 haben. Da wir dies für aufsteigende und absteigende Ränge machen, erhalten wir  sowohl die Beobachtungen mit dem minimalen als auch dem maximalen Rang.

Wenn wir nur das Minimum ODER das Maximum gewollt hätten, hätte auch ein alternativer Ansatz mit `slice_min()` bzw. `slice_max()` funktioniert.


``` r
my_gap |>
  filter(continent == "Asia") |>
  select(year, country, lifeExp) |>
  arrange(year) |>
  group_by(year) |>
# slice_min(lifeExp, n = 1)        ## für das Minimum
  slice_max(lifeExp, n = 1) ## bzw. das Maximum
## # A tibble: 12 × 3
## # Groups:   year [12]
##     year country lifeExp
##    <int> <fct>     <dbl>
##  1  1952 Israel     65.4
##  2  1957 Israel     67.8
##  3  1962 Israel     69.4
##  4  1967 Japan      71.4
##  5  1972 Japan      73.4
##  6  1977 Japan      75.4
##  7  1982 Japan      77.1
##  8  1987 Japan      78.7
##  9  1992 Japan      79.4
## 10  1997 Japan      80.7
## 11  2002 Japan      82  
## 12  2007 Japan      82.6
```

## Großes Finale

Beantworten wir also die Frage: 

:::: {.content-box-green}

"In welchem Land ist die Lebenserwartung innerhalb von 5 Jahren am stärksten gesunken?" 
::::


Die Beobachtungsfrequenz im Datensatz ist fünf Jahre, d.h. wir haben Daten für 1952, 1957 usw. Dies bedeutet also, dass die Veränderungen der Lebenserwartung zwischen benachbarten Zeitpunkten betrachtet werden müssen. Dazu verwenden wir die `lag()` Funktion. Diese veschiebt die Einträge des Inputvektors um ein Lag `k`.

Wir können aber noch mehr erreichen. Lasst uns die Frage pro  Kontinenten beantworten.


``` r
my_gap |>
  group_by(continent, country) |>
  # für jedes Land werden die Unterschiede berechnet
  mutate(delta = lifeExp - lag(lifeExp, n = 1)) |> 
  ## für jedes Land wird nur der kleinste Wert behalten und alle Werten mit fehlendem Wert für delta werden nicht berücksichtigt
  summarise(worst_delta = min(delta, na.rm = TRUE)) |> 
  ## nun wird noch pro Kontinent, die Zeile mit dem kleinsten Wert ausgegeben
  slice_min(worst_delta, n = 1) |> 
  arrange(worst_delta)
## `summarise()` has grouped output by 'continent'. You can override using the
## `.groups` argument.
## # A tibble: 5 × 3
## # Groups:   continent [5]
##   continent country     worst_delta
##   <fct>     <fct>             <dbl>
## 1 Africa    Rwanda          -20.4  
## 2 Asia      Cambodia         -9.10 
## 3 Americas  El Salvador      -1.51 
## 4 Europe    Montenegro       -1.46 
## 5 Oceania   Australia         0.170
```

Auch folgendes Code würde dasselbe Ergebnis liefern


``` r
my_gap |>
  group_by(continent, country) |>
  # für jedes Land werden die Unterschiede berechnet
  mutate(delta = lifeExp - lag(lifeExp, n = 1)) |> 
  ## wir entfernen alle Beobachtungen, wo der Wert von delta fehlt
  filter(!is.na(delta)) |> 
  ## für jedes Land wird nur der kleinste Wert behalten
  summarise(worst_delta = min(delta)) |> 
  ## nun wird noch pro Kontinent, die Zeile mit dem kleinsten Wert ausgegeben
  slice_min(worst_delta, n = 1) |> 
  arrange(worst_delta)
## `summarise()` has grouped output by 'continent'. You can override using the
## `.groups` argument.
## # A tibble: 5 × 3
## # Groups:   continent [5]
##   continent country     worst_delta
##   <fct>     <fct>             <dbl>
## 1 Africa    Rwanda          -20.4  
## 2 Asia      Cambodia         -9.10 
## 3 Americas  El Salvador      -1.51 
## 4 Europe    Montenegro       -1.46 
## 5 Oceania   Australia         0.170
```

Wenn wir auch die Information bezüglich des Jahres behalten möchten, können wir eine weitere Variable zum `summarize()` hinzufügen


``` r
my_gap |>
  group_by(continent, country) |>
  # für jedes Land werden die Unterschiede berechnet
  mutate(delta = lifeExp - lag(lifeExp, n = 1)) |> 
  ## wir entfernen alle Beobachtungen, wo der Wert von delta fehlt
  filter(!is.na(delta)) |> 
  ## für jedes Land wird nur der kleinste Wert behalten
  summarise(worst_delta = min(delta), year = year[which.min(delta)]) |> 
  ## nun wird noch pro Kontinent, die Zeile mit dem kleinsten Wert ausgegeben
  slice_min(worst_delta, n = 1) |> 
  arrange(worst_delta)
## `summarise()` has grouped output by 'continent'. You can override using the
## `.groups` argument.
## # A tibble: 5 × 4
## # Groups:   continent [5]
##   continent country     worst_delta  year
##   <fct>     <fct>             <dbl> <int>
## 1 Africa    Rwanda          -20.4    1992
## 2 Asia      Cambodia         -9.10   1977
## 3 Americas  El Salvador      -1.51   1977
## 4 Europe    Montenegro       -1.46   2002
## 5 Oceania   Australia         0.170  1967
```


Denkt ruhig eine Weile über das Ergebnis nach. Hier sieht man in trockenen Statistiken über die durchschnittliche Lebenserwartung, wie Völkermord aussieht.

Um den Code besser zu verstehen, unterteilt ihn, beginnend von oben, in Stücke und überprüft die einzelnen Zwischenergebnisse. So wurde der Code auch geschrieben/entwickelt, mit Fehlern und Verfeinerungen auf dem Weg. 


## Literatur

An dieser Stelle sei noch auf die [dplyr Webseite](https://dplyr.tidyverse.org/) und das Kapitel
[Data transformation][r4ds-transform] in [R for Data Science] [@wickham2016] verwiesen.



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
