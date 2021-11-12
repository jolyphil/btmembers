# Releasing a new version  
- Run `devtools::load_all()`
- Run `devtools::document()`
- Examine functions and documentation.
- Modify `DESCRIPTION`
  - Increment version number
  - Change date
  - Revise `description` if needed.
- Run `devtools::check()`
- Commit changes to git branch `develop`
