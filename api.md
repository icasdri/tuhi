# Tuhi Server Synchronization API #

## Models
#### Note
* **note_id** (string): uuid of Note
* **user** (ref:int): user of note
* **title** (string): title of Note
* **deleted** (boolean): whether Note is marked as deleted or not
* **date_modified** (date): the date this Note object is modified (aka. the date note metadata changed)


#### Note Content
* **note_content_id** (string): uuid of Note Content
* **note** (ref:string): reference (as note_id) to a Note
* **data** (*huge* string): the actual content, the data
* **date_created** (date): the date this Note Content object was created (aka. the date note content changed)

#### User
* **user_id** (int): pk of user
* **username** (string): username of the user
* **password** (string): password of the user

#### Date (not an object!)
Represented as ISO 8601 string looking like: "2015-06-14T19:04:43.238851". May need to add timezone support later.

## Endpoints
#### `GET /notes`
* **Query Parameters**: (all optional, will return all if none given)
	* *after* (date): all `Notes` modified after date and all `Note Contents` created after date on the server.
	* *head* (boolean): if true, returns only the most recent `Note Content` for every `Note`
* **Response Body**: one dict with two lists containing the data on the server but not synced the client yet (see *Body* below)


#### `POST /notes`
* **Request Body**: one dict with two lists containing the data on the client but not synced to the server yet (see *Body* below)
* **Response Body**: TO BE DETERMINED (failure enumeration, etc.)


## Body
The `GET` and `POST` endpoints of `/notes` takes a body consisting of a dict with two lists. Each list is a list of one of `Note` or `Note Content`. 

For example:

```json
{
    "notes": [
        {
            "note_id": "8c9d9813-6ff7-45b9-9268-55799978b119",
            "title": "My First Note",
            "deleted": false,
            "date_modified": "2015-06-12T14:32:58.285258"
        },
        {
            "note_id": "b0971251-f35d-405d-9045-f2e5f98de6b7",
            "title": "My Second Note",
            "deleted": false,
            "date_modified": "2015-06-14T17:57:08.826480"
        },
    ],
    "note_contents": [
        {
            "note_content_id": "be7a8333-cba6-456c-9519-0e9da0cf1da9",
            "note": "8c9d9813-6ff7-45b9-9268-55799978b119",
            "data": "This is the actual data for my first note. At least some version of it.\nThis string may become very very long.",
            "date_created": "2015-06-12T15:59:57.200117"
        },
        {
            "note_content_id": "cca23aab-4a2c-4604-a3e7-30de25300731",
            "note": "8c9d9813-6ff7-45b9-9268-55799978b119",
            "data": "This is the actual data for my first note, edited a liitle. This is another version of it.\nThis string may become very very long.",
            "date_created": "2015-06-12T16:30:10.101930"
        },
        {
            "note_content_id": "f079c073-6a96-45d1-81fa-dbbedef4bff8",
            "note": "b0971251-f35d-405d-9045-f2e5f98de6b7",
            "data": "Here's my second note.\nIt could be much much longer.",
            "date_created": "2015-06-14T19:04:43.238851"
        }
    ]
}
```
