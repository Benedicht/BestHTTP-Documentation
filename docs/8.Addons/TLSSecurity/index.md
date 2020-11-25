<link href="media/cirles.css" rel="stylesheet" />

# About

While the Best HTTP/2 plugin lacks any certification verification and accepts all certifications as valid by default, this addon aims to deliver a complete solution for certification verification, revocation checking and managing trusted root CAs and intermediates.
This addon implements all certification verification steps a browser normally do and additionally provides a management window to easily manage trusted certificates, update and test them.

## Features

- Certificate Chain Verification (as described in [RFC 3280](https://tools.ietf.org/html/rfc3280))
- Revocation checking of leaf certificates using OCSP with optional soft and hard fail
- Caching OCSP responses
- Support for [OCSP Must-Staple](https://casecurity.org/2014/06/18/ocsp-must-staple/)
- Trusted Root CA, Trusted Intermediate and Client Credentials management through an easy to use *Certification Manager Window* to
	1. update
	2. add custom
	3. delete non-needed certificates
- Domain Name Matching

## How to setup

The addon is easy to setup, after importing the package just have to call one function on application startup:

```language-csharp
using BestHTTP.Addons.TLSSecurity;

TLSSecurity.Setup();
```

## Certification Manager Window


<!--![Certification Manager Window](media/CertificationManager.png)-->
<div> 
	<div class="circles" >
		<img src="/8.Addons/TLSSecurity/media/CertificationManager.png" class="circle-image" />
		
		<div class="circle-with-text" style="top:6.5%;left:20px">1</div>
		<div class="circle-with-text" style="top:6.5%;left:270px">2</div>
		<div class="circle-with-text" style="top:6.5%;left:570px">3</div>
	</div>
</div>

</br>
**Trusted Root CAs**: These are the basis of the trust chain, servers doesn't send root certificates the client must include the roots certificates of the accessed endpoints.
</br>**Trusted Intermediate Certificates**: Because servers can choose to not send intermediate certificates it's a good practice to bundle them too.

1. **Reset URL**: Reset the URL input back to its addon supplied url.
2. **URL Input**: The URL that the addon going to download the certifications. The addon expects CSV formatted data, but the URL can point to a local file using the file:// protocol. The default URLs are pointing to Mozilla repositories.
3. **Download**: Clicking on this button start the downloading, content parsing and loading process. Downloading the certificates already uses all verification implemented in the addon.
4. **Clear Before Download**: Check to remove all non-locked and non-user added (if `Keep Custom` is checked) certificates before download.
5. **Clear**: Remove all non-locked and non-user added (if `Keep Custom` is checked) certificates.
6. **Keep Custom**: If set Clear buttons doesn't remove user added certificates.
7. **Add Custom**: Add certificates from .cer, .pem and .p7b files.
8. **Delete Selected**: Delete selected certificates. Locked certificates can't be deleted!
9. **Search Input**: It can be used to search certificates by their `Subject` name. Minimum 3 characters needed.
10. **Help (?) Button**: Opens a browser window to this manual.

**Bottom toolbar**:

1. **Certifications**: Number of certifications displayed.
2. **Certificate Size Stats**: Min, max, sum and average size of certificate data in bytes. This can help adjusting cache sizes.

!!! Notice
	Double clicking on a row or hitting Enter while at least one row is selected dumps out certification information to the console.

</br>
**Client Certificates**: A client certificate can be associated with a domain. If the server asks for a client certificate during the TLS handshake, the client going to send it.

1. **Add for domain**: Clicking on it a `Domain and File Selector` window is shown. If the domain is filled and the certification file is selected clicking on the *Ok* button going to add the certification for the domain.
2. **Delete Selected**: Delete selected domain-certificate associations.
3. **Help (?) Button**: Opens a browser window to this manual.

## Options

Options of the addon can be accessed through the static `SecurityOptions` class.