# East Coast Eatz — handover runbook

Philly cheesesteak food truck. Liberty Township, Ohio. Est. 2013.
Single-file static site, no build step, no framework, no JS dependencies.

```
index.html           the whole site
404.html             not-found page, keeps the phone number visible
robots.txt           Disallow: / while this is on a demo URL
sitemap.xml          points at eastcoasteatz.com
prelaunch-check.sh   run before launch — exits non-zero until the site is clean
img/                 9 images, 1.1 MB total, all WebP
```

Rebuild after editing the top-level source:

```bash
cd .. && ./build.sh eastcoasteatz.html site-eastcoasteatz
```

Do not edit `site-eastcoasteatz/index.html` directly — the next build overwrites it.

---

## 0. Read this before deploying

`prelaunch-check.sh` currently reports **NOT READY**, and that is correct.
Three things block a real launch:

1. **`noindex` is on** and `robots.txt` says `Disallow: /`. Deliberate. This is a
   real business; a demo URL must not get indexed as a copy of their site.
2. **Two `[CONFIRM]` markers** — see section 3.
3. The site is not on **eastcoasteatz.com** yet — see section 4.

Nothing else is blocking. Every fact, price and photograph on the page is real.

---

## 1. Where every fact came from

Nothing on this site was invented. No reviews, ratings, awards, counts,
founding claims or service areas were made up, and no imagery was generated.

| What | Source |
|---|---|
| Menu items, descriptions, prices | `streetfoodfinder.com/EastCoastEatz` **and** `bestfoodtrucks.com/truck/east-coast-eatz/menu` — two independent current listings, prices agree |
| Menu voice — "Wit"/"Witout", "Stuff It!", "Flavors 4 All Occasions" | photograph of the truck's own printed menu board |
| Phone, email | Facebook About + the trailer wrap |
| Liberty Township, OH 45011 | printed on the trailer door |
| Amoroso rolls from Philly | the trailer wrap + the StreetFoodFinder bio |
| Est. 2013 | Facebook About, StreetFoodFinder bio, and the logo itself |
| The four scheduled dates | `streetfoodfinder.com/EastCoastEatz`, read 2026-11-05 |
| Social handles | the printed menu board |
| Every photograph | the business's own, from their StreetFoodFinder gallery |

The menu board photo shows **older prices** ($9/$10) than the two live
listings ($10/$11). The page uses the live prices. The board is on the page
because the wording on it is the business's own voice, not because of the numbers.

---

## 2. The images

Nine WebP files, 1.1 MB total. Originals were pulled at full resolution
(`_o` suffix on the StreetFoodFinder CDN) and resized with Pillow.

| File | Shows | Used for |
|---|---|---|
| `hero-truck.webp` | the trailer, window open, brick alley | desktop hero |
| `hero-truck-sm.webp` | same, smaller | tablet hero + gallery |
| `hero-portrait.webp` | the trailer's branded side | mobile hero |
| `truck-event.webp` | customers at the window | catering + gallery |
| `truck-park.webp` | trailer by a pond, flags behind | story + gallery |
| `menu-board.webp` | the printed board on the truck | menu section |
| `food-steak.webp` | cheesesteak close-up (560px) | not currently placed |
| `food-pretzel.webp` | pretzel bites (560px) | not currently placed |
| `logo.webp` | the wordmark, background keyed out | nav + footer + 404 |

**The two food photos are not on the page.** At 560×560 they are the only
images the business has published at that size, and they look like stock
rather than their own plate. The menu is typographic instead, which reads
better than padding it with pictures that may not be theirs. If the owner
sends real plate photography, that is where it goes.

The Facebook cover photo is a good full-width cheesesteak shot and would make
a strong second hero — it is behind a login wall, so ask the owner for the file.

Converter, if more images arrive:

```bash
python -I <scratchpad>/tools/towebp.py  src-dir  out-dir  max-width  [quality]
```

---

## 3. The two `[CONFIRM]` markers

**`index.html` — the four schedule dates.**
Read from StreetFoodFinder on 2026-11-05. They are in the markup as
`data-date="YYYYMMDD"`, and `prelaunch-check.sh` fails if any has passed.
Two options: keep them current by hand, or delete the four cards and leave
only the live-schedule link. The link is already there either way.

**`index.html` — University Eatz & Arcade.**
The trailer wrap reads *"Visit Our Restaurant — 3701 Montgomery rd,
Cincinnati Ohio 45207"* and carries a University Eatz & Arcade badge.
Press coverage of that venue (opened September 2025, at Xavier) names
Mike Martin, Brad Baker and Alan Pyrcz as its operators and does not mention
East Coast Eatz. The truck advertises the place; the exact relationship is
not established. **Confirm it with the owner or delete the block.** It is the
only claim on the page that rests on one source.

---

## 4. Deploying

The business owns **eastcoasteatz.com**. Right now it resolves to Wix
(`Server: Pepyaka`) and returns **404** — so there is a domain with nothing
on it. That is the destination.

Because the domain is already pointed at Wix, moving it means changing
nameservers or DNS records inside the owner's Wix account. That is theirs to
do, not something to action from here.

Recommended: **Cloudflare Pages**, Framework preset **None**, build command
empty, output directory `/`. Cloudflare Pages serves private repos on the
free plan; GitHub Pages does not. The full handover process — including why
Cloudflare Pages projects cannot be transferred between accounts — is in
`site-bgtowing/README.md`.

For a demo link to show the owner first, the pattern used by the other two
sites works: a public repo under `juliusjackson422-dev`, GitHub Pages on,
`noindex` left in place.

### Launch sequence

1. Confirm or delete the University Eatz block.
2. Refresh the four schedule dates.
3. Remove `<meta name="robots" content="noindex, nofollow">` from `index.html`
   **and** from the top-level `eastcoasteatz.html` source, or the next
   rebuild puts it back.
4. Replace `robots.txt` with the three-line version written in its comments.
5. Run `./prelaunch-check.sh` until it exits 0.
6. Point the domain, then submit `https://eastcoasteatz.com/sitemap.xml`
   in Google Search Console.

---

## 5. What the site does not do

Honest list, so nothing gets promised that is not there:

- **No online ordering.** Needs a POS account — Toast, Square, ChowNow.
  Nobody has said which, if any, they use.
- **No contact form.** Every call to action is a `tel:` link, a `mailto:`
  link, or an outbound link to Best Food Trucks. No form on this site can
  silently fail, because there is no form.
- **No live schedule feed.** StreetFoodFinder has no public API. The four
  dates are hand-entered and the page links out for the live version.
- **No Instagram feed.** Would need a token and a server; both would rot.

The highest-value addition, if the owner wants one, is **online ordering** —
a food truck with a queue converts far better with order-ahead. That is an
account decision, not a code one.

---

## 6. Animation notes

The brief was "the best" animations, fast. What is here:

- A **masked line reveal** on every headline — the words ride up out of a
  clipping box with a slight rotation, staggered per line.
- An **image wipe** on every photograph — a panel retracts while the picture
  settles back from a 1.16 scale.
- **Hero parallax** — the picture drifts down at 0.22× scroll, the words up
  at 0.07×, and the block fades out across the first three-quarters of a
  viewport.
- **Pointer tilt** on the menu cards — a 7° perspective rotation with a glow
  that tracks the cursor.
- An **ambient blue flame** along the bottom of the hero: seven blurred,
  screen-blended tongues under a vertical mask, each on its own duration and
  delay so they never sync up.
- An **infinite ribbon** of the truck's own slogans, paused on hover.

Rules the implementation sticks to:

- **Only `transform` and `opacity` are animated.** Nothing animated triggers
  layout or paint, so it all runs on the compositor.
- **One `requestAnimationFrame` loop** drives scroll and pointer work, behind
  a dirty flag, with a passive scroll listener. No layout is read inside it —
  the tilt measures each card once, on `pointerenter`.
- **Tilt is gated** behind `(hover:hover) and (pointer:fine)`, so touch
  devices never pay for it.
- **`prefers-reduced-motion` switches all of it off** — flames hidden, ribbon
  stopped, parallax disabled, every reveal shown in its final state.

Total page weight is about 1.2 MB, most of it the hero image, which is the
LCP element and loads with `fetchpriority="high"`. Everything below the fold
is lazy. The only external requests are two Google Fonts.

---

## 7. Ground rules held throughout

- No invented reviews, ratings, credentials, licences or founding dates.
- No invented service areas. The only places named — Liberty Township,
  Fairfield, Cincinnati — come from the trailer, from booked events, or from
  the business's own listing.
- No generated imagery. Every photograph is the business's own.
- No form pretends to send anything, because there is no form.
- Anything unverified is marked `[CONFIRM]`.
