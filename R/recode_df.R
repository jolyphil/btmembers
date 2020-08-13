recode_df <- function(members_df, data_version){
  attr(members_df, "version") <- data_version
  members_df
}
