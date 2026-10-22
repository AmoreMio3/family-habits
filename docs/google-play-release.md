# Google Play release builds

Google Play needs every version signed with the same private **upload key**.
Google keeps the real app signing key ("Play App Signing"); the upload key only
proves a new version comes from us. If it is ever lost, Google can reset it
through Play Console support, but keep a backup anyway.

The key is never stored in this repository. It lives in four GitHub secrets
(GitHub, the repository, Settings, Secrets and variables, Actions):

| Secret | What it holds |
|---|---|
| `UPLOAD_KEYSTORE_BASE64` | The key file (`upload.jks`), base64-encoded |
| `UPLOAD_KEYSTORE_PASSWORD` | The key file's password |
| `UPLOAD_KEY_ALIAS` | The key's name inside the file, for example `upload` |
| `UPLOAD_KEY_PASSWORD` | The key's password |

Once they exist, every change merged into `main` also builds
`app-release.aab`, the file you upload in Play Console. Download it from the
`family-habits-play-bundle` item on the Actions run page. Until then the
`play-release` job just prints a note and skips.

Making the key (anyone with Java installed):

```sh
keytool -genkeypair -v -keystore upload.jks -alias upload \
  -keyalg RSA -keysize 2048 -validity 10000
base64 -w0 upload.jks   # paste the output into UPLOAD_KEYSTORE_BASE64
```

Test builds sent to phones through Firebase App Tester are not affected; they
keep using the shared test key.
