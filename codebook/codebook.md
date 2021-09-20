{_btmembers_}

# Data on All Members of the Bundestag since 1949: Codebook

Version: 2021-03-12

The btmembers R package restructures the open data provided by the Bundestag. See:

> Bundestag (2021), _Stammdaten aller Abgeordneten seit 1949 im XML-Format_, version: 2021-03-12. https://www.bundestag.de/services/opendata

By default, the function `import_members()` returns a list containing four data frames: `namen` (names), `bio` (biographical information), `wp` (parliamentary terms), and `inst` (institutions). These four data frames are presented below.

---

## Data frame `namen`
`namen` contains 4363 observations from 4089 members of the Bundestag. It includes 10 variables:

### `id`

**Class**: character

**Label**: Identifikationsnummer

### `nachname`

**Class**: character

**Label**: Nachname

### `vorname`

**Class**: character

**Label**: Vorname

### `ortszusatz`

**Class**: character

**Label**: Ortszusatz zu Nachmame, zur Unterscheidung bei Namensgleichheit

### `adel`

**Class**: character

**Label**: Adelsprädikat

### `praefix`

**Class**: character

**Label**: Namenspräfix

### `anrede_titel`

**Class**: character

**Label**: Anrede-Titel

### `akad_titel`

**Class**: character

**Label**: Akademischer Titel

### `historie_von`

**Class**: Date

**Label**: Historie zu den Namensbestandteilen, gültig von

### `historie_bis`

**Class**: Date

**Label**: Historie zu den Namensbestandteilen, gültig bis

---

## Data frame `bio`
`bio` contains 4089 observations from 4089 members of the Bundestag. It includes 12 variables:

### `id`

**Class**: character

**Label**: Identifikationsnummer

### `geburtsdatum`

**Class**: Date

**Label**: Geburtsdatum

### `geburtsort`

**Class**: character

**Label**: Geburtsort

### `geburtsland`

**Class**: character

**Label**: Geburtsland

### `sterbedatum`

**Class**: Date

**Label**: Sterbedatum

### `geschlecht`

**Class**: character

**Label**: Geschlecht

### `familienstand`

**Class**: character

**Label**: Familienstand

### `religion`

**Class**: character

**Label**: Religion

### `beruf`

**Class**: character

**Label**: Beruf

### `partei_kurz`

**Class**: character

**Label**: Letzte Parteizugehörigkeit, kurzform

### `vita_kurz`

**Class**: character

**Label**: Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)

### `veroeffentlichungspflichtiges`

**Class**: character

**Label**: Veröffentlichungspflichtige Angaben (nur aktuelle Wahlperiode)

---

## Data frame `wp`
`wp` contains 11627 observations from 4089 members of the Bundestag. It includes 9 variables:

### `id`

**Class**: character

**Label**: Identifikationsnummer

### `wp`

**Class**: integer

**Label**: Nummer der Wahlperiode

### `mdbwp_von`

**Class**: Date

**Label**: Beginn der Wahlperiodenzugehörigkeit

### `mdbwp_bis`

**Class**: Date

**Label**: Ende der Wahlperiodenzugehörigkeit

### `wkr_nummer`

**Class**: integer

**Label**: Nummer des Wahlkreises

### `wkr_name`

**Class**: character

**Label**: Wahlkreisname

### `wkr_land`

**Class**: character

**Label**: Bundesland des Wahlkreises

### `liste`

**Class**: character

**Label**: Liste

### `mandatsart`

**Class**: character

**Label**: Art des Mandates

---

## Data frame `inst`
`inst` contains 15858 observations from 4089 members of the Bundestag. It includes 9 variables:

### `id`

**Class**: character

**Label**: Identifikationsnummer

### `wp`

**Class**: integer

**Label**: Nummer der Wahlperiode

### `insart_lang`

**Class**: character

**Label**: Langbezeichnung der Institutionsart

### `ins_lang`

**Class**: character

**Label**: Langbezeichnung der Institution

### `mdbins_von`

**Class**: Date

**Label**: Beginn der Institutionszugehörigkeit

### `mdbins_bis`

**Class**: Date

**Label**: Ende der Institutionszugehörigkeit

### `fkt_lang`

**Class**: character

**Label**: Langbezeichnung der ausgeübten Funktion in einer Institution

### `fktins_von`

**Class**: Date

**Label**: Beginn der Funktionsausübung in einer Institution

### `fktins_bis`

**Class**: Date

**Label**: Ende der Funktionsausübung in einer Institution

---

If `import_members()` is called with the argument `condensed_df = TRUE`, the function will return a condensed data frame. Each row corresponds to a member-term. Most of the information contained in the original data is preserved except _only the most recent name of the member is retained_ and _institutions are removed_. A new column named `fraktion` is added to the data. `fraktion` is a recoded variable and refers to the faction the member spent most time in during a given parliamentary term.
