# Tuhi Documentation

[Tuhi](https://github.com/icasdri/tuhi) is a self-hosted synchronized notes solution based on a flexible JSON-based storage format and an extensible asynchronous HTTP-based client-server architecture. This document specifies storage format as well as the synchronization protocl between clients and servers as a reference for developers. Users seeking the list of clients (and their associated setup instructions, etc.) should visit the [project home](https://github.com/icasdri/tuhi) instead.

* [Format](#format)
  * [Entities](#entities)
    * [`Note`](#note)
    * [`Note Content`](#note-content)
  * [Local Workflow](#local-workflow)
  * [Packaging](#packaging)
    * [Packaging Methods](#packaging-methods)
      * [`none`](#none)
  * [Unpackaged Data](#unpackaged-data)
    * [Types](#types)
      * [`plain`](#plain)
* [Syncing](#syncing)

## Format

Tuhi stores notes (and, in the future, note-like things such as todo lists) using two data models, `Note` and `Note Content`. A `Note` is an entity identifying a specific note with relevant metadata such as a date of creation. Additionally, a `Note` is a collection of `Note Content`s. Each `Note Content` represents what a `Note` looked like (aka. the content) at a specific time in history. The collection of `Note Content`s for each `Note` thus represents that `Note`'s history.

### Entities

Listed below are the details of the two entities, `Note` and `Note Content`, used by Tuhi. Clients may choose to store these in any way of their choosing (be it a database, collection of files, or otherwise), as long as they maintain the required elements of each entity as listed below, as well as the relationship of which `Note Content` belongs to which `Note` (e.g. in a foreign-key relationship in a database).

#### `Note`

* **n_local_id** (integer): client-unique identifier for this `Note` on this client
* **n_sync_id** (integer): server-unique identifier for this `Note` on the server (this is obtained from server -- *see [Syncing](#syncing) for details*)
* **date_created** (integer): the date this `Note` was created on the client (expressed as seconds since the Unix epoch)
* **packaging_method** (string): the name of the packaging method (*see [Packaging](#packaging) for details*)

#### `Note Content`

* **nc_local_id** (integer): client-unique identifier for this `Note Content` on this client
* **nc_sync_id** (integer): server-unique identifier for this `Note Content` on the server (this is obtained from server -- *see [Syncing](#syncing) for details*)
* **date_created** (integer): the date this `Note` was created on the client (expressed as seconds since the Unix epoch)
* **deleted** (integer): 0 for non-deleted, 1 for soft-deleted (i.e. trashed), 2 for permanently deleted (*see [Deletion](#deletion) for details*)
* **packaged_data** (string): the raw (packaged) data (*see [Packaging](#packaging) and [Unpackaged Data](#unpackaged-data) for details*)

### Local Workflow

The general way that *clients* should interact with the `Note` and `Note Content` entities is as follows:

To update/modify a note, make a new `Note Content` associated with the `Note` being updated and set the updated/modified content appropriately in `packaged_data` (*see [Packaging](#packaging) and [Unpackaged Data](#unpackaged-data) for details*). Obviously set the `nc_local_id`, `date_created`, and `deleted` fields appropriately as well.

To go back to a previous version of a note, the process is the same -- think of it as updating/modifying the note with the contents of a previous version. Thus, here, the `packaged_data` of the new `Note Content` would just be copied from the `Note Content` representing the desired version.

To (soft) delete a note (i.e. put it in the Trash), make a new `Note Content` with `packaged_data` copied from the non-deleted version, but with `deleted` set to 1. 

To restore a note from the Trash, in a similar fashion, make a new `Note Content` with `packaged_data` copied from the deleted version (remember, it was copied from the non-deleted version), but with `deleted` set to 0.

To permanently delete a note, make a new `Note Content`, with `deleted` set to 2 (the *permanent deletion request*). Addidionally, delete (as in drop from the database, `rm` from the filesystem, etc.) all other `Note Content`s (this is the *permanent* part). Then, after syncing the *permanent deletion request* with the server (*see [Syncing](#syncing) for details*), that may be deleted as well -- the server will take care of propogating to other clients from there. If a client has a *permanent deletion request* synced in, it may be desirable (and is mandated for encrypted notes) to confirm with the user that he/she has indeed permanently deleted it in order to prevent a sort of Denial of Service attack resulting in data loss.

See that `Note`s and `Note Content`s are **immutable**. That is, once they're created, their contents (i.e. their field values) never change. Ever. Immutability guarantees that once entities are synced, they're synced for good and neither client nor server needs to worry about them again.

### Packaging

*Packaging method* refers to the method by which the [Unpackaged Data](#unpackaged-data) is obtained from or serialized to *packaged data* (stored in the `packaged_data` field of `Note Content`). The string in the `packaging_method` field of `Note` is the name of the packaging method for that note. Valid packaging method names and a description of their corresponding methods and what they signify are listed below in [Packaging Methods](#packaging-methods).

Observe that `packaging_method` is specified in `Note` and recall that `Note`s are immutable. This means  that once a `Note` is created, its *packaging method* cannot change. This might be seen as an inconvenience, but this fact will become very important when *packaging* will come to include encryption. Having this method be immutable means neither the server nor another client can change it willy-nilly, preventing an entire class of downgrade attacks. But we needn't worry about that right now.

#### Packaging Methods

##### `none`

This methods essentially does nothing. It takes the `pacakaged_data` field of `Note Content` directly/literally as the [Unpackaged Data](#unpackaged-data) -- no transformations are made.

In the future, we will define more packaging methods (performing actions such as compression and encryption), but for now we will stick to our one Null-cipher-esque method.

### Unpackaged Data

The *unpackaged data* of a `Note Content` refers to thhe `packaged_data` after being run through the appropriate *packaging method*. It is **stringified JSON** that houses the actual data (user-visible content) of the note (or more precisely the `Note Content` -- the note at a specific point in time). This data includes the *type* of the note (i.e. is it a plain ol' note, a todo list, a kanban board, etc.) and, of course, the actual type-specific content that represent what the user sees. 

To interact with *unpackaged data*, clients must first run `packaged_data` through the corresponding *packaging method*, then parse the resulting string to obtain the JSON structure. 

The only fields of the resulting JSON object that is guaranteed is `type` (denoting the type of the note) and `title` (the title of the note) -- everything else is type-specific data (see [Types](#types) below).

```json
    {
        "type": "string denoting the type of note",
        "title": "string of the note's title",
        "type_specific_field1": "some type-specific data",
        "type_specific_field2": "some type-specific data"
    }
```

#### Types

##### `plain`

This type denotes a plain ol' note. It's JSON structure is as follows:

```json
    {
        "type": "plain",
        "title": "the note's title",
        "text": "<string>",
        "word_wrap": "<string> off|normal|break",
        "spell_check": "<string> e.g. en_US",
        "syntax": "<string> e.g. python"
    }
```

The type-specific fields for "plain" are as follows

* **text** (*long* string): the full text of the note as a string
    * Note: for this type of note, clients may (and are encouraged to) derive the `title` from the first line of `text`, instead of having a separate UI for title input.
* **word_wrap** (string): specifies how words should be wrapped when displaying/editing this note): this specifier can take on the following values
    * *off*: do not wrap words (i.e. lines continue off screen and need horizontal scrolling)
    * *normal*: wrap/break words only at "allowable" break points ("allowable" will be at the client's discretion here)
    * *break*: wrap/break words even if they're "unbreakable" -- e.g. even break "wind" into "wi" and on the next line "nd"
* **spell_check** (string): denotes what language to spell check (red-underline or otherwise), or "off". (e.g. "en_US")
* **syntax** (string): denotes what (programming) language to highlight syntax for (e.g. "python", "java", "markdown", "html")

## Syncing

*WIP*