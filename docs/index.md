--- 
title: "R4ews MA0009"
author: Stephan Haug
knit: "bookdown::render_book"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "R4ews: R Ergänzung zum Modul MA009."
always_allow_html: true
---

# R4ews {-}



Willkommen zu __R für EWS__ (Einführung in die Wahrscheinlichkeitstheorie und Statistik). Im Rahmen dieser Veranstaltung lernen wir erste Schritte, wie wir

:::: {.content-box-orange}
Daten aufbereiten, visualisieren und analysieren. 🚀
::::


All das wollen wir reproduzierbar und auch wiedervendbar machen. Und vor allem, wollen wir alles mit [__R__](www.r-project.org) machen.

Auf dieser Website geht es um verschiedene Aspekte der __Datenanalyse__. 
Eine Einführung in die inferentielle Statistik erfolgt im Rahmen der Vorlesung *Einführung in die Wahrscheinlichkeitstheorie und Statistik*. Aber auch hier werden wir ein paar der dort vorgestellten Themen aufgreifen und mithilfe von R anwenden, illustrieren, ...


Auf jeden Fall ist aber das Ziel von R4ews einen Fokus auf die __angewandte__ statistische Ausbildung zu setzen. Datenanalysten verbringen viel Zeit mit der Projekt-Organisation, der Datenbereinigung und -aufbereitung sowie der Kommunikation. Diese Tätigkeiten können einen tiefgreifenden Einfluss auf die Qualität und Glaubwürdigkeit einer Analyse haben. Dennoch werden diese Fähigkeiten selten vermittelt, obwohl sie so wichtig und notwendig sind. R4ews versucht diese Lücke etwas zu verkleinern.


::: {.content-box-red}
Das Material wird kontinuierlich über das Semester hinweg ergänzt/erweitert/verbessert.
:::


**Letzte Änderung:**


``` r
date()
## [1] "Thu Oct 17 16:37:27 2024"
```



## Beteiligte Personen {-}


## Kolophon {-}

Dieses Buch wurde in [bookdown](http://bookdown.org/) innerhalb von [RStudio](http://www.rstudio.com/ide/) geschrieben. 

Teile des Buches basieren auf [stat545.com](https://stat545.com). Alle Änderungen wurden gemäß der [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/) durchgeführt. 

Wir bedanken uns bei den Autor\*innen von stat545 für das großartige Material.


Die aktuelle Version dieses Buchs wurde mit 

```
## Finding R package dependencies ... Done!
##  setting  value
##  version  R version 4.4.0 (2024-04-24)
##  os       macOS 15.0.1
##  system   aarch64, darwin20
##  ui       X11
##  language (EN)
##  collate  en_US.UTF-8
##  ctype    en_US.UTF-8
##  tz       Europe/Berlin
##  date     2024-10-17
##  pandoc   3.2 @ /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64/ (via rmarkdown)
```

erstellt

<!-- , wobei die folgenden Pakete verwendet -->




<!-- werden. -->

## Lizenz {-}

Diese Arbeit ist lizenziert unter [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

<center>
<i class="fab fa-creative-commons fa-2x"></i><i class="fab fa-creative-commons-by fa-2x"></i><i class="fab fa-creative-commons-sa fa-2x"></i>
</center>



