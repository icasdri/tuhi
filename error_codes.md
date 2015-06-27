## Error Codes (Tuhi Server Synchronization API)
See other parts of the API documentation for when these error codes are used (in responses, etc).

* **-99**: *Unknown*: an unknown error occurred
* **-2**: *Bad JSON*: JSON parsing failed
* **11**: *Missing*: given field is missing
* **12**: *Incorrect type*: given field is of incorrect type (in case of top-levels, is not list)
* **21**: *Too long*: given field (probably a string field) has exceeded a maximum allowable length
* **23**: *Invalid Date*: given date field is not sane
* **31**: *Invalid UUID*: given id field is of string type but is not of length 36 and formatted as a uuid (with `-` in the correct places)
* **32**: *UUID Conflict*: how does this happen?! -- this error will only be detectable on `note_content` (which are immutable); if so, client must regenerate a UUID for that `note_content`
* **90**: *Forbidden*: authenticated user is not authorized to access the resource (see *Forbidden* section of [Authentication](https://github.com/icasdri/tuhi/blob/master/authentication.md) for details)
* **91**: *User Does Not Exist*: given username for authentication does not exist
* **92**: *Password incorrect*: given password is incorrect for the given username