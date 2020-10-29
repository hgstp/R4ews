# Character encoding {#character-encoding}



<!--TODO: *under development ... not clear where this is going*-->

<!--Original content: https://stat545.com/block032_character-encoding.html-->

## Resources

* [Strings subsection of data import chapter][r4ds-readr-strings] in [R for Data Science] [@wickham2016].
* Screeds on the Minimum Everyone Needs to Know about encoding:
  - ["The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets (No Excuses!)"]
  - ["What Every Programmer Absolutely, Positively Needs To Know About Encodings And Character Sets To Work With Text"]
* Debugging charts:
  - [Windows-1252 Characters to UTF-8 Bytes to Latin-1 Characters][utf8-debug]
* Character inspection:
  - <https://apps.timwhitlock.info/unicode/inspect>

## Translating two blog posts from Ruby to R

For now, this page walks through these two mini-tutorials (written for Ruby), but translated to R:

* ["3 Steps to Fix Encoding Problems in Ruby"]
* ["How to Get From Theyâ€™re to They’re"](https://www.justinweiss.com/articles/how-to-get-from-theyre-to-theyre/)
  
Don't expect much creativity from me here. My goal is faithful translation.

## What is an encoding?

Look at the string `"hello!"` in bytes. *Ruby*
 
```ruby
irb(main):001:0> "hello!".bytes
=> [104, 101, 108, 108, 111, 33]
```
 
The base function `charToRaw()` "converts a length-one character string to raw bytes. It does so without taking into account any declared encoding". It displays bytes in hexadecimal. Use `as.integer()` to convert to decimal, which is more intuitive and allows us to compare against the Ruby results.


```r
charToRaw("hello!")
#> [1] 68 65 6c 6c 6f 21
as.integer(charToRaw("hello!"))
#> [1] 104 101 108 108 111  33
```

Use a character less common in English: *Ruby*

```
irb(main):002:0> "hellṏ!".bytes
=> [104, 101, 108, 108, 225, 185, 143, 33]
```


```r
charToRaw("hellṏ!")
#> [1] 68 65 6c 6c e1 b9 8f 21
as.integer(charToRaw("hellṏ!"))
#> [1] 104 101 108 108 225 185 143  33
```

Now we see that it takes more than one byte to represent `"ṏ"`. Three in fact: [225, 185, 143]. The encoding of a string defines this relationship: encoding is a map between one or more bytes and a displayable character.

Take a look at what a single set of bytes looks like when you try different encodings.

Here's, a string encoded as ISO-8859-1 (also known as "Latin1") with a special character. *Ruby*

```
irb(main):003:0> str = "hellÔ!".encode("ISO-8859-1"); str.encode("UTF-8")
=> "hellÔ!"

irb(main):004:0> str.bytes
=> [104, 101, 108, 108, 212, 33]
```


```r
string_latin <- iconv("hellÔ!", from = "UTF-8", to = "Latin1")
string_latin
#> [1] "hell\xd4!"
charToRaw(string_latin)
#> [1] 68 65 6c 6c d4 21
as.integer(charToRaw(string_latin))
#> [1] 104 101 108 108 212  33
```

We've confirmed that we have the correct bytes (meaning the same as the Ruby example). What would that string look like interpreted as ISO-8859-5 instead? *Ruby*

```
irb(main):005:0> str.force_encoding("ISO-8859-5"); str.encode("UTF-8")
=> "hellд!"
```


```r
iconv(string_latin, from = "ISO-8859-5", to = "UTF-8")
#> [1] "hellд!"
```

It's garbled, which is your first tip-off to an encoding problem.

Also not all strings can be represented in all encodings: *Ruby*

```
irb(main):006:0> "hi∑".encode("Windows-1252")
Encoding::UndefinedConversionError: U+2211 to WINDOWS-1252 in conversion from UTF-8 to WINDOWS-1252
 from (irb):61:in `encode'
 from (irb):61
 from /usr/local/bin/irb:11:in `<main>'
```


```r
(string <- "hi∑")
#> [1] "hi∑"
Encoding(string)
#> [1] "UTF-8"
as.integer(charToRaw(string))
#> [1] 104 105 226 136 145
(string_windows <- iconv(string, from = "UTF-8", to = "Windows-1252"))
#> [1] NA
```

In Ruby, apparently that is an error. In R, we just get `NA`. Alternatively, and somewhat like Ruby, you can specify a substitution for non-convertible bytes.


```r
(string_windows <- iconv(string, from = "UTF-8", to = "Windows-1252", sub = "?"))
#> [1] "hi???"
```

In the Ruby post, we've seen 3 string functions so far. Review and note which R function was used in the translation.

* `encode` translates a string to another encoding. We've used `iconv(x, from = "UTF-8", to = <DIFFERENT_ENCODING>)` here.
* `bytes` shows the bytes that make up a string. We've used `charToRaw()`, which returns hexadecimal in R. For the sake of comparison to the Ruby post, I've converted to decimal with `as.integer()`.
* `force_encoding` shows what the input bytes would look like if interpreted by a different encoding. We've used `iconv(x, from = <DIFFERENT_ENCODING>, to = "UTF-8")`.

## A three-step process for fixing encoding bugs

### Discover which encoding your string is actually in.

Shhh. Secret: this is encoded as Windows-1252. `\x99` should be the trademark symbol ™. Ruby can guess at the encoding. *Ruby*

```ruby
irb(main):078:0> "hi\x99!".encoding
=> #<Encoding:UTF-8>
```

Ruby's guess is bad. This is not encoded as UTF-8. R admits it doesn't know and stringi's guess is not good.


```r
string <- "hi\x99!"
string
#> [1] "hi\x99!"
Encoding(string)
#> [1] "unknown"
stringi::stri_enc_detect(string)
#> [[1]]
#>   Encoding Language Confidence
#> 1 UTF-16BE                 0.1
#> 2 UTF-16LE                 0.1
#> 3   EUC-JP       ja        0.1
#> 4   EUC-KR       ko        0.1
```

Advice given in post is to sleuth it out based on where the data came from. With larger amounts of text, each language's guessing facilities presumably do better than they do here. In real life, all of this advice can prove to be ... overly optimistic?

I find it helpful to scrutinize debugging charts and look for the weird stuff showing up in my text. Here's [one that shows what UTF-8 bytes look like][utf8-debug] when erroneously interpreted under Windows-1252 encoding. This phenomenon is known as [*mojibake*](https://en.wikipedia.org/wiki/Mojibake), which is a delightful word for a super-annoying phenomenon. If it helps, know that the most common encodings are UTF-8, ISO-8859-1 (or Latin1), and Windows-1252, so that really narrows things down.

### Decide which encoding you want the string to be

That's easy. UTF-8. Done.

### Re-encode your string

```
irb(main):088:0> "hi\x99!".encode("UTF-8", "Windows-1252")
=> "hi™!"
```


```r
string_windows <- "hi\x99!"
string_utf8 <- iconv(string_windows, from = "Windows-1252", to = "UTF-8")
Encoding(string_utf8)
#> [1] "UTF-8"
string_utf8
#> [1] "hi™!"
```

## How to Get From Theyâ€™re to They’re

Moving on to the second blog post now.

### Multi-byte characters

Since we need to represent more than 256 characters, not all can be represented by a single byte. Let's look at the curly single quote. *Ruby*

```
irb(main):001:0> "they’re".bytes
=> [116, 104, 101, 121, 226, 128, 153, 114, 101]
```


```r
string_curly <- "they’re"
charToRaw(string_curly)
#> [1] 74 68 65 79 e2 80 99 72 65
as.integer(charToRaw(string_curly))
#> [1] 116 104 101 121 226 128 153 114 101
length(as.integer(charToRaw(string_curly)))
#> [1] 9
nchar(string_curly)
#> [1] 7
```

The string has 7 characters, but 9 bytes, because we're using 3 bytes to represent the curly single quote. Let's focus just on that. *Ruby*

```
irb(main):002:0> "’".bytes
=> [226, 128, 153]
```


```r
charToRaw("’")
#> [1] e2 80 99
as.integer(charToRaw("’"))
#> [1] 226 128 153
length(as.integer(charToRaw("’")))
#> [1] 3
```

One of the most common encoding fiascos you'll see is this: theyâ€™re. Note that the curly single quote has been turned into a 3 character monstrosity. This is no coincidence. Remember those 3 bytes?

This is what happens when you interpret bytes that represent text in the UTF-8 encoding as if it's encoded as Windows-1252. Learn to recognize it. *Ruby*

```
irb(main):003:0> "they’re".force_encoding("Windows-1252").encode("UTF-8")
=> "theyâ€™re"
```


```r
(string_mis_encoded <- iconv(string_curly, to = "UTF-8", from = "windows-1252"))
#> [1] "theyâ€™re"
```

Let's assume this little gem is buried in some large file and you don't immediately notice. So this string is interpreted with the wrong encoding, i.e. stored as the wrong bytes, either in an R object or in a file on disk. Now what?

Let's review the original, correct bytes vs. the current, incorrect bytes and print the associated strings.


```r
as.integer(charToRaw(string_curly))
#> [1] 116 104 101 121 226 128 153 114 101
as.integer(charToRaw(string_mis_encoded))
#>  [1] 116 104 101 121 195 162 226 130 172 226 132 162 114 101
string_curly
#> [1] "they’re"
string_mis_encoded
#> [1] "theyâ€™re"
```

### Encoding repair

How do you fix this? You have to reverse your steps. You have a UTF-8 encoded string. Convert it back to Windows-1252, to get the original bytes. Then re-encode that as UTF-8. *Ruby*

```
irb(main):006:0> "theyâ€™re".encode("Windows-1252").force_encoding("UTF-8")
=> "they’re"
```


```r
string_mis_encoded
#> [1] "theyâ€™re"
backwards_one <- iconv(string_mis_encoded, from = "UTF-8", to = "Windows-1252")
backwards_one
#> [1] "they’re"
Encoding(backwards_one)
#> [1] "unknown"
as.integer(charToRaw(backwards_one))
#> [1] 116 104 101 121 226 128 153 114 101
as.integer(charToRaw(string_curly))
#> [1] 116 104 101 121 226 128 153 114 101
```

<!--Links-->
[utf8-debug]: http://www.i18nqa.com/debug/utf8-debug.html


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
