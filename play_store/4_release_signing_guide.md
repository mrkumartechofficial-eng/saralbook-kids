# Release signing (so Google Play accepts your app)

Google Play needs the app signed with YOUR key. Never put this key or its passwords in the GitHub repository files - only in GitHub **Secrets**.

## Step A - create your upload key (once, on your laptop)
1. Install Java (a free "JDK"): search "Adoptium Temurin JDK 17" and install it.
2. Open a terminal / command prompt and run (change the words in CAPITALS):
```
keytool -genkeypair -v -keystore upload.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```
3. It asks for a password (use a long one), your name, etc. Remember the password - it is the same for the store and the key if you press Enter when asked.
4. **Back up `upload.jks` and the passwords in a safe place** (for example a password manager and a USB stick). If you lose them you cannot update the app the normal way.
5. Never upload `upload.jks` to GitHub.

## Step B - turn the key file into text
- Windows (PowerShell): `[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload.jks")) | Set-Clipboard`
- Mac / Linux: `base64 -i upload.jks | pbcopy`  (Linux: `base64 -w0 upload.jks`)

## Step C - add 4 GitHub Secrets
GitHub repo → **Settings → Secrets and variables → Actions → New repository secret**. Add exactly these names:
| Name | Value |
|---|---|
| KEYSTORE_BASE64 | the long text from Step B |
| KEYSTORE_PASSWORD | your keystore password |
| KEY_ALIAS | `upload` (or the alias you used) |
| KEY_PASSWORD | your key password (same as above if you pressed Enter) |

## Step D - build
Go to **Actions → Build Android → Run workflow** (or push any change). The log step "Sign release" should say "Signed APK and AAB created." Download the `saralbook-kids-aab` artifact - that is the file you upload to Google Play.
If the secrets are missing, the step says it was skipped and the files are only debug-signed (fine for testing on your own phone, NOT accepted for release).

## Version numbers
Every upload to Google Play needs a higher build number. In `pubspec.yaml` change `version: 1.0.0+1` to `1.0.1+2`, then `1.0.2+3`, and so on (the number after + must always go up).

## Play App Signing
When you upload your first AAB, Play Console asks you to use **Play App Signing** - accept it. Google keeps the final app-signing key safe; your `upload.jks` is only the "upload key".
