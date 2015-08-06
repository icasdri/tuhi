# Tuhi Server Synchronization API #

## Models
#### Note
* **note_id** (string): uuid of Note
* **deleted** (boolean): whether Note is marked as deleted or not
* **date_modified** (date): the date this Note object is modified (aka. the date note metadata changed)

For purpose of synchronization, the server is unaware of the current "title" of the Note. Clients should automatically derive the "title" of the Note from the first line of the most recent NoteContent as specified in Client Spec (to be created).


#### Note Content
* **note_content_id** (string): uuid of Note Content
* **note** (ref:string): reference (as note_id) to a Note
* **type** (int): type id representing the type of this Note Content (see below)
* **data** (*huge* string): the actual content, the data
* **date_created** (date): the date this Note Content object was created (aka. the date note content changed)

###### Note Content Types
* **-2**: permanent deletion (this Note Content represents the permanent deletion of its entire note -- all Note Contents other than this one should be immediately purged)
* **-1**: trashed (note was soft-deleted, aka. moved to trash)
* **0**: plain (plain text)

#### Date (not an object!)
Represented as an integer number of seconds since the Unix epoch (January 1, 1970). For example: June 17, 2015 at 17:55:55, would be represented as 1434563755. See [Unix Time](https://en.wikipedia.org/wiki/Unix_time).
*May need to add timezone support later.*

## Endpoints
Both endpoints require authentication. See [Authentication](https://github.com/icasdri/tuhi/blob/master/authentication.md).

#### `GET /notes`
* **Query Parameters**: (all optional, will return all if none given)
	* *after* (date): all `Notes` modified after date and all `Note Contents` created after date on the server.
	* *head* (boolean): if true, returns only the most recent `Note Content` for every `Note`
* **Response Body**: one dict with two lists containing the data on the server but not synced to the client yet (see *Body* below)


#### `POST /notes`
* **Request Body**: one dict with two lists containing the data on the client but not synced to the server yet (see *Body* below)
* **Response Body**: see [Responses](https://github.com/icasdri/tuhi/blob/master/responses.md).


## Body
The `GET` and `POST` endpoints of `/notes` takes a body consisting of a dict with two lists. Each list is a list of one of `Note` or `Note Content`.

For example:

```json
{
    "notes": [
        {
            "note_id": "8c9d9813-6ff7-45b9-9268-55799978b119",
            "deleted": false,
            "date_modified": 1435973780
        },
        {
            "note_id": "b0971251-f35d-405d-9045-f2e5f98de6b7",
            "deleted": false,
            "date_modified": 1435973782
        }
    ],
    "note_contents": [
        {
            "note_content_id": "be7a8333-cba6-456c-9519-0e9da0cf1da9",
            "note": "8c9d9813-6ff7-45b9-9268-55799978b119",
            "type": 0,
            "data": "This is the actual data for my first note. At least some version of it.\nThis string may become very very long.",
            "date_created": 1435973785
        },
        {
            "note_content_id": "cca23aab-4a2c-4604-a3e7-30de25300731",
            "note": "8c9d9813-6ff7-45b9-9268-55799978b119",
            "type": 0,
            "data": "This is the actual data for my first note, edited a liitle. This is another version of it.\nThis string may become very very long.",
            "date_created": 1435973786
        },
        {
            "note_content_id": "f079c073-6a96-45d1-81fa-dbbedef4bff8",
            "note": "b0971251-f35d-405d-9045-f2e5f98de6b7",
            "type": 0,
            "data": "Here's my second note.\nIt could be much much longer.",
            "date_created": 1435973792
        }
    ]
}
```
