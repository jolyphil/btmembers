# btmembers

## Import Data on All Members of the Bundestag since 1949

The Bundestag distributes [biographical data](https://www.bundestag.de/services/opendata/) on all members of the Bundestag since 1949. This data, however, is only available in XML, a format difficult to work with for most social  scientists. This R package downloads the file "Stammdaten aller Abgeordneten seit 1949 im XML-Format," converts it to a data frame, and recodes some of the variables. The output is a longitudinal dataset, where the level analysis is a member-term. 
