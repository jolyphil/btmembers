A Dataset of All Members of the Bundestag since 1949: Codebook
================
Philippe Joly
2020-09-01

## Description

**btmembers** generates a dataset with basic biographical and election
data for all members of the Bundestag since 1949. The unit of analysis
of the dataset is a member-term. There are 11618 observations from 4084
members. The data includes 26 variables (in German):

## Variables

### `id`

**Class**: character  
**Label**: Identifikationsnummer

### `nachname`

**Class**: character  
**Label**: Nachname

### `vorname`

**Class**: character  
**Label**: Vorname

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
**Label**: Parteizugehörigkeit, kurzform

### `vita_kurz`

**Class**: character  
**Label**: Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)

### `veroeffentlichungspflichtiges`

**Class**: character  
**Label**: Veröffentlichungspflichtige Angaben (nur aktuelle
Wahlperiode)

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

## Source

Adapted from Bundestag (2020), *Stammdaten aller Abgeordneten seit 1949
im XML-Format*, version: 2020-03-12,
<https://www.bundestag.de/services/opendata>.
