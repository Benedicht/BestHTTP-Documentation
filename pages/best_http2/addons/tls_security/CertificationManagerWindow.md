---
title: Certification Manager Window
sidebar: best_http2_main_sidebar
---

<link href="media/circles.css" rel="stylesheet" />

## Certification Manager Window

The *Window/Best HTTP/Addons/TLS Security/Certification Window* menu item (or CTRL+ALT+E shortcut) opens the addon's Certification Manager. Using this window certificates can be added, updated and deleted.

<div class="circles" >
	<img src="media/CertificationManager.png" class="circle-image" />
	
	<a href="#trusted-root-cas"><div class="circle-with-text" style="top:4%;left:57%">1</div></a>
	<a href="#trusted-intermediate-certificates"><div class="circle-with-text" style="top:38.3%;left:63%">2</div></a>
	<a href="#client-certificates"><div class="circle-with-text" style="top:72.3%;left:57.5%">3</div></a>
	<a href="#testing-http-requests"><div class="circle-with-text" style="top:94.5%;left:15%">4</div></a>
	<a href="#bottom-toolbar"><div class="circle-with-text" style="top:97%;left:53.5%">5</div></a>
</div>

## Trusted Root CAs

These are the basis of the trust chain, servers doesn't send root certificates the client must include the roots certificates of the accessed endpoints.

<div class="circles" >
	<img src="media/RootCAs.png" class="circle-image" />
	
	<a href="#root_1"><div class="circle-with-text" style="top:10%;left:2.5%">1</div></a>
	<a href="#root_2"><div class="circle-with-text" style="top:10%;left:17%">2</div></a>
	<a href="#root_3"><div class="circle-with-text" style="top:10%;left:38.5%">3</div></a>
	<a href="#root_4"><div class="circle-with-text" style="top:10%;left:47%">4</div></a>
	<a href="#root_5"><div class="circle-with-text" style="top:10%;left:53.5%">5</div></a>
	<a href="#root_6"><div class="circle-with-text" style="top:10%;left:58.5%">6</div></a>
	<a href="#root_7"><div class="circle-with-text" style="top:10%;left:65%">7</div></a>
	<a href="#root_8"><div class="circle-with-text" style="top:10%;left:71%">8</div></a>
	<a href="#root_9"><div class="circle-with-text" style="top:10%;left:85%">9</div></a>
	<a href="#root_10"><div class="circle-with-text" style="top:10%;left:97.7%">10</div></a>
	
	<a href="#root_11"><div class="circle-with-text" style="top:26%;left:0.4%">11</div></a>
	<a href="#root_12"><div class="circle-with-text" style="top:26%;left:4%">12</div></a>
	<a href="#root_13"><div class="circle-with-text" style="top:26%;left:6.7%">13</div></a>
	<a href="#root_14"><div class="circle-with-text" style="top:26%;left:32.4%">14</div></a>
	<a href="#root_15"><div class="circle-with-text" style="top:26%;left:77.7%">15</div></a>
	
	<a href="#root_16"><div class="circle-with-text" style="top:96%;left:3%">16</div></a>
	<a href="#root_17"><div class="circle-with-text" style="top:96%;left:20%">17</div></a>
	<a href="#root_18"><div class="circle-with-text" style="top:96%;left:38.5%">18</div></a>
</div>

1.  <p id="root_1">**Reset URL**: Reset the URL input back to its addon supplied url.</p>
2.  <p id="root_2">**URL Input**: The URL that the addon going to download the certifications. The addon expects CSV formatted data, but the URL can point to a local file using the file:// protocol. The default URLs are pointing to Mozilla repositories.</p>
3.  <p id="root_3">**Download**: Clicking on this button start the downloading, content parsing and loading process. Downloading the certificates already uses all verification implemented in the addon.</p>
4.  <p id="root_4">**Clear Before Download**: Check to remove all non-locked and non-user added (if `Keep Custom` is checked) certificates before download.</p>
5.  <p id="root_5">**Clear**: Remove all non-locked and non-user added (if `Keep Custom` is checked) certificates.</p>
6.  <p id="root_6">**Keep Custom**: If set Clear buttons doesn't remove user added certificates.</p>
7.  <p id="root_7">**Add Custom**: Add certificates from .cer, .pem and .p7b files.</p>
8.  <p id="root_8">**Delete Selected**: Delete selected certificates. Locked certificates can't be deleted!</p>
9.  <p id="root_9">**Search Input**: It can be used to search certificates by their `Subject` name. Minimum 3 characters needed.</p>
10. <p id="root_10">**Help (?) Button**: Opens a browser window to this manual.</p>

11. <p id="root_11">**# Column**: Index of the certificate.</p>
12. <p id="root_12">**User Column**: It has a ✔, if it's a user-added certificate.</p>
13. <p id="root_13">**Lock Column**: It has a ✔, if it's locked and can't be deleted. Currently only certificates needed to update from the default URL are locked.</p>
14. <p id="root_14">**Subject Column**: Subject field of the certificate.</p>
15. <p id="root_15">**Issuer Column**: Issuer field of the certificate.</p>

16. <p id="root_16">**Certifications**: Number of certifications displayed.</p>
17. <p id="root_17">**Certificate Size Stats**: Min, max, sum and average size of certificate data in bytes. This can help adjusting cache sizes.</p>
18. <p id="root_18">**Status**: Status of the last operation.</p>

{% include note.html content="Double clicking on a row or hitting Enter while at least one row is selected dumps out certification information to the console." %}

## Trusted Intermediate Certificates

Because servers can choose to not send intermediate certificates it's a good practice to bundle them too.

<div class="circles" >
	<img src="media/Intermediates.png" class="circle-image" />
	
	<a href="#intermediate_1"><div class="circle-with-text" style="top:10%;left:2.5%">1</div></a>
	<a href="#intermediate_2"><div class="circle-with-text" style="top:10%;left:17%">2</div></a>
	<a href="#intermediate_3"><div class="circle-with-text" style="top:10%;left:38.5%">3</div></a>
	<a href="#intermediate_4"><div class="circle-with-text" style="top:10%;left:47%">4</div></a>
	<a href="#intermediate_5"><div class="circle-with-text" style="top:10%;left:53.5%">5</div></a>
	<a href="#intermediate_6"><div class="circle-with-text" style="top:10%;left:58.5%">6</div></a>
	<a href="#intermediate_7"><div class="circle-with-text" style="top:10%;left:65%">7</div></a>
	<a href="#intermediate_8"><div class="circle-with-text" style="top:10%;left:71%">8</div></a>
	<a href="#intermediate_9"><div class="circle-with-text" style="top:10%;left:85%">9</div></a>
	<a href="#intermediate_10"><div class="circle-with-text" style="top:10%;left:97.7%">10</div></a>	
	<a href="#intermediate_11"><div class="circle-with-text" style="top:26%;left:0.4%">11</div></a>
	<a href="#intermediate_12"><div class="circle-with-text" style="top:26%;left:4%">12</div></a>
	<a href="#intermediate_13"><div class="circle-with-text" style="top:26%;left:6.7%">13</div></a>
	<a href="#intermediate_14"><div class="circle-with-text" style="top:26%;left:32.4%">14</div></a>
	<a href="#intermediate_15"><div class="circle-with-text" style="top:26%;left:77.7%">15</div></a>	
	<a href="#intermediate_16"><div class="circle-with-text" style="top:96%;left:3%">16</div></a>
	<a href="#intermediate_17"><div class="circle-with-text" style="top:96%;left:20%">17</div></a>
	<a href="#intermediate_18"><div class="circle-with-text" style="top:96%;left:38.5%">18</div></a>
</div>

1.  <p id="intermediate_1">**Reset URL**: Reset the URL input back to its addon supplied url.</p>
2.  <p id="intermediate_2">**URL Input**: The URL that the addon going to download the certifications. The addon expects CSV formatted data, but the URL can point to a local file using the file:// protocol. The default URLs are pointing to Mozilla repositories.</p>
3.  <p id="intermediate_3">**Download**: Clicking on this button start the downloading, content parsing and loading process. Downloading the certificates already uses all verification implemented in the addon.</p>
4.  <p id="intermediate_4">**Clear Before Download**: Check to remove all non-locked and non-user added (if `Keep Custom` is checked) certificates before download.</p>
5.  <p id="intermediate_5">**Clear**: Remove all non-locked and non-user added (if `Keep Custom` is checked) certificates.</p>
6.  <p id="intermediate_6">**Keep Custom**: If set Clear buttons doesn't remove user added certificates.</p>
7.  <p id="intermediate_7">**Add Custom**: Add certificates from .cer, .pem and .p7b files.</p>
8.  <p id="intermediate_8">**Delete Selected**: Delete selected certificates. Locked certificates can't be deleted!</p>
9.  <p id="intermediate_9">**Search Input**: It can be used to search certificates by their `Subject` name. Minimum 3 characters needed.</p>
10. <p id="intermediate_10">**Help (?) Button**: Opens a browser window to this manual.</p>

11. <p id="intermediate_11">**# Column**: Index of the certificate.</p>
12. <p id="intermediate_12">**User Column**: It has a ✔, if it's a user-added certificate.</p>
13. <p id="intermediate_13">**Lock Column**: It has a ✔, if it's locked and can't be deleted. Currently only certificates needed to update from the default URL are locked.</p>
14. <p id="intermediate_14">**Subject Column**: Subject field of the certificate.</p>
15. <p id="intermediate_15">**Issuer Column**: Issuer field of the certificate.</p>

16. <p id="intermediate_16">**Certifications**: Number of certifications displayed.</p>
17. <p id="intermediate_17">**Certificate Size Stats**: Min, max, sum and average size of certificate data in bytes. This can help adjusting cache sizes.</p>
18. <p id="intermediate_18">**Status**: Status of the last operation.</p>

{% include note.html content="Double clicking on a row or hitting Enter while at least one row is selected dumps out certification information to the console." %}

## Client Certificates

A client certificate can be associated with a domain. If the server asks for a client certificate during the TLS handshake, the client going to send it back.

<div class="circles" >
	<img src="media/ClientCertificates.png" class="circle-image" />
	
	<a href="#client_1"><div class="circle-with-text" style="top:15%;left:2.5%">1</div></a>
	<a href="#client_2"><div class="circle-with-text" style="top:15%;left:10%">2</div></a>
	<a href="#client_3"><div class="circle-with-text" style="top:15%;left:97.7%">3</div></a>
	
	<a href="#client_4"><div class="circle-with-text" style="top:37%;left:0.4%">4</div></a>
	<a href="#client_5"><div class="circle-with-text" style="top:37%;left:31%">5</div></a>
	<a href="#client_6"><div class="circle-with-text" style="top:37%;left:77.5%">6</div></a>
	
	<a href="#client_7"><div class="circle-with-text" style="top:95%;left:2%">7</div></a>
	<a href="#client_8"><div class="circle-with-text" style="top:95%;left:10%">8</div></a>
</div>

1. <p id="client_1">**Add for domain**: Clicking on it a `Domain and File Selector` window is shown. If the domain is filled and the certification file is selected clicking on the *Ok* button going to add the certification for the domain.</p>
2. <p id="client_2">**Delete Selected**: Delete selected domain-certificate associations.</p>
3. <p id="client_3">**Help (?) Button**: Opens a browser window to this manual.</p>

4. <p id="client_4">**# Column**: Index of the certificate</p>
5. <p id="client_5">**Target Domain Column**: The certificate sent only if it's requested for the target domain.</p>
6. <p id="client_6">**Authority Column**: *Common Name* or *Organizational Unit Name* from the certificate's Issuer field.</p>
7. <p id="client_7">**Certifications**: Number of certifications displayed.</p>
8. <p id="client_8">**Certificate Size Stats**: Min, max, sum and average size of certificate data in bytes. This can help adjusting cache sizes.</p>

Clicking on the `Add for domain` button a new window opens to select the certification file and domain:

![Domain and File Selector](media/DomainAndFileSelector.png)

Then, clicking on the *Ok* button depending on the type of certificate file a window to input the file's password might open:

![PasswordForCertificate.png](media/PasswordForCertificate.png)

## Testing HTTP Requests

A basic GET request can be sent out for the given domain to test the current setup.

<div class="circles" >
	<img src="media/TestRequest.png" class="circle-image" />
	
	<a href="#request_1"><div class="circle-with-text" style="top:-40%;left:50%">1</div></a>
	<a href="#request_2"><div class="circle-with-text" style="top:-40%;left:87%">2</div></a>
	<a href="#request_3"><div class="circle-with-text" style="top:-40%;left:94%">3</div></a>
</div>

1. <p id="request_1">Input field for the domain to test</p>
2. <p id="request_2">Send button</p>
3. <p id="request_3">Result of the request</p>

{% include warning.html content="Because of [Connection Pooling](../../global_topics/ConnectionPool.md) a request that otherwise would fail can succeed if there's an already open connection to the domain!" %}

## Bottom Toolbar

<div class="circles" >
	<img src="media/BottomBar.png" class="circle-image" />
	
	<a href="#bottombar_1"><div class="circle-with-text" style="top:-30%;left:2.5%">1</div></a>
	<a href="#bottombar_2"><div class="circle-with-text" style="top:-30%;left:17%">2</div></a>
</div>

1. <p id="bottombar_1">Name and version number of this addon</p>
2. <p id="bottombar_2">Support e-mail</p>
