require(magrittr)

# Load functions ====
file.path("R", "convert_to_df.R") %>%
  source()
file.path("R", "get_var_attr.R") %>%
  source()
file.path("R", "get_varlists.R") %>%
  source()
file.path("R", "import_members_list.R") %>%
  source()

import_members <- function() {
  members_list <- import_members_list()
  varlists <- get_varlists()
  members <- convert_to_df(members_list, varlists)
  members
}
