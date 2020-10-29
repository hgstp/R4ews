# Using colors in R {#colors}



<!--Original content: https://stat545.com/block018_colors.html-->

<!--TODO: The link below is broken. Found it listed [here](https://www.showmeshiny.com/r-graph-catalog/) which links this [repo](https://github.com/jennybc/r-graph-catalog) as the source code

[R Graph Catalog](http://shiny.stat.ubc.ca/r-graph-catalog/), a visual, clickable index of 100+ figures + ggplot2 code to make them

Note that I SKIPPED THE R GRAPH CATALOG LINK
-->

## Load dplyr and gapminder


```r
library(dplyr)
library(gapminder)
```

## Change the default plotting symbol to a solid circle

The color demos below will be more effective if the default plotting symbol is a solid circle. We limit ourselves to base R graphics in this tutorial, therefore we use `par()`, the function that queries and sets base R graphical parameters. In an interactive session or in a plain R script, do this:


```r
## how to change the plot symbol in a simple, non-knitr setting
opar <- par(pch = 19)
```

Technically, you don't need to make the assignment, but it's a good practice. We're killing two birds with one stone:

1. Changing the default plotting symbol to a filled circle, which has code 19 in R. (Below I link to some samplers showing all the plotting symbols, FYI.)
1. Storing the pre-existing and, in this case, default graphical parameters in `opar`.
  
When you change a graphical parameter via `par()`, the original values are returned and we're capturing them via assignment to `opar`. At the very bottom of this tutorial, we use `opar` to restore the original state. 

Big picture, it is best practice to restore the original, default state of hidden things that affect an R session. This is polite if you plan to inflict your code on others. Even if you live on an R desert island, this practice will prevent you from creating maddening little puzzles for yourself to solve in the middle of the night before a deadline.

Because of the way figures are handled by knitr, it is more complicated to change the default plotting symbol throughout an R Markdown document. To see how I've done it, check out a hidden chunk around here in the [source of this page].




## Basic color specification and the default palette

I need a small well-behaved excerpt from the Gapminder data for demonstration purposes. I randomly draw 8 countries, keep their data from 2007, and sort the rows based on GDP per capita. Meet `jdat`.




```r
jdat
#> # A tibble: 8 x 6
#>   country                 continent  year lifeExp       pop gdpPercap
#>   <fct>                   <fct>     <int>   <dbl>     <int>     <dbl>
#> 1 Central African Republ… Africa     2007    44.7    4.37e6      706.
#> 2 Guinea                  Africa     2007    56.0    9.95e6      943.
#> 3 Cote d'Ivoire           Africa     2007    48.3    1.80e7     1545.
#> 4 India                   Asia       2007    64.7    1.11e9     2452.
#> 5 Pakistan                Asia       2007    65.5    1.69e8     2606.
#> 6 South Africa            Africa     2007    49.3    4.40e7     9270.
#> 7 Costa Rica              Americas   2007    78.8    4.13e6     9645.
#> 8 Panama                  Americas   2007    75.5    3.24e6     9809.
```

A simple scatterplot, using `plot()` from the base package graphics.


```r
j_xlim <- c(460, 60000)
j_ylim <- c(47, 82)
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     main = "Start your engines ...")
```

![](25_colors_files/figure-latex/unnamed-chunk-7-1.pdf)<!-- --> 

You can specify color explicitly by name by supplying a character vector with one or more color names (more on those soon). If you need a color for 8 points and you input fewer, recycling will kick in. Here's what happens when you specify one or two colors via the `col =` argument of `plot()`.


```r
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = "red", main = 'col = "red"')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = c("blue", "orange"), main = 'col = c("blue", "orange")')
```


\includegraphics[width=0.5\linewidth]{25_colors_files/figure-latex/unnamed-chunk-8-1} \includegraphics[width=0.5\linewidth]{25_colors_files/figure-latex/unnamed-chunk-8-2} 

You can specify color explicitly with a small positive integer, which is interpreted as indexing into the current palette, which can be inspected via `palette()`. I've added these integers and the color names as labels to the figures below. The default palette contains 8 colors, which is why we're looking at data from eight countries. The default palette is ugly.


```r
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = paste0('col = 1:', n_c))
with(jdat, text(x = gdpPercap, y = lifeExp, pos = 1))
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = 'the default palette()')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = palette(),
                pos = rep(c(1, 3, 1), c(5, 1, 2))))     
```


\includegraphics[width=0.5\linewidth]{25_colors_files/figure-latex/unnamed-chunk-9-1} \includegraphics[width=0.5\linewidth]{25_colors_files/figure-latex/unnamed-chunk-9-2} 

You can provide your own vector of colors instead. I am intentionally modelling best practice here too: if you're going to use custom colors, store them as an object in exactly one place, and use that object in plot calls, legend-making, etc. This makes it much easier to fiddle with your custom colors, which few of us can resist.


```r
j_colors <- c('chartreuse3', 'cornflowerblue', 'darkgoldenrod1', 'peachpuff3',
             'mediumorchid2', 'turquoise3', 'wheat4', 'slategray2')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_colors, main = 'custom colors!')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 
```

![](25_colors_files/figure-latex/unnamed-chunk-10-1.pdf)<!-- --> 

## What colors are available? Ditto for symbols and line types

Who would have guessed that R knows about "peachpuff3"? To see the names of all 657 the built-in colors, use `colors()`.


```r
head(colors())
#> [1] "white"         "aliceblue"     "antiquewhite"  "antiquewhite1"
#> [5] "antiquewhite2" "antiquewhite3"
tail(colors())
#> [1] "yellow"      "yellow1"     "yellow2"     "yellow3"    
#> [5] "yellow4"     "yellowgreen"
```

But it's much more exciting to see the colors displayed! Lots of people have tackled this -- for colors, plotting symbols, line types -- and put their work on the internet. Some examples:

* I put color names [on a white background](img/r.col.white.bkgd.pdf) and [on black](img/r.col.black.bkgd.pdf) *(sorry, these are PDFs)*
* I printed [the first 30 plotting symbols](img/r.pch.pdf) (presumably using code found elsewhere or in documentation? can't remember whom to credit) *(sorry, it's a PDF)*
* In [Chapter 3 of R Graphics 1st edition](https://www.stat.auckland.ac.nz/~paul/RGraphics/chapter3.html) [-@murrell2005], Paul Murrell shows predefined and custom line types in [Figure 3.6](https://www.stat.auckland.ac.nz/~paul/RGraphics/custombase-lty.png) and plotting symbols in [Figure 3.10](https://www.stat.auckland.ac.nz/~paul/RGraphics/custombase-datasymbols.png).
  
<!--TODO: The link below is broken, replace with something similar?
  * Earl F. Glynn offers [an excellent resource](http://research.stowers-institute.org/efg/R/Color/Chart/) on R's built-in named colors.
-->


## RColorBrewer

Most of us are pretty lousy at choosing colors and it's easy to spend too much time fiddling with them. [Cynthia Brewer](https://en.wikipedia.org/wiki/Cynthia_Brewer), a geographer and color specialist, has created sets of colors for print and the web and they are available in the add-on package [RColorBrewer]. You will need to install and load this package to use.


```r
# install.packages("RColorBrewer")
library(RColorBrewer)
```

Let's look at all the associated palettes.


```r
display.brewer.all()
```

![](25_colors_files/figure-latex/unnamed-chunk-13-1.pdf)<!-- --> 

They fall into three classes. From top to bottom, they are

* __Sequential__: great for low-to-high things where one extreme is exciting and the other is boring, like (transformations of) p-values and correlations (caveat: here I'm assuming the only exciting correlations you're likely to see are positive, i.e. near 1)
* __Qualitative__: great for non-ordered categorical things -- such as your typical factor, like country or continent. Note the special case "Paired" palette; example where that's useful: a non-experimental factor (e.g. type of wheat) and a binary experimental factor (e.g. untreated vs. treated).
* __Diverging__: great for things that range from "extreme and negative" to "extreme and positive", going through "non extreme and boring" along the way, such as t-statistics and z-scores and signed correlations

You can view a single RColorBrewer palette by specifying its name:


```r
display.brewer.pal(n = 8, name = 'Dark2')
```

![](25_colors_files/figure-latex/unnamed-chunk-14-1.pdf)<!-- --> 

The package is, frankly, rather clunky, as evidenced by the requirement to specify `n` above. Sorry folks, you'll just have to cope.

Here we revisit specifying custom colors as we did above, but using a palette from RColorBrewer instead of our artisanal "peachpuff3" work of art. As before, I display the colors themselves but you'll see we're not getting the friendly names you've seen before, which brings us to our next topic.


```r
j_brew_colors <- brewer.pal(n = 8, name = "Dark2")
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_brew_colors, main = 'Dark2 qualitative palette from RColorBrewer')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_brew_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 
```

![](25_colors_files/figure-latex/unnamed-chunk-15-1.pdf)<!-- --> 

## viridis

In 2015 Stéfan van der Walt and Nathaniel Smith designed new color maps for matplotlib and [presented them in a talk at SciPy 2015](https://www.youtube.com/watch?v=xAoljeRJ3lU&feature=youtu.be). The viridis R package provides four new palettes for use in R: on [CRAN](https://cloud.R-project.org/package=viridis) with development on [GitHub](https://github.com/sjmgarnier/viridis). From DESCRIPTION:


> These color maps are designed in such a way that they will analytically be perfectly perceptually-uniform, both in regular form and also when converted to black-and-white. They are also designed to be perceived by readers with the most common form of color blindness (all color maps in this package) and color vision deficiency ('cividis' only).

I encourage you to install viridis and read [the vignette](https://cloud.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html). It is easy to use these palettes in ggplot2 via `scale_color_viridis()` and `scale_fill_viridis()`. Taking control of color palettes in ggplot2 is covered elsewhere (see Chapter \@ref(qualitative-colors)).

Here are two examples that show the viridis palettes:


```r
library(ggplot2)
library(viridis)
ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()
```

![](25_colors_files/figure-latex/unnamed-chunk-16-1.pdf)<!-- --> 


\begin{figure}
\includegraphics[width=28.44in]{img/viridis-sample2} \caption{From [https://github.com/sjmgarnier/viridis](https://github.com/sjmgarnier/viridis)}(\#fig:unnamed-chunk-17)
\end{figure}

## Hexadecimal RGB color specification

Instead of small positive integers and Crayola-style names, a more general and machine-readable approach to color specification is as hexadecimal triplets. Here is how the RColorBrewer Dark2 palette is actually stored:


```r
brewer.pal(n = 8, name = "Dark2")
#> [1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E" "#E6AB02"
#> [7] "#A6761D" "#666666"
```

The leading `#` is just there by convention. Parse the hexadecimal string like so: `#rrggbb`, where `rr`, `gg`, and `bb` refer to color intensity in the red, green, and blue channels, respectively. Each is specified as a two-digit base 16 number, which is the meaning of "hexadecimal" (or "hex" for short). 

Here's a table relating base 16 numbers to the beloved base 10 system.

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lllllllllllllllll}
\toprule
 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & 14 & 15 & 16 \\ 
\midrule
hex & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & A & B & C & D & E & F \\ 
decimal & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & 14 & 15 \\ 
\bottomrule
\end{longtable}

Example: the first color in the palette is specified as "#1B9E77", so the intensity in the green channel is 9E. What does that mean?

$$
9E = 9 * 16^1 + 14 * 16^0 = 9 * 16 + 14 = 158
$$
Note that the lowest possible channel intensity is `00` = 0 and the highest is `FF` = 255.

Important special cases that help you stay oriented. Here are the saturated RGB colors, red, blue, and green:

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{llrrr}
\toprule
color\_name & hex & red & green & blue \\ 
\midrule
blue & \#0000FF & 0 & 0 & 255 \\ 
green & \#00FF00 & 0 & 255 & 0 \\ 
red & \#FF0000 & 255 & 0 & 0 \\ 
\bottomrule
\end{longtable}

Here are shades of gray:

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{llrrr}
\toprule
color\_name & hex & red & green & blue \\ 
\midrule
white, gray100 & \#FFFFFF & 255 & 255 & 255 \\ 
gray67 & \#ABABAB & 171 & 171 & 171 \\ 
gray33 & \#545454 & 84 & 84 & 84 \\ 
black, gray0 & \#000000 & 0 & 0 & 0 \\ 
\bottomrule
\end{longtable}

Note that everywhere you see "gray" above, you will get the same results if you substitute "grey". We see that white corresponds to maximum intensity in all channels and black to the minimum.

To review, here are the ways to specify colors in R:

* a *positive integer*, used to index into the current color palette (queried or manipulated via `palette()`)
* a *color name* among those found in `colors()`
* a *hexadecimal string*; in addition to a hexadecimal triple, in some contexts this can be extended to a hexadecimal quadruple with the fourth channel referring to alpha transparency

Here are some functions to read up on if you want to learn more -- don't forget to mine the "See Also" section of the help to expand your horizons: `rgb()`, `col2rgb()`, `convertColor()`.

## Alternatives to the RGB color model, especially HCL

The RGB color space or model is by no means the only or best one. It's natural for describing colors for display on a computer screen but some really important color picking tasks are hard to execute in this model. For example, it's not obvious how to construct a qualitative palette where the colors are easy for humans to distinguish, but are also perceptually comparable to one other. Appreciate this: we can use RGB to describe colors to the computer __but we don't have to use it as the space where we construct color systems__.

Color models generally have three dimensions, as RGB does, due to the physiological reality that humans have three different receptors in the retina. (["My favorite RGB color"] is an informative blog post on RGB and the human visual system.) The closer a color model's dimensions correspond to distinct qualities people can perceive, the more useful it is. This correspondence facilitates the deliberate construction of palettes and paths through color space with specific properties. RGB lacks this concordance with human perception. Just because you have photoreceptors that detect red, green, and blue light, it doesn't mean that your *perceptual experience* of color breaks down that way. Do you experience the color yellow as a mix of red and green light? No, of course not, but that's the physiological reality. An RGB alternative you may have encountered is the Hue-Saturation-Value (HSV) model. Unfortunately, it is also quite problematic for color picking, due to its dimensions being confounded with each other.

What are the good perceptually-based color models? CIELUV and CIELAB are two well-known examples. We will focus on a variant of CIELUV, namely the Hue-Chroma-Luminance (HCL) model. It is written up nicely for an R audience in Zeileis et al.'s ["Escaping RGBland: Selecting Colors for Statistical Graphs"] in Computational Statistics & Data Analysis [-@zeileis2009]. There is a companion R package, [colorspace], which will help you to explore and exploit the HCL color model. Finally, this color model is fully embraced in ggplot2 (as are the RColorBrewer palettes).

Here's what I can tell you about the HCL model's three dimensions:

* __Hue__ is what you usually think of when you think "what color is that?" It's the easy one! It is given as an angle, going from 0 to 360, so imagine a rainbow donut.
* __Chroma__ refers to colorfullness, i.e. how pure or vivid a color is. The more something seems mixed with gray, the lower its chromaticity. The lowest possible value is 0, which corresponds to actual gray. The maximum value varies with luminance.
* __Luminance__ is related to brightness, lightness, intensity, and value. Low luminance means dark and indeed black has luminance 0. High luminance means light and white has luminance 1.
  
Full disclosure: I have a hard time really grasping and distinguishing chroma and luminance. As we point out above, they are not entirely independent, which speaks to the weird shape of the 3 dimensional HCL space.
  
This figure in Wickham's [ggplot2: Elegant Graphics for Data Analysis] [-@wickham2009] book is helpful for understanding the HCL color space:


\begin{figure}
\includegraphics[width=12.88in]{img/ggplot2book-fig6.6} \caption{From [ggplot2: Elegant Graphics for Data Analysis] by Hadley Wickham [-@wickham2009]}(\#fig:unnamed-chunk-19)
\end{figure}

Paraphrasing Wickham: Each facet or panel depicts a slice through HCL space for a specific luminance, going from low to high. The extreme luminance values of 0 and 100 are omitted because they would, respectively, be a single black point and a single white point. Within a slice, the centre has chroma 0, which corresponds to a shade of grey. As you move toward the slice's edge, chroma increases and the color gets more pure and intense. Hue is mapped to angle.
  
A valuable contribution of the colorspace package is that it provides functions to create color palettes traversing color space in a rational way. In contrast, the palettes offered by RColorBrewer, though well-crafted, are unfortunately fixed.


Here is an article that uses compelling examples to advocate for perceptually based color systems and to demonstrate the importance of signalling where zero is in colorspace:

* ["Why Should Engineers and Scientists Be Worried About Color?"] [@rogowitz1996]

<!--TODO: Insert/recreate some visuals from the Zeileis et al. paper or from the colorspace vignette. Show actual usage! -->

## Accommodating color blindness

The [dichromat] package will help you select a color scheme that will be effective for color blind readers.


```r
# install.packages("dichromat")
library(dichromat)
```

This `colorschemes` list contains `length(colorschemes)` color schemes "suitable for people with deficient or anomalous red-green vision":

![(\#fig:dichromat-colorschemes)Color schemes "suitable for people with deficient or anomalous red-green vision"](25_colors_files/figure-latex/dichromat-colorschemes-1.pdf) 

What else does the dichromat package offer? The `dichromat()` function transforms colors to approximate the effect of different forms of color blindness, allowing you to assess the performance of a candidate scheme. The command `data("dalton")` will make two objects available which represent a 256-color palette as it would appear with normal vision, with two types of red-green color blindness, and with green-blue color blindness. 



## Clean up


```r
## NOT RUN
## execute this if you followed my code for
## changing the default plot symbol in a simple, non-knitr setting
## reversing the effects of this: opar <- par(pch = 19)
par(opar)
```

## Resources

* Zeileis et al.'s ["Escaping RGBland: Selecting Colors for Statistical Graphs"] in Computational Statistics & Data Analysis [-@zeileis2009]. 
* [Vignette](https://cloud.r-project.org/web/packages/colorspace/vignettes/hcl-colors.pdf) for the [colorspace] package.
* Earl F. Glynn (Stowers Institute for Medical Research):
    + [Excellent resources](https://web.archive.org/web/20121022044903/http://research.stowers-institute.org/efg/R/Color/Chart/) for named colors, i.e. the ones available via `colors()`.
    + Informative talk ["Using Color in R"](https://www.uv.es/conesa/CursoR/material/UsingColorInR.pdf), though features some questionable *use* of color itself.
* Blog post ["My favorite RGB color"] on the Many World Theory blog.
* Wickham's [ggplot2: Elegant Graphics for Data Analysis] [-@wickham2009].
  + [Package webpage][ggplot2]
  + ggplot2 on [CRAN](https://cloud.R-project.org/package=ggplot2) and [GitHub](https://github.com/tidyverse/ggplot2)
  + Section 6.4.3 Colour
* ["Why Should Engineers and Scientists Be Worried About Color?"] by Bernice E. Rogowitz and Lloyd A. Treinish of IBM Research [-@rogowitz1996], h/t [\@EdwardTufte](https://twitter.com/EdwardTufte).


<!--Links-->
[colorspace]: https://cloud.r-project.org/web/packages/colorspace/index.html
[dichromat]: https://cloud.R-project.org/package=dichromat
[source of this page]: https://github.com/rstudio-education/stat545/blob/master/25_colors.Rmd


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
