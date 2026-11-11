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
| Menu voice — "Stuff It!", "Flavors 4 All Occasions" | photograph of the truck's own printed menu board |
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

### "Wit" / "Witout"

The truck's own board reads *'Order Up "Wit" or "Witout" Onions'* — the
Philadelphia way of ordering a cheesesteak, and a real piece of the brand.
Earlier drafts carried that spelling through the hero, the marquee and every
dish description.

**It is gone.** On 2026-11-09 it was flagged as reading like a misspelling, so
every instance on the page now says "with" / "without". The board photograph
in the menu section still shows the original wording, which is the honest
place for it — it is a photograph of their sign, not a styling choice.

Do not put it back without asking. If the owner wants it, it is a find and
replace, and the hero headline and menu heading were rewritten around the
longer words so both would need adjusting back.

---

## 2. The images

Eleven WebP files and two MP4 clips, 2.0 MB total, of which a first visit
downloads roughly 300 KB — everything else is lazy. Originals were pulled at
full resolution (`_o` suffix on the StreetFoodFinder CDN) and resized with
Pillow. Section 8 covers what was AI-processed.

| File | Shows | Used for |
|---|---|---|
| `hero-truck.webp` | the trailer, window open, brick alley | hero above 1200px |
| `hero-truck-sm.webp` | same crop, smaller | hero 820–1200px + gallery |
| `hero-portrait.webp` | the trailer's branded side | hero below 820px |
| `truck-event.webp` | customers at the window | catering + gallery |
| `truck-park.webp` | trailer by a pond, flags behind | story + gallery |
| `menu-board.webp` | the printed board on the truck | menu section |
| `food-steak.webp` / `-sm.webp` | cheesesteak close-up, 1280px and 640px | menu feature, cheesesteaks |
| `food-pretzel.webp` / `-sm.webp` | pretzel bites, 1280px and 640px | menu feature, munchies |
| `food-steak.mp4` | 4.0 s seamless loop, 960px, 274 KB | plays over the cheesesteak still |
| `food-pretzel.mp4` | 4.5 s seamless loop, 960px, 271 KB | plays over the pretzel still |
| `logo.webp` | the wordmark, upscaled, background keyed out | nav + footer + 404 |

**The hero is full-bleed at every width, and it crops the trailer.** That is
deliberate and it was asked for. A stacked variant was built — words on navy
with the whole trailer underneath at its own aspect ratio — and then reverted
on 2026-11-09 in favour of the full-bleed look. If you
ever want it back, it was a single `@media (max-width:1100px)` block; the
git history has it.

**The two food photos are on the page**, as the two feature blocks in the
menu. They came from the business's published gallery at 560×560; they were
upscaled to 2160×2160 and are served at 1280 and 640. Shot on a styled
surface, they look like supplied stock rather than the truck's own plate, so
both are labelled **"Serving suggestion"** on the page, which is honest
either way, and both carry a `[CONFIRM]` marker. Swap them for real plate
photography when the owner sends it. If you do, **delete the matching
`.mp4` and its `<video>` tag too** — each clip was generated from its still
and would no longer match.

The Facebook cover photo is a good full-width cheesesteak shot and would make
a strong second hero — it is behind a login wall, so ask the owner for the file.

Converter, if more images arrive:

```bash
python -I <scratchpad>/tools/towebp.py  src-dir  out-dir  max-width  [quality]
```

---

## 3. The `[CONFIRM]` markers

**`index.html` — the schedule dates.**
Last refreshed from StreetFoodFinder on 2026-11-09. They are in the markup as
`data-date="YYYYMMDD"`, and `prelaunch-check.sh` fails if any has passed —
it caught the 7 November date four days after it was written, which is what
it is for. Two options: keep them current by hand, or delete the cards and
leave only the live-schedule link. The link is already there either way.

The grid uses `auto-fit`, so the number of cards can change without leaving
an orphan on its own row. Three gigs make three columns, four make four.

**`index.html` — University Eatz & Arcade.**
The trailer wrap reads *"Visit Our Restaurant — 3701 Montgomery rd,
Cincinnati Ohio 45207"* and carries a University Eatz & Arcade badge.
Press coverage of that venue (opened September 2025, at Xavier) names
Mike Martin, Brad Baker and Alan Pyrcz as its operators and does not mention
East Coast Eatz. The truck advertises the place; the exact relationship is
not established. **Confirm it with the owner or delete the block.** It is the
only claim on the page that rests on one source.

**`index.html` ×2 — the two food photographs.** See section 2.

---

## 4. Deploying

### Where it is right now

**Live as a demo since 2026-11-11:**
**https://juliusjackson422-dev.github.io/east-coast-eatz-site/**

Repository `juliusjackson422-dev/east-coast-eatz-site`, public, GitHub Pages
serving `main` from `/`. A push to `main` redeploys in about half a minute.

Verified on the live URL: the page and all thirteen assets answer 200 over
HTTPS, both clips are served as `video/mp4` and honour Range requests, an
unknown path returns this site's own 404 page, and `noindex` is in the
served markup.

It is a **demo**, not a launch. `noindex` stays on and `prelaunch-check.sh`
still reports NOT READY, both deliberately — see section 0.

The repository had to be public: on the free plan GitHub Pages refuses a
private one (*"Your current plan does not support GitHub Pages for this
repository"*), the same limit that caught `therapeutic-cleaning`.
**Cloudflare Pages** serves private repositories on the free plan and is
the route to the real domain anyway — see below.

### The destination

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
- **Real motion in the food.** Each feature photo has a short seamless video
  loop on top of it: cheese sauce running and steam lifting off the
  cheesesteak, one faint wisp crossing the pretzels. The clip is fetched only
  when it is within 250px of the viewport, fades in once it is actually
  playing, and pauses when scrolled away.
- Underneath, the still keeps **a slow push-in**, 22 seconds end to end, and
  **drawn steam** above the plate — blurred discs on their own durations and
  delays. That is the fallback: it is what shows before the clip arrives, on
  Save-Data or a 2g connection, and whenever the clip fails. The drawn steam
  fades out once the real clip is live.
- **A gold rule that draws itself** under each dish name as the card arrives.
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

A first visit downloads roughly 300 KB: the document, the logo and the hero
image, which is the LCP element and loads with `fetchpriority="high"`.
Everything below the fold is lazy, including both clips, so the 2.0 MB total
is only paid by someone who scrolls the whole page. The only external
requests are two Google Fonts.

### Two layout bugs worth knowing about, both fixed 2026-11-11

- **`img{height:auto}` was missing.** Every `<img>` carries width/height
  attributes, and those double as presentational hints: an image told
  `width:100%` kept its attribute height in pixels, so `aspect-ratio` never
  applied. It was quietly distorting the catering photo, the three gallery
  photos, the menu board and the footer logo, and had been since day one.
- **Phones could scroll sideways.** The gold glow behind each food photo
  bled 14% past its box, which on a stacked phone layout is past the edge of
  the screen. Sections now clip horizontally and the glow no longer bleeds
  sideways when stacked.

Both were found by a scratch harness that loads the page in headless Edge at
1440 and 390, scrolls it like a visitor, and reports whether each clip really
plays and whether every image box has the ratio it should.

---

## 7. Ground rules held throughout

- No invented reviews, ratings, credentials, licences or founding dates.
- No invented service areas. The only places named — Liberty Township,
  Fairfield, Cincinnati — come from the trailer, from booked events, or from
  the business's own listing.
- No generated subjects. Every photograph is one the business published.
  Three assets were AI-processed from those photographs — see section 8 —
  and the page footer says so in plain words.
- No form pretends to send anything, because there is no form.
- Anything unverified is marked `[CONFIRM]`.

---

## 8. What Higgsfield was used for

Added 2026-11-11. 67.25 credits spent.

**Shipped**

| Asset | What was done | Cost |
|---|---|---|
| `food-steak.webp`, `food-pretzel.webp` | upscaled 560 → 2160px (Bytedance upscaler). Checked at pixel level: real detail, nothing invented. | 2 + 2 |
| `logo.webp` | the 499×146 crop off the printed board upscaled to 7357px, then the blue plate keyed out. Letterforms unchanged, the old blue fringe and jagged edges gone. | 2 |
| `food-steak.mp4` | Kling 3.0 Pro, image-to-video from the upscaled still. 5.8 MB as delivered; crossfaded into a 4 s seamless loop and re-encoded to 274 KB. | 8.75 |
| `food-pretzel.mp4` | same route, 4.5 s loop, 271 KB. Third attempt — see below. | 8.75 |

**Generated and thrown away**, so nobody repeats it:

- **Three clips with the start and end frame pinned to the same photo**
  (26.25 credits). Meant to guarantee a seamless loop; what it guarantees is
  a still. Measured frame by frame: under 0.1% of the picture moved. Release
  the end frame and build the loop afterwards with a crossfade instead.
- **A pretzel clip with heavy steam** (8.75). Shot from overhead, steam
  rising toward the lens reads as patches of fog. The kept version asks for
  "a few very faint, thin wisps".
- **A hero clip of the trailer** (8.75). The lettering survived intact, which
  was the worry. But the hero's dark overlay hides the sky and the roof vent,
  so the only motion left visible was a slow camera drift — not worth a
  megabyte and a softer picture than the sharp still. The hero stays a still.

The loops were cut and compressed with ffmpeg in Higgsfield's cloud sandbox,
because this machine has no ffmpeg. Nothing was installed locally.
