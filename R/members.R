#' Members of the Bundestag since 1949
#'
#' A dataset with basic biographical and election data for all members of
#' the Bundestag since 1949.
#'
#' @format A tibble with 11622 observations from 4086 members of the Bundestag.
#' It includes 26 variables (in German):
#' \describe{
#'   \item{`id`}{Identifikationsnummer}
#'   \item{`nachname`}{Nachname}
#'   \item{`vorname`}{Vorname}
#'   \item{`adel`}{Adelsprädikat}
#'   \item{`praefix`}{Namenspräfix}
#'   \item{`anrede_titel`}{Anrede-Titel}
#'   \item{`akad_titel`}{Akademischer Titel}
#'   \item{`geburtsdatum`}{Geburtsdatum}
#'   \item{`geburtsort`}{Geburtsort}
#'   \item{`geburtsland`}{Geburtsland}
#'   \item{`sterbedatum`}{Sterbedatum}
#'   \item{`geschlecht`}{Geschlecht}
#'   \item{`familienstand`}{Familienstand}
#'   \item{`religion`}{Religion}
#'   \item{`beruf`}{Beruf}
#'   \item{`partei_kurz`}{Parteizugehörigkeit, kurzform}
#'   \item{`vita_kurz`}{Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)}
#'   \item{`veroeffentlichungspflichtiges`}{Veröffentlichungspflichtige Angaben (nur aktuelle Wahlperiode)}
#'   \item{`wp`}{Nummer der Wahlperiode}
#'   \item{`mdbwp_von`}{Beginn der Wahlperiodenzugehörigkeit}
#'   \item{`mdbwp_bis`}{Ende der Wahlperiodenzugehörigkeit}
#'   \item{`wkr_nummer`}{Nummer des Wahlkreises}
#'   \item{`wkr_name`}{Wahlkreisname}
#'   \item{`wkr_land`}{Bundesland des Wahlkreises}
#'   \item{`liste`}{Liste}
#'   \item{`mandatsart`}{Art des Mandates}
#' }
#' @source Adapted from Bundestag (2020), \emph{Stammdaten aller Abgeordneten
#' seit 1949 im XML-Format}, version: 2020-08-25,
#' \url{https://www.bundestag.de/services/opendata}.
"members"
