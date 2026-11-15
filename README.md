# SaralBook Kids – Play & Learn

Free, offline, ad-free educational games for children aged 3–8 (English + हिंदी).
Package ID: `com.saralbook.kids`

## Status (Batch 2)
All 12 games are playable with endless levels, English + Hindi, device text-to-speech, stars, trophies, progress and a protected Parent Zone.
Pictures are emoji and shapes drawn in code (needs Android 9 or newer for all emoji).

## EASIEST WAY - browser only (no installs)
1. Unzip `saralbook-kids-batch1.zip` on your laptop (right-click -> Extract All).
2. On github.com open your empty `saralbook-kids` repository -> **Add file -> Upload files**.
3. Open the unzipped folder and drag **everything inside it** (including the `.github`, `lib`, `test`, `tool` folders and the loose files) into the browser page. Click **Commit changes**.
4. Open the **Actions** tab -> click the running "Build Android" job. When it shows a green tick (about 8-12 minutes), scroll down to **Artifacts** and download `saralbook-kids-apk`.
5. If the job shows a red cross, open it, copy the red error text and send it to Claude.

## Advanced: setup on your laptop (optional)
1. Install **Git** (git-scm.com) and the **Flutter SDK** (docs.flutter.dev/get-started/install, choose your OS).
   You do NOT need Android Studio: GitHub builds the APK for you.
   (`flutter doctor` may complain about Android – ignore that.)
2. On github.com create an **empty** repository named `saralbook-kids` (no README).
3. Open a terminal and run:
   ```
   git clone https://github.com/YOUR-USERNAME/saralbook-kids.git
   cd saralbook-kids
   flutter create --org com.saralbook --project-name kids --platforms android .
   ```
4. Unzip `saralbook-kids-batch1.zip` and copy everything inside it into this folder, choosing **Replace** when asked.
5. Delete the file `test/widget_test.dart` (made by Flutter, no longer valid).
6. Run:
   ```
   flutter pub get
   dart run tool/patch_manifest.dart
   flutter analyze
   flutter test
   ```
   Paste any error to Claude exactly as shown.
7. Upload to GitHub:
   ```
   git add .
   git commit -m "Batch 1"
   git branch -M main
   git push -u origin main
   ```
8. On GitHub open the **Actions** tab → latest run → at the bottom download
   `saralbook-kids-apk` (install on a phone) and `saralbook-kids-aab` (for Google Play later).

## Notes
- The APK is signed with a temporary debug key for now. Proper release signing is Batch 11.
- Voices: Hindi speech needs a Hindi voice installed on the phone (Settings → Text-to-speech).
- Hindi text uses the phone's built-in Devanagari font. A bundled font can be added later.
