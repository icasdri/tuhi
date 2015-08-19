# Tuhi Server Responses (Tuhi Server Synchronization API)#

## Endpoint `POST /notes`
#### HTTP Responses
**HTTP 200 OK**: SUCCESS!

**HTTP 400 Bad Request**: 
* *Response with No Body*: Malformed JSON
* *Response with Body with JSON*: signifies a **Top-level Error**

**HTTP 202 Accepted**: signifies a **Sub-unit Error** 

### Top-level Errors
Occurs when top-level `"notes"` and `"note_contents"` fields missing or point to object of incorrect type (i.e. not list) -- data does not resemble `{"notes":[], "note_contents":[]}` at the most basic level

Response will have general structure:
```json
{
	"notes_errors": ERROR_CODE,
    "note_contents_errors": ERROR_CODE
}
```
where `ERROR_CODE` is one of the error codes listed at [Error Codes](https://github.com/icasdri/tuhi/blob/master/error_codes.md) that is relevant, and where a suffix `_errors` denotes that that is invalid.

Even if one of the top-levels is present in correct form, the server will *not* process them; thus no sub-unit errors will be recieved *even if they exist*. In this case, the top-level that is present will simply not be enumerated.

### Sub-unit Errors
Occurs when information  within a note object or note_content object (under one of the top-level lists) is missing, invalid, or caused errors. 

Response will have general structure:
```json
{
	"notes": [
    	{
        	"note_id": NOTE_ID,
            "note_id_errors": ERROR_CODE,
            "date_created_errors": ERROR_CODE
        },
        {
        	"note_id": NOTE_ID,
            "note_id_errors": ERROR_CODE,
            "date_created_errors": ERROR_CODE
        }
    ],
    "note_contents": [
    	{
        	"note_content_id": NOTE_CONTENT_ID,
            "note_content_id_errors": ERROR_CODE,
            "note_errors": ERROR_CODE,
            "type_errors": ERROR_CODE,
            "data_errors": ERROR_CODE,
            "date_created_errors": ERROR_CODE
        },
        {
        	"note_content_id": NOTE_CONTENT_ID,
            "note_content_id_errors": ERROR_CODE,
            "note_errors": ERROR_CODE,
            "type_errors": ERROR_CODE,
            "data_errors": ERROR_CODE,
            "date_created_errors": ERROR_CODE
        }
    ]
}
```
where `ERROR_CODE` is one of the relevant error codes listed in [Error Codes](https://github.com/icasdri/tuhi/blob/master/error_codes.md) and where a suffix `_errors` denotes that that field is invalid.

Note that within each `note` and `note_content` object, the server returns back the `note_id` and `note_content_id` *given to it*, so as to identify the note.

Note that `note` object that are completely valid with no errors will simply not be enumerated.

An attempt to update a restricted resource (as in a Note or Note Content not owned by the authenticated user) will result in an additional field `authentication` with `ERROR_CODE` *90* -- within the `note` or `note_content` object in question. See the *Forbidden* section of [Authentication](https://github.com/icasdri/tuhi/blob/master/authentication.md) for details.
