A Dataset of All Members of the Bundestag since 1949: Codebook
================
Philippe Joly
2020-09-01

## Description

**btmembers** generates a dataset with basic biographical and election
data for all members of the Bundestag since 1949. The unit of analysis
of the dataset is a member-term. There are 11618 observations from 4084
members. The data includes 26 variables (in German):

## \#\# Variables

### `id`

**Class**: character  
**Label**: Identifikationsnummer

### `vorname`

**Class**: character  
**Label**: Vorname

### `praefix`

**Class**: character  
**Label**: Namenspräfix

### `akad_titel`

**Class**: character  
**Label**: Akademischer Titel

### `geburtsort`

**Class**: character  
**Label**: Geburtsort

### `sterbedatum`

**Class**: Date  
**Label**: Sterbedatum

### `familienstand`

**Class**: character  
**Label**: Familienstand

### `beruf`

**Class**: character  
**Label**: Beruf

### `vita_kurz`

**Class**: character  
**Label**: Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)

### `wp`

**Class**: integer  
**Label**: Nummer der Wahlperiode

### `mdbwp_bis`

**Class**: Date  
**Label**: Ende der Wahlperiodenzugehörigkeit

### `wkr_name`

**Class**: character  
**Label**: Wahlkreisname

### `liste`

**Class**: character  
**Label**: Liste

-----

### `mandatsart`

**Class**: character  
**Label**: Art des Mandates

## Source

Adapted from Bundestag (2020), *Stammdaten aller Abgeordneten seit 1949
im XML-Format*, version: 2020-03-12,
<https://www.bundestag.de/services/opendata>.
