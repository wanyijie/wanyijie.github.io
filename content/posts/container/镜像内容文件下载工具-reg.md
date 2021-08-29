Docker registry v2 command line client and repo listing generator with security checks.

**Table of Contents**

*   [Installation](https://github.com/genuinetools/reg#installation)
    *   [Binaries](https://github.com/genuinetools/reg#binaries)
    *   [Via Go](https://github.com/genuinetools/reg#via-go)
*   [Usage](https://github.com/genuinetools/reg#usage)
    *   [Auth](https://github.com/genuinetools/reg#auth)
    *   [List Repositories and Tags](https://github.com/genuinetools/reg#list-repositories-and-tags)
    *   [Get a Manifest](https://github.com/genuinetools/reg#get-a-manifest)
    *   [Get the Digest](https://github.com/genuinetools/reg#get-the-digest)
    *   [Download a Layer](https://github.com/genuinetools/reg#download-a-layer)
    *   [Delete an Image](https://github.com/genuinetools/reg#delete-an-image)
    *   [Vulnerability Reports](https://github.com/genuinetools/reg#vulnerability-reports)
    *   [Generating Static Website for a Registry](https://github.com/genuinetools/reg#generating-static-website-for-a-registry)
    *   [Using Self-Signed Certs with a Registry](https://github.com/genuinetools/reg#using-self-signed-certs-with-a-registry)
*   [Contributing](https://github.com/genuinetools/reg#contributing)

## [](https://github.com/genuinetools/reg#installation)Installation

#### [](https://github.com/genuinetools/reg#binaries)Binaries

For installation instructions from binaries please visit the [Releases Page](https://github.com/genuinetools/reg/releases).

#### [](https://github.com/genuinetools/reg#via-go)Via Go

```text-shell-session
$ go get github.com/genuinetools/reg
```

## [](https://github.com/genuinetools/reg#usage)Usage

```text-shell-session
$ reg -h
reg -  Docker registry v2 client.

Usage: reg <command>

Flags:

  --auth-url           alternate URL for registry authentication (ex. auth.docker.io) (default: <none>)
  -d                   enable debug logging (default: false)
  -f, --force-non-ssl  force allow use of non-ssl (default: false)
  -k, --insecure       do not verify tls certificates (default: false)
  -p, --password       password for the registry (default: <none>)
  --skip-ping          skip pinging the registry while establishing connection (default: false)
  --timeout            timeout for HTTP requests (default: 1m0s)
  -u, --username       username for the registry (default: <none>)

Commands:

  digest    Get the digest for a repository.
  layer     Download a layer for a repository.
  ls        List all repositories.
  manifest  Get the json manifest for a repository.
  rm        Delete a specific reference of a repository.
  server    Run a static UI server for a registry.
  tags      Get the tags for a repository.
  vulns     Get a vulnerability report for a repository from a CoreOS Clair server.
  version   Show the version information.
```

**NOTE:** Be aware that `reg ls` doesn't work with `hub.docker.com` as it has a different API than the [OSS Docker Registry](https://github.com/docker/distribution).

### [](https://github.com/genuinetools/reg#auth)Auth

`reg` will automatically try to parse your docker config credentials, but if not present, you can pass through flags directly.

### [](https://github.com/genuinetools/reg#list-repositories-and-tags)List Repositories and Tags

**Repositories**

```text-shell-session
# this command might take a while if you have hundreds of images like I do
$ reg ls r.j3ss.co
Repositories for r.j3ss.co
REPO                  TAGS
awscli                latest
beeswithmachineguns   latest
camlistore            latest
chrome                beta, latest, stable
...
```

**Tags**

```text-shell-session
$ reg tags r.j3ss.co/tor-browser
alpha
hardened
latest
stable

# or for an offical image
$ reg tags debian
6
6.0
6.0.10
6.0.8
6.0.9
7
7-slim
7.10
7.11
7.11-slim
...
```

### [](https://github.com/genuinetools/reg#get-a-manifest)Get a Manifest

```text-shell-session
$ reg manifest r.j3ss.co/htop
{
   "schemaVersion": 1,
   "name": "htop",
   "tag": "latest",
   "architecture": "amd64",
   "fsLayers": [
     {
       "blobSum": "sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4"
     },
     ....
   ],
   "history": [
     ....
   ]
 }
```

### [](https://github.com/genuinetools/reg#get-the-digest)Get the Digest

```text-shell-session
$ reg digest r.j3ss.co/htop
sha256:791158756cc0f5b27ef8c5c546284568fc9b7f4cf1429fb736aff3ee2d2e340f
```

### [](https://github.com/genuinetools/reg#download-a-layer)Download a Layer

```text-shell-session
$ reg layer -o r.j3ss.co/chrome@sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
OR
$ reg layer r.j3ss.co/chrome@sha256:a3ed95caeb0.. > layer.tar
```

### [](https://github.com/genuinetools/reg#delete-an-image)Delete an Image

```text-shell-session
$ reg rm r.j3ss.co/chrome@sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
Deleted chrome@sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
```

### [](https://github.com/genuinetools/reg#vulnerability-reports)Vulnerability Reports

```text-shell-session
$ reg vulns --clair https://clair.j3ss.co r.j3ss.co/chrome
Found 32 vulnerabilities
CVE-2015-5180: [Low]

https://security-tracker.debian.org/tracker/CVE-2015-5180
-----------------------------------------
CVE-2016-9401: [Low]
popd in bash might allow local users to bypass the restricted shell and cause a use-after-free via a crafted address.
https://security-tracker.debian.org/tracker/CVE-2016-9401
-----------------------------------------
CVE-2016-3189: [Low]
Use-after-free vulnerability in bzip2recover in bzip2 1.0.6 allows remote attackers to cause a denial of service (crash) via a crafted bzip2 file, related to block ends set to before the start of the block.
https://security-tracker.debian.org/tracker/CVE-2016-3189
-----------------------------------------
CVE-2011-3389: [Medium]
The SSL protocol, as used in certain configurations in Microsoft Windows and Microsoft Internet Explorer, Mozilla Firefox, Google Chrome, Opera, and other products, encrypts data by using CBC mode with chained initialization vectors, which allows man-in-the-middle attackers to obtain plaintext HTTP headers via a blockwise chosen-boundary attack (BCBA) on an HTTPS session, in conjunction with JavaScript code that uses (1) the HTML5 WebSocket API, (2) the Java URLConnection API, or (3) the Silverlight WebClient API, aka a "BEAST" attack.
https://security-tracker.debian.org/tracker/CVE-2011-3389
-----------------------------------------
CVE-2016-5318: [Medium]
Stack-based buffer overflow in the _TIFFVGetField function in libtiff 4.0.6 and earlier allows remote attackers to crash the application via a crafted tiff.
https://security-tracker.debian.org/tracker/CVE-2016-5318
-----------------------------------------
CVE-2016-9318: [Medium]
libxml2 2.9.4 and earlier, as used in XMLSec 1.2.23 and earlier and other products, does not offer a flag directly indicating that the current document may be read but other files may not be opened, which makes it easier for remote attackers to conduct XML External Entity (XXE) attacks via a crafted document.
https://security-tracker.debian.org/tracker/CVE-2016-9318
-----------------------------------------
CVE-2015-7554: [High]
The _TIFFVGetField function in tif_dir.c in libtiff 4.0.6 allows attackers to cause a denial of service (invalid memory write and crash) or possibly have unspecified other impact via crafted field data in an extension tag in a TIFF image.
https://security-tracker.debian.org/tracker/CVE-2015-7554
-----------------------------------------
Unknown: 2
Negligible: 23
Low: 3
Medium: 3
High: 1
```

### [](https://github.com/genuinetools/reg#generating-static-website-for-a-registry)Generating Static Website for a Registry

`reg` bundles a HTTP server that periodically generates a static website with a list of registry images and serves it to the web.

It will run vulnerability scanning if you have a [CoreOS Clair](https://github.com/coreos/clair) server set up and pass the url with the `--clair` flag.

It is possible to run `reg server` just as a one time static generator. `--once` flag makes the `server` command exit after it builds the HTML listing.

There is a demo at [r.j3ss.co](https://r.j3ss.co/).

**Usage:**

```text-shell-session
$ reg server -h
Usage: reg server [OPTIONS]

Run a static UI server for a registry.

Flags:

  -u, --username       username for the registry (default: <none>)
  --listen-address     address to listen on (default: <none>)
  --asset-path         Path to assets and templates (default: <none>)
  -f, --force-non-ssl  force allow use of non-ssl (default: false)
  --once               generate the templates once and then exit (default: false)
  --skip-ping          skip pinging the registry while establishing connection (default: false)
  --timeout            timeout for HTTP requests (default: 1m0s)
  --cert               path to ssl cert (default: <none>)
  -d                   enable debug logging (default: false)
  --key                path to ssl key (default: <none>)
  --port               port for server to run on (default: 8080)
  -r, --registry       URL to the private registry (ex. r.j3ss.co) (default: <none>)
  --clair              url to clair instance (default: <none>)
  -k, --insecure       do not verify tls certificates (default: false)
  --interval           interval to generate new index.html's at (default: 1h0m0s)
  -p, --password       password for the registry (default: <none>)
```

**Screenshots:**

[图片上传失败...(image-9e17d8-1585106582654)] 


[图片上传失败...(image-318ad5-1585106582654)] 

