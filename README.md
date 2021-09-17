
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

You can install the development version of btmembers from GitHub with:

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

#### Data frame `namen`

The data frame `namen` contains data on names of members of the
Bundestag. Each row represents a name. Members can have multiple names
(N<sub>names</sub> &gt; N<sub>members</sub>).

``` r
head(members$namen)
#> # A tibble: 6 x 10
#>   id       nachname  vorname   ortszusatz adel  praefix anrede_titel akad_titel
#>   <chr>    <chr>     <chr>     <chr>      <chr> <chr>   <chr>        <chr>     
#> 1 11000001 Abelein   Manfred   <NA>       <NA>  <NA>    Dr.          Prof. Dr. 
#> 2 11000002 Achenbach Ernst     <NA>       <NA>  <NA>    Dr.          Dr.       
#> 3 11000003 Ackermann Annemarie <NA>       <NA>  <NA>    <NA>         <NA>      
#> 4 11000004 Ackermann Else      <NA>       <NA>  <NA>    Dr.          Dr.       
#> 5 11000005 Adam      Ulrich    <NA>       <NA>  <NA>    <NA>         <NA>      
#> 6 11000007 Adams     Rudolf    <NA>       <NA>  <NA>    <NA>         <NA>      
#> # … with 2 more variables: historie_von <date>, historie_bis <date>
```

#### Data frame `bio`

The data frame `bio` contains biographical information on members. Each
row represents a biographical entry. There is one entry by member
(N<sub>bio</sub> = N<sub>members</sub>).

``` r
head(members$bio)
#> # A tibble: 6 x 12
#>   id    geburtsdatum geburtsort geburtsland sterbedatum geschlecht familienstand
#>   <chr> <date>       <chr>      <chr>       <date>      <chr>      <chr>        
#> 1 1100… 1930-10-20   Stuttgart  <NA>        2008-01-17  männlich   keine Angaben
#> 2 1100… 1909-04-09   Siegen     <NA>        1991-12-02  männlich   verheiratet,…
#> 3 1100… 1913-05-26   Parabutsch Jugoslawien 1994-02-18  weiblich   verheiratet,…
#> 4 1100… 1933-11-06   Berlin     <NA>        2019-09-14  weiblich   ledig        
#> 5 1100… 1950-06-09   Teterow, … <NA>        NA          männlich   verheiratet,…
#> 6 1100… 1919-11-10   Masburg /… <NA>        2013-05-25  männlich   verheiratet,…
#> # … with 5 more variables: religion <chr>, beruf <chr>, partei_kurz <chr>,
#> #   vita_kurz <chr>, veroeffentlichungspflichtiges <chr>
```

#### Data frame `wp`

The data frame `wp` contains data on parliamentary terms served by
members. Each row represents a member-term. Many members have served
multiple terms (N<sub>terms</sub> &gt; N<sub>members</sub>).

``` r
head(members$wp)
#> # A tibble: 6 x 9
#>   id          wp mdbwp_von  mdbwp_bis  wkr_nummer wkr_name wkr_land liste
#>   <chr>    <int> <date>     <date>          <int> <chr>    <chr>    <chr>
#> 1 11000001     5 1965-10-19 1969-10-19        174 <NA>     BWG      <NA> 
#> 2 11000001     6 1969-10-20 1972-09-22        174 <NA>     BWG      <NA> 
#> 3 11000001     7 1972-12-13 1976-12-13        174 <NA>     BWG      <NA> 
#> 4 11000001     8 1976-12-14 1980-11-04        174 <NA>     BWG      <NA> 
#> 5 11000001     9 1980-11-04 1983-03-29        174 <NA>     BWG      <NA> 
#> 6 11000001    10 1983-03-29 1987-02-18        174 <NA>     BWG      <NA> 
#> # … with 1 more variable: mandatsart <chr>
```

#### Data frame `inst`

The data frame `inst` contains records on functions occupied by members
inside institutions of the Bundestag. Each row represents a
member-term-function. Members might have had multiple functions during
the same term (N<sub>functions</sub> &gt; N<sub>terms</sub> &gt;
N<sub>members</sub>).

``` r
head(members$inst)
#> # A tibble: 6 x 9
#>   id        wp insart_lang ins_lang    mdbins_von mdbins_bis fkt_lang fktins_von
#>   <chr>  <int> <chr>       <chr>       <date>     <date>     <chr>    <date>    
#> 1 11000…     5 Fraktion/G… Fraktion d… 1965-10-19 1969-10-19 <NA>     NA        
#> 2 11000…     6 Fraktion/G… Fraktion d… 1969-10-20 1972-09-22 <NA>     NA        
#> 3 11000…     7 Fraktion/G… Fraktion d… 1972-12-13 1976-12-13 <NA>     NA        
#> 4 11000…     8 Fraktion/G… Fraktion d… 1976-12-14 1980-11-04 <NA>     NA        
#> 5 11000…     9 Fraktion/G… Fraktion d… 1980-11-04 1983-03-29 <NA>     NA        
#> 6 11000…    10 Fraktion/G… Fraktion d… 1983-03-29 1987-02-18 <NA>     NA        
#> # … with 1 more variable: fktins_bis <date>
```

### Importing a condensed data frame

Instead of importing a list with all the information from the Bundestag,
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
head(members_df[c("nachname", "vorname", "wp", "fraktion")])
#> # A tibble: 6 x 4
#>   nachname vorname    wp fraktion                                               
#>   <chr>    <chr>   <int> <chr>                                                  
#> 1 Abelein  Manfred     5 Fraktion der Christlich Demokratischen Union/Christlic…
#> 2 Abelein  Manfred     6 Fraktion der Christlich Demokratischen Union/Christlic…
#> 3 Abelein  Manfred     7 Fraktion der Christlich Demokratischen Union/Christlic…
#> 4 Abelein  Manfred     8 Fraktion der Christlich Demokratischen Union/Christlic…
#> 5 Abelein  Manfred     9 Fraktion der Christlich Demokratischen Union/Christlic…
#> 6 Abelein  Manfred    10 Fraktion der Christlich Demokratischen Union/Christlic…
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
  select(nachname, vorname, wp, ins_lang, mdbins_von, mdbins_bis) %>%
  head()
```

## CSV version

Not an R user? You can also download the different datasets as CSV files
[here](csv/).

## Codebook

A codebook for the four data frames is available
[here](codebook/codebook.pdf).

## Citation

To cite the btmembers package in publications use:

To cite package ‘btmembers’ in publications use:

Philippe Joly (2021). btmembers: Import Data on All Members of the
Bundestag since 1949. R package version 0.0.2.9000.
<https://github.com/jolyphil/btmembers>

Une entrée BibTeX pour les utilisateurs LaTeX est

@Manual{, title = {btmembers: Import Data on All Members of the
Bundestag since 1949}, author = {Philippe Joly}, year = {2021}, note =
{R package version 0.0.2.9000}, url =
{<https://github.com/jolyphil/btmembers>}, }

The package should be cited with the original source:

> Bundestag. (2021). *Stammdaten aller Abgeordneten seit 1949 im
> XML-Format*. <https://www.bundestag.de/services/opendata>
