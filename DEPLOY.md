Deployment & CI quick-steps
===========================

This file collects the exact commands and checks to (A) fix large `git push` failures, (B) deploy Cloud Functions reliably via CI, and (C) run the Flutter app locally for verification.

1) Fix `git push` RPC 408 / remote disconnect (Windows PowerShell)

Increase buffers and repack the repo, then retry push:

```powershell
git config --global http.postBuffer 524288000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
git gc --aggressive --prune=now
git repack -a -f -d
git push -u origin main
```

If HTTPS remains flaky, switch to SSH remote (recommended):

```powershell
# replace remote with your SSH URL
git remote set-url origin git@github.com:Zubair168/ecommerecstore.git
git push -u origin main
```

2) CI-based Cloud Functions deploy (GitHub Actions)

We already added `.github/workflows/deploy-functions.yml` that uses Node 20 and deploys `functions/` on push to `main`.

Required repository secrets (GitHub):
- `FIREBASE_TOKEN` — short-lived token from `firebase login:ci` (or use service account in CI)
- `FIREBASE_PROJECT` — your Firebase project id
- `ADMIN_SECRET` — secret for the HTTP helper `saveToken` (optional but recommended)

To create a `FIREBASE_TOKEN` locally:

```bash
npm install -g firebase-tools
firebase login:ci
# copy the token printed and add it to GitHub Secrets
```

3) Deploy functions locally (if you prefer not to use CI)

```powershell
cd functions
npm ci
npm run build
firebase deploy --only functions --project <PROJECT_ID>
```

4) Save the device FCM token to a user (quick test using HTTP function)

After deploying functions, call the `saveToken` endpoint to write the token to `users/{uid}.fcmToken`:

```bash
curl -X POST https://<REGION>-<PROJECT_ID>.cloudfunctions.net/saveToken \
  -H "Content-Type: application/json" \
  -H "x-admin-secret: <ADMIN_SECRET>" \
  -d '{"uid":"<UID>","token":"<FCM_TOKEN>"}'
```

5) Run the Flutter app locally (verify everything)

Make sure `android/app/google-services.json` is present and SHA fingerprints are added in Firebase console for Google Sign-In. Then:

```powershell
flutter pub get
flutter analyze --no-fatal-infos
flutter run -d <device-id>
```

6) Notes & troubleshooting
- If `npm run build` fails with TypeScript typing errors from transitive deps, ensure Node 20 is used (we added `.nvmrc`) or use the CI workflow which uses Node 20.
- For persistent push errors, try from another network or use GitHub Desktop / SSH.

If you want, I will:
- (A) attempt the `git push` retry commands here (I can't run them from this environment), or
- (B) update the repo to add a small `scripts/` helper to automate token creation and deploy, or
- (C) mark the push+node tasks done and move to `Products` implementation.
