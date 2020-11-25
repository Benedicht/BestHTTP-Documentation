# Options

Options of the addon can be accessed through the static `SecurityOptions` class:

- **FolderAndFileOptions**: Folder, file and extension options.
- **OCSP**: OCSP and OCSP cache options.
- **TrustedRootsOptions**: Database options of the Trusted CAs database.
- **TrustedIntermediatesOptions**: Database options of the Trusted Intermediate Certifications database
- **Database options of the Client Credentials database**: Database options of the Client Credentials database

## OCSPOptions

- **ShortLifeSpanThreshold**: The addon not going to check revocation status for short lifespan certificates.
- **EnableOCSPQueries**: Enable or disable sending out OCSP requests for revocation checking.
- **FailHard**: Treat unknown revocation statuses (unknown OCSP status or unreachable servers) as revoked and abort the TLS negotiation.
- **FailOnMissingCertWhenMustStaplePresent**: 
- **FailOnMissingNonce**: 
- **OCSPCache**: 

## OCSPCacheOptions

- **Enabled**: 
- **MaxEntries**:
- **CacheUnknownFor**: 
- **DeleteUnusedEntriesAfter**: 
- **MaxWaitTime**: 
- **RetryUnknownAfter**: 
- **FolderName**: 
- **DatabaseOptions**: 
- **HTTPRequestOptions**: 

## OCSPCacheHTTPRequestOptions

OCSP requests are plain old `HTTPRequest`s and every BestHTTP/2 global settings affecting them, but through this options OCSP requests can be further customized.

- **DataLengthThreshold**: 
- **UseKeepAlive**: 
- **UseCache**:
- **ConnectTimeout**:
- **Timeout**: