# Trying new versions on your phone

Every time the CI builds the Android app (on each pull request and on `main`),
it sends the build to your phone through Firebase App Distribution. You get a
notification, tap it, and the new version installs over the old one.

## One-time setup

1. **Turn on App Distribution.** In the [Firebase console](https://console.firebase.google.com/project/family-habits-77d62/appdistribution),
   open App Distribution and click **Get started**.
2. **Create the tester group.** In App Distribution, open **Testers & Groups**,
   click **Add group**, name it `family`, and add your email address (and anyone
   else who should get test builds).
3. **Create a key the CI can use.**
   - Open [Service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts?project=family-habits-77d62)
     and click **Create service account**. Name it `github-ci`, click **Create and continue**.
   - For the role, pick **Firebase App Distribution Admin**, click **Continue**, then **Done**.
   - Click the new account, open the **Keys** tab, choose **Add key → Create new key → JSON**.
     A file downloads.
4. **Give the key to GitHub.** In the repository, open
   [Settings → Secrets and variables → Actions](https://github.com/AmoreMio3/family-habits/settings/secrets/actions),
   click **New repository secret**, name it `FIREBASE_SERVICE_ACCOUNT`, and paste
   the whole contents of the downloaded file. Then delete the file from your computer.
5. **On your phone,** wait for the first build after the secret is added.
   Firebase emails the invitation only when it has a build to send (check spam
   too). Open it on the phone: it installs the Firebase App Tester app, which
   shows every build and notifies you of new ones.

## Notes

- The first time, uninstall any copy of the app you installed from GitHub
  before. Builds now share one test signature, so after that, updates install
  over each other without uninstalling.
- To use a different tester group, set a repository variable named
  `TESTER_GROUP` to the group's alias.
- If the secret is missing, the CI still builds the app and simply skips this step.
