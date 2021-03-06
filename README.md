# btmembers

## Overview

The Bundestag distributes [biographical and election data](https://www.bundestag.de/services/opendata/) on all its members since 1949. This data, however, is only available in XML, a format most social scientists will find difficult to work with. **btmembers** downloads the file "Stammdaten aller Abgeordneten seit 1949 im XML-Format" from the Bundestag website, converts it to a data frame, and recodes some of the variables. The unit of analysis is a member-term. The generated dataset contains more than 11,000 observations for more than 4,000 members of the Bundestag.

## Installation
``` r
# install.packages("devtools")
devtools::install_github("jolyphil/btmembers")
```

## Usage

btmembers comes preloaded with the tabular dataset. To retrieve the data, simply proceed as follows:

``` r
library(btmembers)
members
```

The associated help page presents information on the preloaded version of the dataset and provides a basic codebook.

``` r
?members
```

btmembers allows you to check if a more recent version of the data is available on the bundestag website.

``` r
update_available()
```

If `update_available()` returns TRUE, you can import a more recent version of the dataset using `import_members()`.

``` r
members_new <- import_members()
```

This operation, however, is not guaranteed to work since the Bundestag might occasionally change the structure of the source XML file. If you encounter problems using `import_members()`, consider creating an [issue on GitHub](https://github.com/jolyphil/btmembers/issues).

## CSV version

A CSV version of the dataset is available [here](csv/).

## Codebook

A codebook of the dataset in PDF format is available [here](codebook/codebook.pdf).

## Citation

To cite btmembers in publications use:

> Philippe Joly (2020). btmembers: Import Data on All Members of the Bundestag since 1949. R package version 0.0.1. <https://github.com/jolyphil/btmembers>

A BibTeX entry for LaTeX users is

```
  @Manual{,
    title = {btmembers: Import Data on All Members of the Bundestag since 1949},
    author = {Philippe Joly},
    year = {2020},
    note = {R package version 0.0.2},
    url = {https://github.com/jolyphil/btmembers},
  }
```
