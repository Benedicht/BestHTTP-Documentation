# About

While the Best HTTP/2 plugin lacks any certification verification and accepts all certifications as valid by default, this addon aims to deliver a complete solution for certification verification, revocation checking and managing trusted root CAs and intermediates.
This addon implements all certification verification steps a browser normally do and additionally provides a management window to easily manage trusted certificates, update and test them.

## Features

- Certificate Chain Verification (as described in [RFC 3280](https://tools.ietf.org/html/rfc3280))
- Revocation checking of leaf certificates using OCSP with optional soft and hard fail
- Caching OCSP responses
- Support for [OCSP Must-Staple](https://casecurity.org/2014/06/18/ocsp-must-staple/)
- Trusted Root CA, Trusted Intermediate and Client Credentials management through an easy to use *Certification Manager Window* to
	1. Update all certificates from a trusted source
	2. Add custom certificates
	3. Delete non-needed certificates
- Domain Name Matching

## How to setup

The addon is easy to setup, after importing the package just have to call one function on application startup:

```language-csharp
using BestHTTP.Addons.TLSSecurity;

TLSSecurity.Setup();
```

Calling `TLSSecurity.Setup()` going to set up the addon and installs itself as sets its TlsClient factory as the default one.