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
