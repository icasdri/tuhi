## Error Codes (Tuhi Server Synchronization API)
See other parts of the API documentation for when these error codes are used (in responses, etc).

* **-99**: *Unknown*: an unknown error occurred
* **-2**: *Bad JSON*: JSON parsing failed
* **11**: *Missing*: given field is missing
* **12**: *Incorrect type*: given field is of incorrect type (in case of top-levels, is not list)
* **18**: *Resource Does Not Exist*: given resource referenced by field does not exist (e.g. when a `note_content` references a `note` that does not exist)
* **19**: *Resource Already Exists (Conflict)*: given resource already exists and is not allowed to be updated (e.g. `note_content`s cannot be updated as they are immutable)
* **21**: *Too long*: given field (probably a string field) has exceeded a maximum allowable length
* **23**: *Invalid Date*: given date field is not sane
* **32**: *UUID Conflict*: how does this happen?! -- this error will only be detectable on `note_content` (which are immutable); if so, client must regenerate a UUID for that `note_content`
* **90**: *Forbidden*: authenticated user is not authorized to access the resource (see *Forbidden* section of [Authentication](https://github.com/icasdri/tuhi/blob/master/authentication.md) for details)
* **92**: *Password incorrect*: given password is incorrect for the given username