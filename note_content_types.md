# Tuhi Server Synchronization API #

## Note Content Types
Note Content types are signed integers composed of three sections. They are discussed in detail below.

Most types take the form *SAAABBCCC*, where
* *S* is a sign (absent for positive or '-' for negative)
* *AAA* is the three-digit content code (details below).
* *BB* is the two-digit display flag (details below).
* *CCC* is the three-digit encryption code (details below).

The **only** exception to this form, is the Note Content type '-2' which signifies that the corresponding Note has been **permanenty deleted**

#### Sign
Signs are used to signify whether a Note Content is soft-deleted, aka. trashed. (and therefore also if the Note Content is the head/most-recent Note Content, whether it's corresponding note is soft-deleted, aka. trashed)
* Positive sign (signified by an absence of sign on the integer) signifies a *normal* or *non-deleted* Note Content.
* Negative sign (signified by '-') signifies a *soft-delted* Note Content.

### Content Codes
Content codes are used to signify the actual content "type" of the note. Currently only one type is implemented, which is enumerated below.
* *100*: plain text

#### Display Flags
Display flags are used to signify certain display-specific components. Currently they are used to specify whether **word-wrap** and **spell-check** should be used when displaying the Note.
* *00*: no word-wrap. no spell-check.
* *01*: word-wrap. no spell-check.
* *02*: no word-wrap. spell-check.
* *03*: word-wrap and spell-check.

#### Encryption Codes
This code is unutilized/unimplemented as of now and shall remain '000' for all Note Contents.