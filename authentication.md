# Authentication (Tuhi Server Synchronization API) #

### Summary
Clients must authenticate a user when using either endpoint `GET /notes` or `POST /notes`. 

Authentication consists of passing an authentication payload as part of the HTTP `Authorization` header. This payload can take one of two forms: JSON username/password, or HTTP Basic Authentication.

#### JSON username/password
To use this form of authentication, send a JSON object of the following form in the HTTP `Authorization` header with the request to be authenticated

```json
{
	"username": USERNAME,
    "passowrd": PASSWORD
}
```

where `USERNAME` and `PASSWORD` are strings representing the username and password of the user to be authenticated respectively.

#### HTTP Basic Authentication
To use this form of authentication, send a literal `Basic` followed by a space then followed by a base64 encoded username and password separated by a colon as per [RFC 2617](https://tools.ietf.org/html/rfc2617#section-2) (also available [here](http://www.w3.org/Protocols/HTTP/1.0/spec.html#BasicAA)) in the HTTP `Authorization` header with the request to be authenticated.

The header should look something like:

	Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

### Responses
* **HTTP 401 Unauthorized**: signifies an unsuccessful authentication or lack of `Authorization` header. Data in response will be of one of the following forms:

    ```json
{
    "authentication_errors": ERROR_CODE
}
    ```
    
	when there's a lack of authentication information altogether or JSON errors in `Authorization` payload.
    
    ```json
{
    "authentication": {
        "username_errors": ERROR_CODE,
        "password_errors": ERROR_CODE
    }
}
    ```
    
	when authentication failed due to incomplete information, non-existent users, or incorrect passwords.

    In both cases, ERROR_CODE is one of the error codes documented  at [Error Codes](https://github.com/icasdri/tuhi/blob/master/error_codes.md).

* **HTTP 403 Forbidden**: occurs when authentication was successful, however, the authenticated user is not authorized to access a given resource.
	* Note: a *Forbidden* response can be part of a **Sub-unit Error** response documented in [Responses](https://github.com/icasdri/tuhi/blob/master/responses.md). In that case, an additional field `authentication` will be added to the object in question (either a Note or Note Content) and will have ERROR_CODE = 90.

