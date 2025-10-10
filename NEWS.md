# btmembers 0.2.4

* Fix download bug: download XML and DTD files separately instead of ZIP file.
* Rely on `httr::GET` for more reliable downloads. 
* Drop `magrittr` dependency and use native pipe instead. 
* Depend on `R (>= 4.1.0)`


# btmembers 0.2.3

* Integrate changes to the `tidyselect` package.
* Adjust dependencies. 
* Fix problem with dates in Excel 


# btmembers 0.2.2

* Fix `dplyr` warning again.


# btmembers 0.2.1

* Fix `dplyr` warning.


# btmembers 0.2.0

* The `force_from_bt` argument has been deprecated and is replaced by `data_source` with three options: `"auto"`, `"Bundestag"`, or `"GitHub"`. 
* If `btmembers` finds more recent data on the Bundestag website, it will not prompt the user. 
* Instead, the package now implements an automatic test and compares the version of the documentation file (`*.DTD`) stored internally and the one on the Bundestag website. If no difference is found, `btmembers` downloads and processes the new data. 
* Missing values (ohne/keine Angabe) in the variables "FAMILIENSTAND", "RELIGION", and "BERUF" are recoded as `NA`.
* Exported CSV files no longer contain line breaks.
* The data is also exported to Excel using the `writexl` package. 


# btmembers 0.1.3

* Bug "Unable to locate XML file" was fixed.
* `btmembers` now relies on CSS instead of XPath. 


# btmembers 0.1.2

* `btmembers` does not depend on the `stringr` package anymore.
* A bug with `import_members(condensed_df = TRUE)` was fixed.


# btmembers 0.1.1

* `import_members()` now adds a user interaction if the version of the data on the Bundestag website is more recent than the version on GitHub. In this case, the user is be presented with a menu of three choices: (1) Download the new, non-tested version from the Bundestag website; (2) Download the older, pre-processed data from Github; or (3) Cancel.
* The variable `veroeffentlichungspfligtes` has been removed since it is absent from the new version of the data. 
* The documentation of `import_members()` has been changed to include a link to the codebook instead of a list of variables. 


# btmembers 0.1.0

* By default, `import_members()` now returns a list containing four data frames (`namen`, `bio`, `wp`, and `inst`), which together preserve all the information contained in the XML file provided by the Bundestag.
* If `import_members()` is called with the argument `condensed_df = TRUE`, the function will return a condensed data frame. Each row corresponds to a member-term. Most of the information contained in the original data is preserved except _only the most recent name of the member is retained_ and _institutions are removed_. A new column named `fraktion` is added to the data. `fraktion` is a recoded variable and refers to the faction the member spent most time in during a given parliamentary term. This fixes the issue that `partei_kurz` only refers to the last party affiliation of the member (#1).
* The performance of `import_members()` is improved by the integration of tidyr unnest functions. 
* The package does not come preloaded with the data anymore but uses GitHub to store the pre-processed data. This facilitates updates and will make the integration of GitHub Actions possible in the future. 
* `update_available()` is deprecated. 
