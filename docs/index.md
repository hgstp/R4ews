--- 
title: "R4ews MA0009"
author: 
- Stephan Haug
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



Willkommen zur __R Ergänzung zur Einführung in die Wahrscheinlichkeitstheorie und Statistik__. Im Rahmen dieser Ergänzung lernen wir

:::: {.content-box-green}
Daten untersuchen, aufbereiten, visualisieren und analysieren,
::::


Wir wollen all das reproduzierbar, wiederverwendbar und gemeinsam nutzbar machen, und vor allem wollen wir alles mit __R__ machen.

Auf dieser Website geht es um alles, was bei der Datenanalyse 
auftaucht **außer um statistische Modellierung und Schlussfolgerungen**. Dieser Teil der statistischen Analyse erfolgt in der Vorlesung *Einführung in die Wahrscheinlichkeitstheorie und Statistik*. 


Das Design von R4ews wurde durch die Notwendigkeit motiviert, mehr Ausgewogenheit in der angewandten statistischen Ausbildung zu schaffen. Datenanalysten verbringen viel Zeit mit der Projekt-Organisation, der Datenbereinigung und -aufbereitung sowie der Kommunikation. Diese Tätigkeiten können einen tiefgreifenden Einfluss auf die Qualität und Glaubwürdigkeit einer Analyse haben. Dennoch werden diese Fähigkeiten selten vermittelt, obwohl sie so wichtig und notwendig sind. R4ews versucht diese Lücke etwas zu verkleinern.


::: {content-box-red}
Das Material wird kontinuierlich über das Semester hinweg ergänzt/erweitert/verbessert.
:::


**Letzte Änderung:**


```r
> date()
## [1] "Sun Oct 17 23:12:57 2021"
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
##  version  R version 4.0.3 (2020-10-10)
##  os       macOS Big Sur 10.16         
##  system   x86_64, darwin17.0          
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  ctype    en_US.UTF-8                 
##  tz       Europe/Berlin               
##  date     2021-10-17
```

erstellt

<!-- , wobei die folgenden Pakete verwendet -->




<!-- werden. -->

## Lizenz {-}

Diese Arbeit ist lizenziert unter [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

<center>
<i class="fab fa-creative-commons fa-2x"></i><i class="fab fa-creative-commons-by fa-2x"></i><i class="fab fa-creative-commons-sa fa-2x"></i>
</center>



