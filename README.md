# RepLiT — reportwhatslit

Every part of RepLiT in one repository (12 November 2026: "make the whole
system one GitHub repository named reportwhatslit").

| Folder | What it is | Came from |
|---|---|---|
| `backend/` | The FastAPI API (`backend/app`), the Supabase migrations (`backend/supabase/migrations`), the Admin console (`backend/admin-web`) and the APK download page (`backend/apk-web`) | [M2STZ-Crew/replit-backend](https://github.com/M2STZ-Crew/replit-backend) |
| `mobile/` | The Flutter app for Android and iPhone | [M2STZ-Crew/replit-android](https://github.com/M2STZ-Crew/replit-android) |

Both came in with their whole history (`git subtree`), so `git log -- backend/`
and `git blame` still reach every change back to the first commit.

## For now: the old repositories are still the live ones

Nothing deploys from here yet. Render, Vercel and the app's releases still
build from the two old repositories, which stay as they are: the backup the
switch was asked to keep ("if that merge fails, we still have a backup").

Until the switch, bring their newest `main` in with:

```bash
scripts/sync-from-old-repos.sh
```

## Switching over

Do these in order, one service at a time; each can be undone by pointing it
back at the old repository.

1. **Bring this repository up to date** with the sync script, after the open
   pull requests in the old repositories are merged.
2. **Render** (the API): in the service's settings, connect this repository,
   set *Root Directory* to `backend`, and deploy. The Dockerfile and
   `render.yaml` are in `backend/`.
3. **Vercel, Admin console**: connect this repository to the console's
   project and set *Root Directory* to `backend/admin-web`.
4. **Vercel, APK download page**: the project for
   `reportwhatslit-apk.vercel.app`, *Root Directory* `backend/apk-web`, no
   build command.
5. **GitHub Actions**: workflows only run from the root `.github/workflows/`.
   Move `mobile/.github/workflows/*` and `backend/.github/workflows/*` there,
   give each job `working-directory: mobile` (or `backend`) and `paths:`
   filters, and add the secrets they use in this repository's settings (the
   Android signing key, Firebase App Distribution, `IPA_ZIP_PASSWORD`,
   `RENDER_DEPLOY_HOOK_URL`, …). Secrets do not copy across repositories.
6. **App updates**: the app's "Check for updates" and the APK page read the
   releases of `M2STZ-Crew/replit-android`. Either keep publishing releases
   there, or release an app version that reads this repository's releases and
   publish one last release in the old one, so phones still on the old version
   find it.
7. **Archive the old repositories** (read-only) once everything builds from
   here.
