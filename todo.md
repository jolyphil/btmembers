# To do

## Recode as factor variables

* `geschlecht`
* `familienstand`
  - How to combine categories?
  - Create two variables: partner and children?
  - How to handle missing values?
* `religion`
  - How to combine categories?
* `partei_kurz`
  - How to handle parties that changed names (e.g. die Grünen)
* `wkr_land`
* `Liste`
* `mandatsart`
  
  
## Recode place of birth
  
* `geburtsland`: Recode as ISO-3C?
  - Missing values correspond to DEU, but not always.
  - What to do with old German territories: Pommern, Sudetenland, etc.
* `geburtsort`: Inconsistent record (city OR city / Bundesland)
* Consider recoding location of birth/death as geocodes. 


## Add notes in extended codebook

* Explain special cases in additional notes inside the codebook. 


## GitHub Actions

* Use GitHub Actions to update data version. 


## Tests

* Create tests for the package. 
  - Test for new variables
  - Test for impossible values
  - Test for missings
