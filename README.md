
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

### Importing a list with all the information from the Bundestag

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
multiple terms (N<sub>functions</sub> &gt; N<sub>terms</sub> &gt;
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

Instead of importing a list with all the information from Bundestag,
`import_members()` can also load a condensed data frame. Each row
corresponds to a member-term. Most of the information contained in the
original data is preserved except only the most recent name of the
member is retained and institutions are removed. A new column named
`fraktion` is added to the data. `fraktion` is a recoded variable and
refers to the faction the member spent most time in during a given
parliamentary term.

``` r
members_df <- import_members(condensed_df = TRUE)
#> Downloading pre-processed data (version: 2021-03-12) from GitHub
#> Converting list to data frame...
#> Done.
members_df[c("nachname", "vorname", "wp", "fraktion")]
#> # A tibble: 11,627 x 4
#>    nachname  vorname    wp fraktion                                             
#>    <chr>     <chr>   <int> <chr>                                                
#>  1 Abelein   Manfred     5 Fraktion der Christlich Demokratischen Union/Christl…
#>  2 Abelein   Manfred     6 Fraktion der Christlich Demokratischen Union/Christl…
#>  3 Abelein   Manfred     7 Fraktion der Christlich Demokratischen Union/Christl…
#>  4 Abelein   Manfred     8 Fraktion der Christlich Demokratischen Union/Christl…
#>  5 Abelein   Manfred     9 Fraktion der Christlich Demokratischen Union/Christl…
#>  6 Abelein   Manfred    10 Fraktion der Christlich Demokratischen Union/Christl…
#>  7 Abelein   Manfred    11 Fraktion der Christlich Demokratischen Union/Christl…
#>  8 Achenbach Ernst       3 Fraktion der Freien Demokratischen Partei            
#>  9 Achenbach Ernst       4 Fraktion der Freien Demokratischen Partei            
#> 10 Achenbach Ernst       5 Fraktion der Freien Demokratischen Partei            
#> # … with 11,617 more rows
```

### Joining data frames

You can join data frames by `id` (the members’ identification numbers)
and/or `wp` (the parliamentary terms).

``` r
library(dplyr)
library(magrittr)

x <- members$namen %>%
  group_by(id) %>%
  slice_max(historie_von) %>% # keep most recent name
  ungroup() %>%
  left_join(members$bio, by = "id") %>%
  left_join(members$wp, by = "id") %>%
  left_join(members$inst, by = c("id", "wp")) %>%
  select(nachname, vorname, wp, ins_lang, mdbins_von, mdbins_bis)
```

## CSV version

A CSV version of the dataset is available [here](csv/).

## Codebook

A codebook for the four data frames is available
[here](codebook/codebook.pdf).

## Citation

To cite btmembers in publications use:

    #> 
    #> To cite package 'btmembers' in publications use:
    #> 
    #>   Philippe Joly (2021). btmembers: Import Data on All Members of the
    #>   Bundestag since 1949. R package version 0.0.2.9000.
    #>   https://github.com/jolyphil/btmembers
    #> 
    #> Une entrée BibTeX pour les utilisateurs LaTeX est
    #> 
    #>   @Manual{,
    #>     title = {btmembers: Import Data on All Members of the Bundestag since 1949},
    #>     author = {Philippe Joly},
    #>     year = {2021},
    #>     note = {R package version 0.0.2.9000},
    #>     url = {https://github.com/jolyphil/btmembers},
    #>   }
