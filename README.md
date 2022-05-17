# FellowshipOfTheChing
 A project tracking the 37th/38th joint running extravaganza
 If you have found this repo and know what it is, you are likely looking for the content in /Writing/Weekly/

## Structure
 * /Writing/ Contains the all writeups
    * /Weekly are the week-by-week reviews for the writeups. These should be knit to .md for github use
    * /Vis generates a quick HTML output of the common graphs to select for the week. This is mostly a quick overview for use in writing
 * /Code/ Contains the R code and the include file that gets loaded from .Rprofile and manually in the writeups
    * Clean_RawLog.R is the most important script here and references Data/RawMessages.csv, which is **OMITTED**. See data for details
 * /Data/ mainly contains the .csv conversion of the raw discord chat history. The raw version is **OMITTED** by the .gitignore for obvious reason.
    * /The raw log is generated locally and manually updated. See https://github.com/Tyrrrz/DiscordChatExporter for technical details