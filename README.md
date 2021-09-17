
<!-- README.md is generated from README.Rmd. Please edit that file -->

# btmembers

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The Bundestag distributes [biographical and election
data](https://www.bundestag.de/services/opendata/) on all its members
since 1949. This data, however, can be difficult to work with because
XML files store information in an arbitrary number of dimensions.
btmembers downloads the file “Stammdaten aller Abgeordneten seit 1949 im
XML-Format” from the Bundestag website and converts it either to (a)
four data frames nested into a list (retaining all the information of
the original XML file) or (b) a single, condensed data frame.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jolyphil/btmembers")
```

## Usage

### Preserving all the information

btmembers exports a single function: `import_members()`. By default,
this function returns a list containing four data frames (`namen`,
`bio`, `wp`, and `inst`), which together preserve all the information
contained in the XML file provided by the Bundestag.

``` r
library(btmembers)
members <- import_members()
#> Downloading pre-processed data (version: 2021-03-12) from GitHub
summary(members)
#>       Length Class  Mode
#> namen 10     tbl_df list
#> bio   12     tbl_df list
#> wp     9     tbl_df list
#> inst   9     tbl_df list
```

The data frame `namen` contains data on names of members of the
Bundestag. Each row represents a name. Members can have multiple names
(N<sub>names</sub> &gt; N<sub>members</sub>).

``` r
summary(members$namen)
#>       id              nachname           vorname           ortszusatz       
#>  Length:4363        Length:4363        Length:4363        Length:4363       
#>  Class :character   Class :character   Class :character   Class :character  
#>  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
#>                                                                             
#>                                                                             
#>                                                                             
#>                                                                             
#>      adel             praefix          anrede_titel        akad_titel       
#>  Length:4363        Length:4363        Length:4363        Length:4363       
#>  Class :character   Class :character   Class :character   Class :character  
#>  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
#>                                                                             
#>                                                                             
#>                                                                             
#>                                                                             
#>   historie_von         historie_bis       
#>  Min.   :1904-01-23   Min.   :1953-01-04  
#>  1st Qu.:1961-10-17   1st Qu.:1961-11-02  
#>  Median :1985-03-16   Median :1980-12-16  
#>  Mean   :1982-12-30   Mean   :1984-01-25  
#>  3rd Qu.:2002-10-17   3rd Qu.:2005-08-01  
#>  Max.   :2020-11-12   Max.   :2019-06-25  
#>                       NA's   :4089
```

The data frame `bio` contains biographical information on members. Each
row represents a biographical entry. There is one entry by member
(N<sub>bio</sub> = N<sub>members</sub>).

``` r
members$bio
#> # A tibble: 4,089 x 12
#>    id      geburtsdatum geburtsort            geburtsland sterbedatum geschlecht
#>    <chr>   <date>       <chr>                 <chr>       <date>      <chr>     
#>  1 110000… 1930-10-20   Stuttgart             <NA>        2008-01-17  männlich  
#>  2 110000… 1909-04-09   Siegen                <NA>        1991-12-02  männlich  
#>  3 110000… 1913-05-26   Parabutsch            Jugoslawien 1994-02-18  weiblich  
#>  4 110000… 1933-11-06   Berlin                <NA>        2019-09-14  weiblich  
#>  5 110000… 1950-06-09   Teterow, Kr. Teterow… <NA>        NA          männlich  
#>  6 110000… 1919-11-10   Masburg / Kreis Coch… <NA>        2013-05-25  männlich  
#>  7 110000… 1912-09-28   Düsseldorf            <NA>        1992-01-25  männlich  
#>  8 110000… 1876-01-05   Köln                  <NA>        1967-04-19  männlich  
#>  9 110000… 1944-06-22   Drangstedt / Krs. We… <NA>        2004-10-25  weiblich  
#> 10 110000… 1920-10-31   München               <NA>        2000-12-28  männlich  
#> # … with 4,079 more rows, and 6 more variables: familienstand <chr>,
#> #   religion <chr>, beruf <chr>, partei_kurz <chr>, vita_kurz <chr>,
#> #   veroeffentlichungspflichtiges <chr>
```

The data frame `wp` contains data on the parliamentary terms served by
the members. Each row represents a member-term. Members might have
served multiple terms (N<sub>terms</sub> &gt; N<sub>members</sub>).

``` r
members$wp
#> # A tibble: 11,627 x 9
#>    id          wp mdbwp_von  mdbwp_bis  wkr_nummer wkr_name wkr_land liste
#>    <chr>    <int> <date>     <date>          <int> <chr>    <chr>    <chr>
#>  1 11000001     5 1965-10-19 1969-10-19        174 <NA>     BWG      <NA> 
#>  2 11000001     6 1969-10-20 1972-09-22        174 <NA>     BWG      <NA> 
#>  3 11000001     7 1972-12-13 1976-12-13        174 <NA>     BWG      <NA> 
#>  4 11000001     8 1976-12-14 1980-11-04        174 <NA>     BWG      <NA> 
#>  5 11000001     9 1980-11-04 1983-03-29        174 <NA>     BWG      <NA> 
#>  6 11000001    10 1983-03-29 1987-02-18        174 <NA>     BWG      <NA> 
#>  7 11000001    11 1987-02-18 1990-12-20        174 <NA>     BWG      <NA> 
#>  8 11000002     3 1957-10-15 1961-10-15         NA <NA>     <NA>     NRW  
#>  9 11000002     4 1961-10-17 1965-10-17         NA <NA>     <NA>     NRW  
#> 10 11000002     5 1965-10-19 1969-10-19         NA <NA>     <NA>     NRW  
#> # … with 11,617 more rows, and 1 more variable: mandatsart <chr>
```

The data frame `inst` contains records on functions occupied by members
inside institutions of the Bundestag. Each row represents an
member-term-function. Members might have had multiple functions during
multiple terms (N<sub>institutions</sub> &gt; N<sub>terms</sub> &gt;
N<sub>members</sub>).

``` r
members$inst
#> # A tibble: 15,858 x 9
#>    id        wp insart_lang ins_lang   mdbins_von mdbins_bis fkt_lang fktins_von
#>    <chr>  <int> <chr>       <chr>      <date>     <date>     <chr>    <date>    
#>  1 11000…     5 Fraktion/G… Fraktion … 1965-10-19 1969-10-19 <NA>     NA        
#>  2 11000…     6 Fraktion/G… Fraktion … 1969-10-20 1972-09-22 <NA>     NA        
#>  3 11000…     7 Fraktion/G… Fraktion … 1972-12-13 1976-12-13 <NA>     NA        
#>  4 11000…     8 Fraktion/G… Fraktion … 1976-12-14 1980-11-04 <NA>     NA        
#>  5 11000…     9 Fraktion/G… Fraktion … 1980-11-04 1983-03-29 <NA>     NA        
#>  6 11000…    10 Fraktion/G… Fraktion … 1983-03-29 1987-02-18 <NA>     NA        
#>  7 11000…    11 Fraktion/G… Fraktion … 1987-02-18 1990-12-20 <NA>     NA        
#>  8 11000…     3 Fraktion/G… Fraktion … 1957-10-15 1961-10-15 <NA>     NA        
#>  9 11000…     4 Fraktion/G… Fraktion … 1961-10-17 1965-10-17 <NA>     NA        
#> 10 11000…     5 Fraktion/G… Fraktion … 1965-10-19 1969-10-19 <NA>     NA        
#> # … with 15,848 more rows, and 1 more variable: fktins_bis <date>
```

### Importing a condensed data frame

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
