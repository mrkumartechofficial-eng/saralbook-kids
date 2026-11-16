# Data safety, target audience and content rating guidance

These answers match what the app actually does (version 1.0). If you ever add a library or feature, re-check them.

## Facts about the app (from the source code)
- No internet permission (removed on purpose, and the build fails if it appears).
- No ads, no analytics, no crash-reporting, no tracking, no social features, no accounts.
- No camera, microphone, location, contacts or storage permissions.
- Stored ON THE PHONE ONLY: chosen language, voice on/off, levels, stars and answer counts.
- Voice uses the phone's built-in text-to-speech engine. The app sends nothing anywhere.

## Play Console → Policy → App content

### Privacy policy
Paste the web address of your hosted privacy policy (see `5_publishing_guide.md`, step "Privacy policy page").

### Ads
"Does your app contain ads?" → **No**

### App access
"All functionality is available without special access" → **Yes** (no login needed). Tell reviewers the Parent Zone gate is a multiplication question (for example 7 x 8) so they can open it.

### Data safety form
- "Does your app collect or share any of the required user data types?" → **No**
- Because nothing is collected or shared, the remaining questions are skipped.
- Optional text for the review team: "The app is fully offline and has no INTERNET permission. Game progress is stored only on the device."

### Target audience and content
- Target age groups: select **5 and under** and **6-8**. (The app is designed for ages 3-8.) Do not select older groups.
- "Appeals to children": **Yes**
- Ads: **No**
- The app therefore falls under the Google Play **Families Policy**. See the checklist below.

### Content rating (IARC questionnaire)
Answer honestly for the real content: no violence, no scary content, no sexual content, no profanity, no gambling or simulated gambling, no user-generated content, no sharing of location, no purchases, no chat. Google then assigns the rating - do not assume which one.

### Other declarations
- Government app: No. News app: No. Health features: No. Financial features: No.
- Advertising ID: the app does not use it (answer **No** / not used).

## Families Policy checklist (tick before submitting)
- [ ] Target audience selected honestly (5 and under, 6-8)
- [ ] Store listing, icon and screenshots are appropriate for children
- [ ] No ads and no ad SDKs in the app
- [ ] No analytics or tracking SDKs (the app only uses: flutter, provider, shared_preferences, flutter_tts)
- [ ] No location, camera, microphone, contacts permissions
- [ ] No device identifiers transmitted (the app transmits nothing)
- [ ] No social or chat features; no links leading children out of the app
- [ ] Privacy policy is live on a public web page and matches the app
- [ ] Data safety form says "No data collected or shared"
- [ ] Parent Zone (grown-ups-only) is separated from child play by the gate
- [ ] Hindi and English content checked by a Hindi-speaking adult
- [ ] Not claiming "Teacher Approved" or any Google endorsement
- [ ] Test on a real phone with Wi-Fi and mobile data OFF (airplane mode)

Google may review the app and can decide the audience is different from what you declared. Policies change; always re-read the current Families Policy before submitting.
