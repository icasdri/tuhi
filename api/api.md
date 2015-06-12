# Tuhi Server Synchronization API #

## Models
#### Note
* **note_id** (string): uuid of Note
* **title** (string): title of Note
* **deleted** (boolean): whether Note is marked as deleted or not
* **date_modified** (date): the date this Note object is modified (aka. the date note metadata changed)


#### Note Content
* **note_content_id** (string): uuid of Note Content
* **note** (ref:string): reference (as note_id) to a Note
* **data** (*huge* string): the actual content, the data
* **date_created** (date): the date this Note Content object was created (aka. the date note content changed)

### User
* **username** (string): username of the user
* **password** (string): password of the user

## Endpoints

## Examples

