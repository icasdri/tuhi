swagger_version 1.2
api_version 0.1

GET '/notes':
    summary: 'Fetch the list of note ids'
    returns: [string]
    produces: json
    response:
        200: true
        401: 'Must provide auth credentials in Authorization'

GET '/notes/{note_id}':
    summary: 'Fetch a Note'
    returns: 'Note'
    produces: json
#    parameters:
#        after: [query, date]
#        before: [query, date]
    response:
        200: true
        401: 'Must provide auth credentials in Authorization'
        403: 'User is not authorized'
        404: 'Note with this id not found'
#    authorization:
#        parameters:
#            user: [body, ]

GET '/notes/{note_id}/{note_content_id}':
    summary: 'Fetch specific version of note'
    returns: 'Note'
    produces: json
    response:
        200: true
        400: 'Note content id given exists but does not reference note id given'
        401: 'Must provide auth credentials in Authorization'
        403: 'User is not authorized'
        404: 'Note with this id not found'
        404: 'Note content with this id not found'

# Applications MUST get note list from server first to prevent Note id conflict
# which are undetectable b/c look same as update.
POST '/notes':
    summary: 'Updates note'
    produces: json
    consumes: json
    parameters:
        note: [body, type:'Note', required]
    response:
        200: true
        400: 'Note content id conflict'
        401: 'Must provide auth credentials in Authorization'
        403: 'User is not authorized'

CREATE '/notes':
    summary: 'Creates a new note'
    produces: json
    consumes: json
    parameters:
        note: [body, type:'Note', required]
    reponse:
        200: true
        400: 'Note id conflict'
        400: 'Note content id conflict'
        401: 'Must provide auth credentials in Authorization'
        403: 'User is not authorized'


MODEL 'Note':
    note_id: ['Note ID', string, required]
    content: ['NoteContent reference', string, required]
    title: ['Title (derived from first line; auto if not provided)', string]

MODEL 'NoteContent':
    note_content_id: ['NoteContent ID', string, required]
    data: ['The Content/Data', string, required]
#    creation_date: ['Date of this version (auto if not provided)', date]
