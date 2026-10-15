# hamptonlab.com

The Hampton Lab marketing site. It is a Rails app that is only ever run
locally: `deploy_github.sh` mirrors it into static HTML, which is committed to
the `prod` branch and served by Cloudflare Pages.

## Setup

- Ruby: see `.ruby-version`
- `bin/setup` installs gems, prepares the database and starts the server
- `bin/dev` runs the server on http://localhost:3000

## Checks

```sh
bin/rails test test:system   # unit + browser tests (needs Chrome)
bin/rubocop                  # style
bin/brakeman --no-pager      # security
bin/importmap audit          # JS dependency audit
```

CI (`.github/workflows/ci.yml`) runs all of these on every push to `master`
and every pull request.

## Deploying

1. Build the static site (starts and stops its own server on port 3000):

   ```sh
   ./deploy_github.sh                  # writes ./dist
   OUT_DIR=/tmp/site PORT=4100 ./deploy_github.sh
   ```

2. Replace the contents of the `prod` branch with the contents of `dist/` and
   push. Cloudflare Pages deploys `prod` automatically.

What ends up in the build:

- Every page reachable by links from `/` (currently `/`, `/process/`,
  `/founder_letter/`) plus their CSS, JS, fonts and images.
- `404.html`, rendered from `errors#not_found` (`/not_found` locally).
- `public/thumbnail.png`, `robots.txt`, `sitemap.xml` and `_headers`
  (Cloudflare response headers: CSP, HSTS, caching).

The blog, sign-in and password pages exist in the app but are not linked, so
they are not part of the static site.

## Notes

- Absolute URLs (canonical, Open Graph, JSON-LD) come from `SITE_URL` in
  `app/helpers/application_helper.rb`.
- Update the `<lastmod>` dates in `public/sitemap.xml` when page content
  changes.
- Project screenshots live in `app/assets/images` as `name.jpg` (1600w) and
  `name-800.jpg`, each with a `.webp` twin. To regenerate the WebP files:
  `cwebp -q 80 -m 6 name.jpg -o name.webp`.
