--- 
title: "R4ews MA009"
#subtitle: "Data wrangling, exploration, and analysis with R"
author: 
- Stephan Haug
knit: "bookdown::render_book"
site: bookdown::bookdown_site
url: 'https\://stat545.com/'
github-repo: rstudio-education/stat545
#cover-image: assets/stat545-logo.png
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "STAT 545: Data wrangling, exploration, and analysis with R."
favicon: assets/favicon.ico
always_allow_html: true

---

# Welcome to STAT 545 {-}



Wir lernen

* Daten  untersuchen, aufbereiten, zu visualisieren und analysieren,
* all das reproduzierbar, wiederverwendbar und gemeinsam nutzbar zu machen,
* mit R.

Auf dieser Website geht es um alles, was bei der Datenanalyse auftaucht **außer um statistische Modellierung und Schlussfolgerungen**. Dieser Teil der statistischen Analyse erfolgt in der Vorlesung *Einführung in die Wahrscheinlichkeitstheorie und Statistik*. 


Das Design von R4ews wurde durch die Notwendigkeit motiviert, mehr Ausgewogenheit in der angewandten statistischen Ausbildung zu schaffen. Datenanalysten verbringen viel Zeit mit der Projektorganisation, der Datenbereinigung und -aufbereitung sowie der Kommunikation. Diese Tätigkeiten können einen tiefgreifenden Einfluss auf die Qualität und Glaubwürdigkeit einer Analyse haben. Dennoch werden diese Fähigkeiten selten vermittelt, obwohl sie so wichtig und notwendig sind. R4ews zielt darauf ab, diese Lücke zu schließen.


## Beteiligte Personen {-}


## Kolophon {-}

Dieses Buch wurde in [bookdown](http://bookdown.org/) innerhalb von [RStudio](http://www.rstudio.com/ide/) geschrieben. 

Teile des Buches basieren auf [stat545.com](https://stat545.com). Alle Änderungen wurden gemäß der [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/) durchgeführt. 

Wir bedanken uns bei den Autor\*innen von stat545 für das großartige Material.


This version of the book was built with:


```
#> Finding R package dependencies ... Done!
#>  setting  value                       
#>  version  R version 4.0.2 (2020-06-22)
#>  os       macOS Catalina 10.15.7      
#>  system   x86_64, darwin17.0          
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  ctype    en_US.UTF-8                 
#>  tz       Europe/Berlin               
#>  date     2020-10-28
```

Im Buch werden die folgenden Pakete verwendet


<!--html_preserve--><div id="htmlwidget-7be3ae21c6dcabbc8f27" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-7be3ae21c6dcabbc8f27">{"x":{"filter":"top","filterHTML":"<tr>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","data":[["askpass","assertthat","backports","base64enc","BH","blob","bookdown","brew","broom","callr","cellranger","checkmate","cli","clipr","colorspace","commonmark","covr","cpp11","crayon","crosstalk","curl","DBI","dbplyr","desc","devtools","dichromat","digest","dplyr","DT","ellipsis","evaluate","fansi","farver","forcats","fs","gapminder","gender","genderdata","generics","geonames","ggplot2","gh","git2r","glue","gridExtra","gt","gtable","haven","highr","hms","htmltools","htmlwidgets","httr","ini","isoband","jsonlite","knitr","labeling","later","lattice","lazyeval","lifecycle","lubridate","magrittr","markdown","MASS","Matrix","memoise","mgcv","mime","modelr","munsell","nlme","openssl","pillar","pkgbuild","pkgconfig","pkgload","praise","prettyunits","processx","progress","promises","ps","purrr","R6","rcmdcheck","RColorBrewer","Rcpp","readr","readxl","rebird","rematch","rematch2","remotes","reprex","rex","rlang","rmarkdown","roxygen2","rplos","rprojroot","rstudioapi","rversions","rvest","sass","scales","selectr","sessioninfo","stringi","stringr","sys","testthat","tibble","tidyr","tidyselect","tidyverse","tinytex","usethis","utf8","vctrs","viridis","viridisLite","whisker","withr","xfun","xml2","xopen","yaml"],[null,"0.2.1","1.1.10",null,null,"1.2.1","0.20",null,"0.7.1","3.4.4","1.1.0",null,"2.0.2",null,"1.4-1",null,null,null,"1.3.4",null,null,"1.1.0","1.4.4","1.2.0","2.3.2",null,"0.6.25","1.0.2","0.15","0.3.1","0.14","0.4.1",null,"0.5.0","1.5.0",null,null,null,"0.0.2",null,"3.3.2",null,null,"1.4.2",null,null,"0.3.0","2.3.1",null,"0.5.3","0.5.0","1.5.2","1.4.2",null,null,"1.7.1","1.30",null,null,null,null,"0.2.0","1.7.9","1.5",null,null,null,"1.1.0",null,null,"0.1.8","0.5.0",null,null,"1.4.6","1.1.0","2.0.3","1.1.0",null,"1.1.1","3.4.4",null,null,"1.3.4","0.3.4","2.4.1",null,null,"1.0.5","1.3.1","1.3.1",null,null,null,"2.2.0","0.3.0",null,"0.4.7","2.4",null,null,"1.3-2","0.11",null,"0.3.6",null,"1.1.1",null,"1.1.1","1.5.3","1.4.0",null,"2.3.2","3.0.3","1.1.2","1.1.0","1.3.0",null,"1.6.3",null,"0.3.4",null,null,null,"2.3.0","0.18","1.3.2",null,"2.2.1"],["2019-01-13","2019-03-21","2020-09-15","2015-07-28","2020-01-08","2020-01-20","2020-06-23","2011-04-13","2020-10-02","2020-09-07","2016-07-27","2020-02-06","2020-02-28","2019-07-23","2019-03-18","2018-12-01","2020-09-16","2020-10-01","2017-09-16","2020-03-13","2019-12-02","2019-12-15","2020-05-27","2018-05-01","2020-09-18","2013-01-24","2020-02-23","2020-08-18","2020-08-05","2020-05-15","2019-05-28","2020-01-08","2020-01-16","2020-03-01","2020-07-31","2017-10-31",null,null,"2018-11-29",null,"2020-06-19","2020-01-24","2020-05-03","2020-08-27","2017-09-09","2020-08-05","2019-03-25","2020-06-01","2019-03-20","2020-01-08","2020-06-16","2020-10-03","2020-07-20","2018-05-20","2020-06-20","2020-09-07","2020-09-22","2014-08-23","2020-06-05","2020-04-02","2019-03-15","2020-03-06","2020-06-08","2014-11-22","2019-08-07","2020-04-26","2019-11-27","2017-04-21","2019-11-09","2020-02-04","2020-05-19","2018-06-12","2020-05-24","2020-09-18","2020-07-10","2020-07-13","2019-09-22","2020-05-29","2015-08-11","2020-01-24","2020-09-03","2019-05-16","2020-06-09","2020-08-11","2020-04-17","2019-11-12","2019-05-07","2014-12-07","2020-07-06","2018-12-21","2019-03-13",null,"2016-04-21","2020-05-01","2020-07-21","2019-05-16","2020-04-21","2020-07-09","2020-09-30","2020-06-27",null,"2018-01-03","2020-02-07","2020-05-25","2020-07-25","2020-03-18","2020-05-11","2019-11-20","2018-11-05","2020-09-09","2019-02-10","2020-07-23","2020-03-02","2020-07-10","2020-08-27","2020-05-11","2019-11-21","2020-09-22","2020-09-17","2018-05-24","2020-08-29","2018-03-29","2018-02-01","2019-08-28","2020-09-22","2020-09-29","2020-04-23","2018-09-17","2020-02-01"],["CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)",null,null,"CRAN (R 4.0.0)",null,"CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)",null,"CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.2)",null,"CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.2)","CRAN (R 4.0.2)","CRAN (R 4.0.0)","CRAN (R 4.0.0)","CRAN (R 4.0.0)"]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th>package<\/th>\n      <th>loadedversion<\/th>\n      <th>date<\/th>\n      <th>source<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":129,"autoWidth":true,"bInfo":false,"paging":false,"order":[],"orderClasses":false,"orderCellsTop":true,"lengthMenu":[10,25,50,100,129]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## Lizenz {-}

Diese Arbeit ist lizensiert unter [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

<center>
<i class="fab fa-creative-commons fa-2x"></i><i class="fab fa-creative-commons-by fa-2x"></i><i class="fab fa-creative-commons-sa fa-2x"></i>
</center>



