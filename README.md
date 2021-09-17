
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

btmembers exports a single function: `import_members()`. By default,
this function returns a list containing all the information contained in
the XML file provided by the Bundestag but in a more practical format.

``` r
library(btmembers)
members <- import_members()
#> Downloading pre-processed data (version: 2021-03-12) from GitHub
str(members)
#> List of 4
#>  $ namen: tibble [4,363 × 10] (S3: tbl_df/tbl/data.frame)
#>   ..$ id          : chr [1:4363] "11000001" "11000002" "11000003" "11000004" ...
#>   .. ..- attr(*, "label")= chr "Identifikationsnummer"
#>   ..$ nachname    : chr [1:4363] "Abelein" "Achenbach" "Ackermann" "Ackermann" ...
#>   .. ..- attr(*, "label")= chr "Nachname"
#>   ..$ vorname     : chr [1:4363] "Manfred" "Ernst" "Annemarie" "Else" ...
#>   .. ..- attr(*, "label")= chr "Vorname"
#>   ..$ ortszusatz  : chr [1:4363] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Ortszusatz zu Nachmame, zur Unterscheidung bei Namensgleichheit"
#>   ..$ adel        : chr [1:4363] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Adelsprädikat"
#>   ..$ praefix     : chr [1:4363] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Namenspräfix"
#>   ..$ anrede_titel: chr [1:4363] "Dr." "Dr." NA "Dr." ...
#>   .. ..- attr(*, "label")= chr "Anrede-Titel"
#>   ..$ akad_titel  : chr [1:4363] "Prof. Dr." "Dr." NA "Dr." ...
#>   .. ..- attr(*, "label")= chr "Akademischer Titel"
#>   ..$ historie_von: Date[1:4363], format: "1965-10-19" "1957-10-15" ...
#>   ..$ historie_bis: Date[1:4363], format: NA NA ...
#>  $ bio  : tibble [4,089 × 12] (S3: tbl_df/tbl/data.frame)
#>   ..$ id                           : chr [1:4089] "11000001" "11000002" "11000003" "11000004" ...
#>   .. ..- attr(*, "label")= chr "Identifikationsnummer"
#>   ..$ geburtsdatum                 : Date[1:4089], format: "1930-10-20" "1909-04-09" ...
#>   ..$ geburtsort                   : chr [1:4089] "Stuttgart" "Siegen" "Parabutsch" "Berlin" ...
#>   .. ..- attr(*, "label")= chr "Geburtsort"
#>   ..$ geburtsland                  : chr [1:4089] NA NA "Jugoslawien" NA ...
#>   .. ..- attr(*, "label")= chr "Geburtsland"
#>   ..$ sterbedatum                  : Date[1:4089], format: "2008-01-17" "1991-12-02" ...
#>   ..$ geschlecht                   : chr [1:4089] "männlich" "männlich" "weiblich" "weiblich" ...
#>   .. ..- attr(*, "label")= chr "Geschlecht"
#>   ..$ familienstand                : chr [1:4089] "keine Angaben" "verheiratet, 3 Kinder" "verheiratet, 5 Kinder" "ledig" ...
#>   .. ..- attr(*, "label")= chr "Familienstand"
#>   ..$ religion                     : chr [1:4089] "katholisch" "evangelisch" "katholisch" "evangelisch" ...
#>   .. ..- attr(*, "label")= chr "Religion"
#>   ..$ beruf                        : chr [1:4089] "Rechtsanwalt, Wirtschaftsprüfer, Universitätsprofessor" "Rechtsanwalt und Notar" "Hilfsreferentin" "Ärztin" ...
#>   .. ..- attr(*, "label")= chr "Beruf"
#>   ..$ partei_kurz                  : chr [1:4089] "CDU" "FDP" "CDU" "CDU" ...
#>   .. ..- attr(*, "label")= chr "Letzte Parteizugehörigkeit, kurzform"
#>   ..$ vita_kurz                    : chr [1:4089] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)"
#>   ..$ veroeffentlichungspflichtiges: chr [1:4089] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Veröffentlichungspflichtige Angaben (nur aktuelle Wahlperiode)"
#>  $ wp   : tibble [11,627 × 9] (S3: tbl_df/tbl/data.frame)
#>   ..$ id        : chr [1:11627] "11000001" "11000001" "11000001" "11000001" ...
#>   .. ..- attr(*, "label")= chr "Identifikationsnummer"
#>   ..$ wp        : int [1:11627] 5 6 7 8 9 10 11 3 4 5 ...
#>   .. ..- attr(*, "label")= chr "Nummer der Wahlperiode"
#>   ..$ mdbwp_von : Date[1:11627], format: "1965-10-19" "1969-10-20" ...
#>   ..$ mdbwp_bis : Date[1:11627], format: "1969-10-19" "1972-09-22" ...
#>   ..$ wkr_nummer: int [1:11627] 174 174 174 174 174 174 174 NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Nummer des Wahlkreises"
#>   ..$ wkr_name  : chr [1:11627] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Wahlkreisname"
#>   ..$ wkr_land  : chr [1:11627] "BWG" "BWG" "BWG" "BWG" ...
#>   .. ..- attr(*, "label")= chr "Bundesland des Wahlkreises"
#>   ..$ liste     : chr [1:11627] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Liste"
#>   ..$ mandatsart: chr [1:11627] "Direktwahl" "Direktwahl" "Direktwahl" "Direktwahl" ...
#>   .. ..- attr(*, "label")= chr "Art des Mandates"
#>  $ inst : tibble [15,858 × 9] (S3: tbl_df/tbl/data.frame)
#>   ..$ id         : chr [1:15858] "11000001" "11000001" "11000001" "11000001" ...
#>   .. ..- attr(*, "label")= chr "Identifikationsnummer"
#>   ..$ wp         : int [1:15858] 5 6 7 8 9 10 11 3 4 5 ...
#>   .. ..- attr(*, "label")= chr "Nummer der Wahlperiode"
#>   ..$ insart_lang: chr [1:15858] "Fraktion/Gruppe" "Fraktion/Gruppe" "Fraktion/Gruppe" "Fraktion/Gruppe" ...
#>   .. ..- attr(*, "label")= chr "Langbezeichnung der Institutionsart"
#>   ..$ ins_lang   : chr [1:15858] "Fraktion der Christlich Demokratischen Union/Christlich - Sozialen Union" "Fraktion der Christlich Demokratischen Union/Christlich - Sozialen Union" "Fraktion der Christlich Demokratischen Union/Christlich - Sozialen Union" "Fraktion der Christlich Demokratischen Union/Christlich - Sozialen Union" ...
#>   .. ..- attr(*, "label")= chr "Langbezeichnung der Institution"
#>   ..$ mdbins_von : Date[1:15858], format: "1965-10-19" "1969-10-20" ...
#>   ..$ mdbins_bis : Date[1:15858], format: "1969-10-19" "1972-09-22" ...
#>   ..$ fkt_lang   : chr [1:15858] NA NA NA NA ...
#>   .. ..- attr(*, "label")= chr "Langbezeichnung der ausgeübten Funktion in einer Institution"
#>   ..$ fktins_von : Date[1:15858], format: NA NA ...
#>   ..$ fktins_bis : Date[1:15858], format: NA NA ...
#>  - attr(*, "version")= Date[1:1], format: "2021-03-12"
```

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
