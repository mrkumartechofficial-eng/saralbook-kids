# Publishing guide: from this repository to Google Play

## 0. What is true right now (checked November 2026)
- A Google Play developer account costs a one-time fee and needs identity verification.
- If your PERSONAL account was created after 13 November 2023 you must first run a **closed test with at least 12 testers, opted in continuously for 14 days**, then apply for production access. Organisation accounts are exempt. Plan about 3 weeks for the first launch. Re-check Google's page "App testing requirements for new personal developer accounts" because rules change.
- Google is also rolling out **Android developer verification** for app developers. Check developer.android.com for the current rules and dates for your country.

## 1. Privacy policy page (free, using GitHub Pages)
1. Open `docs/index.html` in this repository, click the pencil, and replace `YOUR-EMAIL@example.com` with a real contact email. Commit.
2. Repository **Settings → Pages**. Under "Build and deployment" choose **Deploy from a branch**, branch `main`, folder `/docs`, Save.
3. After a minute your policy is live at `https://YOUR-USERNAME.github.io/saralbook-kids/`. Use this address in Play Console.
(A repository must be public for free GitHub Pages on a free account.)

## 2. Screenshots
Install the APK on your phone, open the app and take at least 2 phone screenshots (6-8 is better): Home, level map, a question, celebration screen, Rewards, Hindi home. If you have a tablet, add tablet screenshots too. They must be real screenshots of the app.

## 3. Create the app in Play Console
1. Play Console → **Create app**: name "SaralBook Kids – Play & Learn", default language English, **App**, **Free**. Accept the declarations.
2. Fill **App content** (Policy → App content) using `2_data_safety_and_target_audience.md`.
3. **Store listing**: paste text from `1_store_listing.md`, upload icon, feature graphic and screenshots. Add the Hindi translation.
4. **Set up closed testing** (Test and release → Testing → Closed testing): create a track, upload the signed `.aab`, add testers (an email list / Google Group), copy the opt-in link and share it with 12+ real people (family, friends, teachers). Testers must keep it installed and opt in for 14 days.
5. After 14 days, **Apply for production**, then create a production release with the same (or a newer) AAB, add release notes from `3_release_notes.md`, and send for review.

## 4. Before every upload - quick checks
- [ ] Phone test in airplane mode: all 12 games work
- [ ] English and Hindi both work; switching language works in the middle of a game
- [ ] Hindi text, number names and voice checked by a Hindi speaker
- [ ] Build number in `pubspec.yaml` is higher than the last upload
- [ ] The Actions log says "OK: no INTERNET permission." and "Signed APK and AAB created."

## 5. Honest notes
- Google decides approval. Nothing here guarantees acceptance, and "Teacher Approved" is a separate optional programme you can apply for later - do not claim it.
- The app uses emoji for pictures, so very old Android versions (before Android 9) may show empty boxes for some pictures.
