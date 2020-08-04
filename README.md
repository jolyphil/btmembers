# btmembers

## Overview

The Bundestag distributes [biographical data](https://www.bundestag.de/services/opendata/) on all members of the Bundestag since 1949. This data, however, is only available in XML, a format difficult to work with for most social  scientists. This R package downloads the file "Stammdaten aller Abgeordneten seit 1949 im XML-Format," converts it to a data frame, and recodes some of the variables. The output is a longitudinal dataset, where the level analysis is a member-term. 

## Installation
``` r
# install.packages("devtools")
devtools::install_github("jolyphil/btmembers")
```

## Installation

btmembers only has a single function: `import_members()`. To load the data to a data frame, simply proceed as follows:

``` r
members <- import_members()
```
