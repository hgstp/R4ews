# Single table dplyr functions {#dplyr-single}



<!--Original content: https://stat545.com/block010_dplyr-end-single-table.html-->

## Where were we?

In Chapter \@ref(dplyr-intro), Introduction to dplyr, we used two very important verbs and an operator:

* `filter()` for subsetting data with row logic
* `select()` for subsetting data variable- or column-wise
* the pipe operator `%>%`, which feeds the LHS as the first argument to the expression on the RHS
  
We also discussed dplyr's role inside the tidyverse and tibbles:

* [dplyr] is a core package in the [tidyverse] meta-package. Since we often make incidental usage of the others, we will load dplyr and the others via `library(tidyverse)`.
* The tidyverse embraces a special flavor of data frame, called a tibble. The `gapminder` dataset is stored as a tibble.  

## Load dplyr and gapminder

I choose to load the tidyverse, which will load dplyr, among other packages we use incidentally below. 


```r
library(tidyverse)
#> ── Attaching packages ──────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.3     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ─────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

Also load [gapminder].


```r
library(gapminder)
```


## Create a copy of `gapminder`

We're going to make changes to the `gapminder` tibble. To eliminate any fear that you're damaging the data that comes with the package, we create an explicit copy of `gapminder` for our experiments.


```r
(my_gap <- gapminder)
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

**Pay close attention** to when we evaluate statements but let the output just print to screen:


```r
## let output print to screen, but do not store
my_gap %>% filter(country == "Canada")
```

... versus when we assign the output to an object, possibly overwriting an existing object.


```r
## store the output as an R object
my_precious <- my_gap %>% filter(country == "Canada")
```

## Use `mutate()` to add new variables

Imagine we wanted to recover each country's GDP. After all, the Gapminder data has a variable for population and GDP per capita. Let's multiply them together.

`mutate()` is a function that defines and inserts new variables into a tibble. You can refer to existing variables by name.


```r
my_gap %>%
  mutate(gdp = pop * gdpPercap)
#> # A tibble: 1,704 x 7
#>    country     continent  year lifeExp      pop gdpPercap          gdp
#>    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
#>  1 Afghanistan Asia       1952    28.8  8425333      779.  6567086330.
#>  2 Afghanistan Asia       1957    30.3  9240934      821.  7585448670.
#>  3 Afghanistan Asia       1962    32.0 10267083      853.  8758855797.
#>  4 Afghanistan Asia       1967    34.0 11537966      836.  9648014150.
#>  5 Afghanistan Asia       1972    36.1 13079460      740.  9678553274.
#>  6 Afghanistan Asia       1977    38.4 14880372      786. 11697659231.
#>  7 Afghanistan Asia       1982    39.9 12881816      978. 12598563401.
#>  8 Afghanistan Asia       1987    40.8 13867957      852. 11820990309.
#>  9 Afghanistan Asia       1992    41.7 16317921      649. 10595901589.
#> 10 Afghanistan Asia       1997    41.8 22227415      635. 14121995875.
#> # … with 1,694 more rows
```

Hmmmm ... those GDP numbers are almost uselessly large and abstract. Consider the [advice of Randall Munroe of xkcd](https://fivethirtyeight.com/features/xkcd-randall-munroe-qanda-what-if/):

>One thing that bothers me is large numbers presented without context... "If I added a zero to this number, would the sentence containing it mean something different to me?" If the answer is "no", maybe the number has no business being in the sentence in the first place.

Maybe it would be more meaningful to consumers of my tables and figures to stick with GDP per capita. But what if I reported GDP per capita, *relative to some benchmark country*. Since Canada is my adopted home, I'll go with that. 

I need to create a new variable that is `gdpPercap` divided by Canadian `gdpPercap`, taking care that I always divide two numbers that pertain to the same year.

How I achieve this:

1. Filter down to the rows for Canada.
1. Create a new temporary variable in `my_gap`:
    i) Extract the `gdpPercap` variable from the Canadian data.
    i) Replicate it once per country in the dataset, so it has the right length.
1. Divide raw `gdpPercap` by this Canadian figure.
1. Discard the temporary variable of replicated Canadian `gdpPercap`.


```r
ctib <- my_gap %>%
  filter(country == "Canada")
## this is a semi-dangerous way to add this variable
## I'd prefer to join on year, but we haven't covered joins yet
my_gap <- my_gap %>%
  mutate(tmp = rep(ctib$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)
```

Note that, `mutate()` builds new variables sequentially so you can reference earlier ones (like `tmp`) when defining later ones (like `gdpPercapRel`). Also, you can get rid of a variable by setting it to `NULL`.

How could we sanity check that this worked? The Canadian values for `gdpPercapRel` better all be 1!


```r
my_gap %>% 
  filter(country == "Canada") %>% 
  select(country, year, gdpPercapRel)
#> # A tibble: 12 x 3
#>    country  year gdpPercapRel
#>    <fct>   <int>        <dbl>
#>  1 Canada   1952            1
#>  2 Canada   1957            1
#>  3 Canada   1962            1
#>  4 Canada   1967            1
#>  5 Canada   1972            1
#>  6 Canada   1977            1
#>  7 Canada   1982            1
#>  8 Canada   1987            1
#>  9 Canada   1992            1
#> 10 Canada   1997            1
#> 11 Canada   2002            1
#> 12 Canada   2007            1
```

I perceive Canada to be a "high GDP" country, so I predict that the distribution of `gdpPercapRel` is located below 1, possibly even well below. Check your intuition!


```r
summary(my_gap$gdpPercapRel)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    0.01    0.06    0.17    0.33    0.45    9.53
```

The relative GDP per capita numbers are, in general, well below 1. We see that most of the countries covered by this dataset have substantially lower GDP per capita, relative to Canada, across the entire time period.

Remember: Trust No One. Including (especially?) yourself. Always try to find a way to check that you've done what meant to. Prepare to be horrified.

## Use `arrange()` to row-order data in a principled way

`arrange()` reorders the rows in a data frame. Imagine you wanted this data ordered by year then country, as opposed to by country then year.


```r
my_gap %>%
  arrange(year, country)
#> # A tibble: 1,704 x 7
#>    country     continent  year lifeExp      pop gdpPercap gdpPercapRel
#>    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
#>  1 Afghanistan Asia       1952    28.8  8425333      779.       0.0686
#>  2 Albania     Europe     1952    55.2  1282697     1601.       0.141 
#>  3 Algeria     Africa     1952    43.1  9279525     2449.       0.215 
#>  4 Angola      Africa     1952    30.0  4232095     3521.       0.310 
#>  5 Argentina   Americas   1952    62.5 17876956     5911.       0.520 
#>  6 Australia   Oceania    1952    69.1  8691212    10040.       0.883 
#>  7 Austria     Europe     1952    66.8  6927772     6137.       0.540 
#>  8 Bahrain     Asia       1952    50.9   120447     9867.       0.868 
#>  9 Bangladesh  Asia       1952    37.5 46886859      684.       0.0602
#> 10 Belgium     Europe     1952    68    8730405     8343.       0.734 
#> # … with 1,694 more rows
```

Or maybe you want just the data from 2007, sorted on life expectancy?


```r
my_gap %>%
  filter(year == 2007) %>%
  arrange(lifeExp)
#> # A tibble: 142 x 7
#>    country                continent  year lifeExp     pop gdpPercap gdpPercapRel
#>    <fct>                  <fct>     <int>   <dbl>   <int>     <dbl>        <dbl>
#>  1 Swaziland              Africa     2007    39.6  1.13e6     4513.       0.124 
#>  2 Mozambique             Africa     2007    42.1  2.00e7      824.       0.0227
#>  3 Zambia                 Africa     2007    42.4  1.17e7     1271.       0.0350
#>  4 Sierra Leone           Africa     2007    42.6  6.14e6      863.       0.0237
#>  5 Lesotho                Africa     2007    42.6  2.01e6     1569.       0.0432
#>  6 Angola                 Africa     2007    42.7  1.24e7     4797.       0.132 
#>  7 Zimbabwe               Africa     2007    43.5  1.23e7      470.       0.0129
#>  8 Afghanistan            Asia       2007    43.8  3.19e7      975.       0.0268
#>  9 Central African Repub… Africa     2007    44.7  4.37e6      706.       0.0194
#> 10 Liberia                Africa     2007    45.7  3.19e6      415.       0.0114
#> # … with 132 more rows
```

Oh, you'd like to sort on life expectancy in **desc**ending order? Then use `desc()`.


```r
my_gap %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExp))
#> # A tibble: 142 x 7
#>    country          continent  year lifeExp       pop gdpPercap gdpPercapRel
#>    <fct>            <fct>     <int>   <dbl>     <int>     <dbl>        <dbl>
#>  1 Japan            Asia       2007    82.6 127467972    31656.        0.872
#>  2 Hong Kong, China Asia       2007    82.2   6980412    39725.        1.09 
#>  3 Iceland          Europe     2007    81.8    301931    36181.        0.996
#>  4 Switzerland      Europe     2007    81.7   7554661    37506.        1.03 
#>  5 Australia        Oceania    2007    81.2  20434176    34435.        0.948
#>  6 Spain            Europe     2007    80.9  40448191    28821.        0.794
#>  7 Sweden           Europe     2007    80.9   9031088    33860.        0.932
#>  8 Israel           Asia       2007    80.7   6426679    25523.        0.703
#>  9 France           Europe     2007    80.7  61083916    30470.        0.839
#> 10 Canada           Americas   2007    80.7  33390141    36319.        1    
#> # … with 132 more rows
```

I advise that your analyses NEVER rely on rows or variables being in a specific order. But it's still true that human beings write the code and the interactive development process can be much nicer if you reorder the rows of your data as you go along. Also, once you are preparing tables for human eyeballs, it is imperative that you step up and take control of row order.

## Use `rename()` to rename variables

When I first cleaned this Gapminder excerpt, I was a [`camelCase`](https://en.wikipedia.org/wiki/Camel_case) person, but now I'm all about [`snake_case`][wiki-snake-case]. So I am vexed by the variable names I chose when I cleaned this data years ago. Let's rename some variables!


```r
my_gap %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)
#> # A tibble: 1,704 x 7
#>    country     continent  year life_exp      pop gdp_percap gdp_percap_rel
#>    <fct>       <fct>     <int>    <dbl>    <int>      <dbl>          <dbl>
#>  1 Afghanistan Asia       1952     28.8  8425333       779.         0.0686
#>  2 Afghanistan Asia       1957     30.3  9240934       821.         0.0657
#>  3 Afghanistan Asia       1962     32.0 10267083       853.         0.0634
#>  4 Afghanistan Asia       1967     34.0 11537966       836.         0.0520
#>  5 Afghanistan Asia       1972     36.1 13079460       740.         0.0390
#>  6 Afghanistan Asia       1977     38.4 14880372       786.         0.0356
#>  7 Afghanistan Asia       1982     39.9 12881816       978.         0.0427
#>  8 Afghanistan Asia       1987     40.8 13867957       852.         0.0320
#>  9 Afghanistan Asia       1992     41.7 16317921       649.         0.0246
#> 10 Afghanistan Asia       1997     41.8 22227415       635.         0.0219
#> # … with 1,694 more rows
```

I did NOT assign the post-rename object back to `my_gap` because that would make the chunks in this tutorial harder to copy/paste and run out of order. In real life, I would probably assign this back to `my_gap`, in a data preparation script, and proceed with the new variable names.

## `select()` can rename and reposition variables

You've seen simple use of `select()`. There are two tricks you might enjoy:

1. `select()` can rename the variables you request to keep.
1. `select()` can be used with `everything()` to hoist a variable up to the front of the tibble.
  

```r
my_gap %>%
  filter(country == "Burundi", year > 1996) %>% 
  select(yr = year, lifeExp, gdpPercap) %>% 
  select(gdpPercap, everything())
#> # A tibble: 3 x 3
#>   gdpPercap    yr lifeExp
#>       <dbl> <int>   <dbl>
#> 1      463.  1997    45.3
#> 2      446.  2002    47.4
#> 3      430.  2007    49.6
```

`everything()` is one of several helpers for variable selection. Read its help to see the rest.

## `group_by()` is a mighty weapon

I have found that ~~friends and family~~ collaborators love to ask seemingly innocuous questions like, "which country experienced the sharpest 5-year drop in life expectancy?". In fact, that is a totally natural question to ask. But if you are using a language that doesn't know about data, it's an incredibly annoying question to answer.


dplyr offers powerful tools to solve this class of problem:

* `group_by()` adds extra structure to your dataset -- grouping information -- which lays the groundwork for computations within the groups.

* `summarize()` takes a dataset with $n$ observations, computes requested summaries, and returns a dataset with 1 observation.

* Window functions take a dataset with $n$ observations and return a dataset with $n$ observations.

* `mutate()` and `summarize()` will honor groups.

* You can also do very general computations on your groups with `do()`, though elsewhere in this course, I advocate for other approaches that I find more intuitive, using the [purrr] package.
  
Combined with the verbs you already know, these new tools allow you to solve an extremely diverse set of problems with relative ease.

### Counting things up

Let's start with simple counting.  How many observations do we have per continent?


```r
my_gap %>%
  group_by(continent) %>%
  summarize(n = n())
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 5 x 2
#>   continent     n
#>   <fct>     <int>
#> 1 Africa      624
#> 2 Americas    300
#> 3 Asia        396
#> 4 Europe      360
#> 5 Oceania      24
```

Let us pause here to think about the tidyverse. You could get these same frequencies using `table()` from base R.


```r
table(gapminder$continent)
#> 
#>   Africa Americas     Asia   Europe  Oceania 
#>      624      300      396      360       24
str(table(gapminder$continent))
#>  'table' int [1:5(1d)] 624 300 396 360 24
#>  - attr(*, "dimnames")=List of 1
#>   ..$ : chr [1:5] "Africa" "Americas" "Asia" "Europe" ...
```

But the object of class `table` that is returned makes downstream computation a bit fiddlier than you'd like. For example, it's too bad the continent levels come back only as *names* and not as a proper factor, with the original set of levels. This is an example of how the tidyverse smooths transitions where you want the output of step `i` to become the input of step `i + 1`.

The `tally()` function is a convenience function that knows to count rows. It honors groups.


```r
my_gap %>%
  group_by(continent) %>%
  tally()
#> # A tibble: 5 x 2
#>   continent     n
#>   <fct>     <int>
#> 1 Africa      624
#> 2 Americas    300
#> 3 Asia        396
#> 4 Europe      360
#> 5 Oceania      24
```

The `count()` function is an even more convenient function that does both grouping and counting.


```r
my_gap %>% 
  count(continent)
#> # A tibble: 5 x 2
#>   continent     n
#>   <fct>     <int>
#> 1 Africa      624
#> 2 Americas    300
#> 3 Asia        396
#> 4 Europe      360
#> 5 Oceania      24
```

What if we wanted to add the number of unique countries for each continent? You can compute multiple summaries inside `summarize()`. Use the `n_distinct()` function to count the number of distinct countries within each continent.


```r
my_gap %>%
  group_by(continent) %>%
  summarize(n = n(),
            n_countries = n_distinct(country))
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 5 x 3
#>   continent     n n_countries
#>   <fct>     <int>       <int>
#> 1 Africa      624          52
#> 2 Americas    300          25
#> 3 Asia        396          33
#> 4 Europe      360          30
#> 5 Oceania      24           2
```

### General summarization

The functions you'll apply within `summarize()` include classical statistical summaries, like  `mean()`, `median()`, `var()`, `sd()`, `mad()`, `IQR()`, `min()`, and `max()`. Remember they are functions that take $n$ inputs and distill them down into 1 output.

Although this may be statistically ill-advised, let's compute the average life expectancy by continent.


```r
my_gap %>%
  group_by(continent) %>%
  summarize(avg_lifeExp = mean(lifeExp))
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 5 x 2
#>   continent avg_lifeExp
#>   <fct>           <dbl>
#> 1 Africa           48.9
#> 2 Americas         64.7
#> 3 Asia             60.1
#> 4 Europe           71.9
#> 5 Oceania          74.3
```

<!--TODO: summarize_at() is soft deprecated as of dplyr 0.8.0-->
`summarize_at()` applies the same summary function(s) to multiple variables. Let's compute average and median life expectancy and GDP per capita by continent by year...but only for 1952 and 2007.


```r
my_gap %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarize_at(vars(lifeExp, gdpPercap), list(~mean(.), ~median(.)))
#> # A tibble: 10 x 6
#> # Groups:   continent [5]
#>    continent  year lifeExp_mean gdpPercap_mean lifeExp_median gdpPercap_median
#>    <fct>     <int>        <dbl>          <dbl>          <dbl>            <dbl>
#>  1 Africa     1952         39.1          1253.           38.8             987.
#>  2 Africa     2007         54.8          3089.           52.9            1452.
#>  3 Americas   1952         53.3          4079.           54.7            3048.
#>  4 Americas   2007         73.6         11003.           72.9            8948.
#>  5 Asia       1952         46.3          5195.           44.9            1207.
#>  6 Asia       2007         70.7         12473.           72.4            4471.
#>  7 Europe     1952         64.4          5661.           65.9            5142.
#>  8 Europe     2007         77.6         25054.           78.6           28054.
#>  9 Oceania    1952         69.3         10298.           69.3           10298.
#> 10 Oceania    2007         80.7         29810.           80.7           29810.
```

Let's focus just on Asia. What are the minimum and maximum life expectancies seen by year?


```r
my_gap %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 12 x 3
#>     year min_lifeExp max_lifeExp
#>    <int>       <dbl>       <dbl>
#>  1  1952        28.8        65.4
#>  2  1957        30.3        67.8
#>  3  1962        32.0        69.4
#>  4  1967        34.0        71.4
#>  5  1972        36.1        73.4
#>  6  1977        31.2        75.4
#>  7  1982        39.9        77.1
#>  8  1987        40.8        78.7
#>  9  1992        41.7        79.4
#> 10  1997        41.8        80.7
#> 11  2002        42.1        82  
#> 12  2007        43.8        82.6
```

Of course it would be much more interesting to see *which* country contributed these extreme observations. Is the minimum (maximum) always coming from the same country? We tackle that with window functions shortly.

## Grouped mutate

Sometimes you don't want to collapse the $n$ rows for each group into one row. You want to keep your groups, but compute within them.

### Computing with group-wise summaries

Let's make a new variable that is the years of life expectancy gained (lost) relative to 1952, for each individual country. We group by country and use `mutate()` to make a new variable. The `first()` function extracts the first value from a vector. Notice that `first()` is operating on the vector of life expectancies *within each country group*.


```r
my_gap %>% 
  group_by(country) %>% 
  select(country, year, lifeExp) %>% 
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) %>% 
  filter(year < 1963)
#> # A tibble: 426 x 4
#> # Groups:   country [142]
#>    country      year lifeExp lifeExp_gain
#>    <fct>       <int>   <dbl>        <dbl>
#>  1 Afghanistan  1952    28.8         0   
#>  2 Afghanistan  1957    30.3         1.53
#>  3 Afghanistan  1962    32.0         3.20
#>  4 Albania      1952    55.2         0   
#>  5 Albania      1957    59.3         4.05
#>  6 Albania      1962    64.8         9.59
#>  7 Algeria      1952    43.1         0   
#>  8 Algeria      1957    45.7         2.61
#>  9 Algeria      1962    48.3         5.23
#> 10 Angola       1952    30.0         0   
#> # … with 416 more rows
```

Within country, we take the difference between life expectancy in year $i$ and life expectancy in 1952. Therefore we always see zeroes for 1952 and, for most countries, a sequence of positive and increasing numbers.

### Window functions {#window-functions}

Window functions take $n$ inputs and give back $n$ outputs. Furthermore, the output depends on all the values. So `rank()` is a window function but `log()` is not. Here we use window functions based on ranks and offsets.

Let's revisit the worst and best life expectancies in Asia over time, but retaining info about *which* country contributes these extreme values.


```r
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>% 
  arrange(year) %>%
  print(n = Inf)
#> # A tibble: 24 x 3
#> # Groups:   year [12]
#>     year country     lifeExp
#>    <int> <fct>         <dbl>
#>  1  1952 Afghanistan    28.8
#>  2  1952 Israel         65.4
#>  3  1957 Afghanistan    30.3
#>  4  1957 Israel         67.8
#>  5  1962 Afghanistan    32.0
#>  6  1962 Israel         69.4
#>  7  1967 Afghanistan    34.0
#>  8  1967 Japan          71.4
#>  9  1972 Afghanistan    36.1
#> 10  1972 Japan          73.4
#> 11  1977 Cambodia       31.2
#> 12  1977 Japan          75.4
#> 13  1982 Afghanistan    39.9
#> 14  1982 Japan          77.1
#> 15  1987 Afghanistan    40.8
#> 16  1987 Japan          78.7
#> 17  1992 Afghanistan    41.7
#> 18  1992 Japan          79.4
#> 19  1997 Afghanistan    41.8
#> 20  1997 Japan          80.7
#> 21  2002 Afghanistan    42.1
#> 22  2002 Japan          82  
#> 23  2007 Afghanistan    43.8
#> 24  2007 Japan          82.6
```

We see that (min = Afghanistan, max = Japan) is the most frequent result, but Cambodia and Israel pop up at least once each as the min or max, respectively. That table should make you impatient for our upcoming work on tidying and reshaping data! Wouldn't it be nice to have one row per year?

How did that actually work? First, I store and view a partial that leaves off the `filter()` statement. All of these operations should be familiar.


```r
asia <- my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year)
asia
#> # A tibble: 396 x 3
#> # Groups:   year [12]
#>     year country     lifeExp
#>    <int> <fct>         <dbl>
#>  1  1952 Afghanistan    28.8
#>  2  1957 Afghanistan    30.3
#>  3  1962 Afghanistan    32.0
#>  4  1967 Afghanistan    34.0
#>  5  1972 Afghanistan    36.1
#>  6  1977 Afghanistan    38.4
#>  7  1982 Afghanistan    39.9
#>  8  1987 Afghanistan    40.8
#>  9  1992 Afghanistan    41.7
#> 10  1997 Afghanistan    41.8
#> # … with 386 more rows
```

Now we apply a window function -- `min_rank()`. Since `asia` is grouped by year, `min_rank()` operates within mini-datasets, each for a specific year. Applied to the variable `lifeExp`, `min_rank()` returns the rank of each country's observed life expectancy. FYI, the `min` part just specifies how ties are broken. Here is an explicit peek at these within-year life expectancy ranks, in both the (default) ascending and descending order.

For concreteness, I use `mutate()` to actually create these variables, even though I dropped this in the solution above. Let's look at a bit of that.


```r
asia %>%
  mutate(le_rank = min_rank(lifeExp),
         le_desc_rank = min_rank(desc(lifeExp))) %>% 
  filter(country %in% c("Afghanistan", "Japan", "Thailand"), year > 1995)
#> # A tibble: 9 x 5
#> # Groups:   year [3]
#>    year country     lifeExp le_rank le_desc_rank
#>   <int> <fct>         <dbl>   <int>        <int>
#> 1  1997 Afghanistan    41.8       1           33
#> 2  2002 Afghanistan    42.1       1           33
#> 3  2007 Afghanistan    43.8       1           33
#> 4  1997 Japan          80.7      33            1
#> 5  2002 Japan          82        33            1
#> 6  2007 Japan          82.6      33            1
#> 7  1997 Thailand       67.5      12           22
#> 8  2002 Thailand       68.6      12           22
#> 9  2007 Thailand       70.6      12           22
```

Afghanistan tends to present 1's in the `le_rank` variable, Japan tends to present 1's in the `le_desc_rank` variable and other countries, like Thailand, present less extreme ranks.

You can understand the original `filter()` statement now:


```r
filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2)
```

These two sets of ranks are formed on-the-fly, within year group, and `filter()` retains rows with rank less than 2, which means ... the row with rank = 1. Since we do for ascending and descending ranks, we get both the min and the max.

If we had wanted just the min OR the max, an alternative approach using `top_n()` would have worked.


```r
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  #top_n(1, wt = lifeExp)        ## gets the min
  top_n(1, wt = desc(lifeExp)) ## gets the max
#> # A tibble: 12 x 3
#> # Groups:   year [12]
#>     year country     lifeExp
#>    <int> <fct>         <dbl>
#>  1  1952 Afghanistan    28.8
#>  2  1957 Afghanistan    30.3
#>  3  1962 Afghanistan    32.0
#>  4  1967 Afghanistan    34.0
#>  5  1972 Afghanistan    36.1
#>  6  1977 Cambodia       31.2
#>  7  1982 Afghanistan    39.9
#>  8  1987 Afghanistan    40.8
#>  9  1992 Afghanistan    41.7
#> 10  1997 Afghanistan    41.8
#> 11  2002 Afghanistan    42.1
#> 12  2007 Afghanistan    43.8
```

## Grand Finale

So let's answer that "simple" question: which country experienced the sharpest 5-year drop in life expectancy? Recall that this excerpt of the Gapminder data only has data every five years, e.g. for 1952, 1957, etc. So this really means looking at life expectancy changes between adjacent timepoints.

At this point, that's just too easy, so let's do it by continent while we're at it.


```r
my_gap %>%
  select(country, year, continent, lifeExp) %>%
  group_by(continent, country) %>%
  ## within country, take (lifeExp in year i) - (lifeExp in year i - 1)
  ## positive means lifeExp went up, negative means it went down
  mutate(le_delta = lifeExp - lag(lifeExp)) %>% 
  ## within country, retain the worst lifeExp change = smallest or most negative
  summarize(worst_le_delta = min(le_delta, na.rm = TRUE)) %>% 
  ## within continent, retain the row with the lowest worst_le_delta
  top_n(-1, wt = worst_le_delta) %>% 
  arrange(worst_le_delta)
#> `summarise()` regrouping output by 'continent' (override with `.groups` argument)
#> # A tibble: 5 x 3
#> # Groups:   continent [5]
#>   continent country     worst_le_delta
#>   <fct>     <fct>                <dbl>
#> 1 Africa    Rwanda             -20.4  
#> 2 Asia      Cambodia            -9.10 
#> 3 Americas  El Salvador         -1.51 
#> 4 Europe    Montenegro          -1.46 
#> 5 Oceania   Australia            0.170
```

Ponder that for a while. The subject matter and the code. Mostly you're seeing what genocide looks like in dry statistics on average life expectancy.

Break the code into pieces, starting at the top, and inspect the intermediate results. That's certainly how I was able to *write* such a thing. These commands do not [leap fully formed out of anyone's forehead](https://tinyurl.com/athenaforehead) -- they are built up gradually, with lots of errors and refinements along the way. I'm not even sure it's a great idea to do so much manipulation in one fell swoop. Is the statement above really hard for you to read? If yes, then by all means break it into pieces and make some intermediate objects. Your code should be easy to write and read when you're done.

In later tutorials, we'll explore more of dplyr, such as operations based on two datasets.

## Resources

[dplyr] official stuff:

* Package home [on CRAN][dplyr-cran].
  - Note there are several vignettes, with the [Introduction to dplyr] being the most relevant right now.
  - The [Window functions] one will also be interesting to you now.
* Development home [on GitHub][dplyr-github].
* [Tutorial HW delivered][useR-2014-dropbox] (note this links to a DropBox folder) at useR! 2014 conference.     
    
[RStudio Data Transformation Cheat Sheet], covering dplyr. Remember you can get to these via *Help > Cheatsheets.* 

[Data transformation][r4ds-transform] chapter of [R for Data Science] [@wickham2016].

<!--TODO: This should probably be updated with something more recent-->
["Let the Data Flow: Pipelines in R with dplyr and magrittr"] - Excellent slides on pipelines and dplyr by TJ Mahr, talk given to the Madison R Users Group.

<!--TODO: This should probably be updated with something more recent-->
Blog post ["Hands-on dplyr tutorial for faster data manipulation in R"] by Data School, that includes a link to an R Markdown document and links to videos.

Chapter \@ref(join-cheatsheet) - cheatsheet I made for dplyr join functions (not relevant yet but soon).


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
