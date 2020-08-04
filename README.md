# btmembers

## Overview

The Bundestag distributes [biographical data](https://www.bundestag.de/services/opendata/) on all its members since 1949. This data, however, is only available in XML, a format most social scientists will find difficult to work with. The **btmembers** R package downloads the file "Stammdaten aller  Abgeordneten seit 1949 im XML-Format" from the Bundestag website, converts it to a data frame, and recodes some of the variables. The unit of analysis is a member-term. The generated dataset contains more than 11,000 observations for more than 4,000 members of the Bundestag.

## Installation
``` r
# install.packages("devtools")
devtools::install_github("jolyphil/btmembers")
```

## Usage

btmembers only has a single function: `import_members()`. To load the data to a data frame, simply proceed as follows:

``` r
library(btmembers)
members <- import_members()
```
