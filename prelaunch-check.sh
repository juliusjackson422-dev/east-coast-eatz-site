#!/usr/bin/env bash
# Reports everything standing between this package and a real-domain launch.
# Run from inside the site folder:  ./prelaunch-check.sh
# Exit 0 = clear to launch. Exit 1 = something below still needs doing.

cd "$(dirname "$0")" || exit 2
fail=0
say() { printf '%s\n' "$*"; }
bad() { printf '  [BLOCKS LAUNCH] %s\n' "$*"; fail=1; }
ok()  { printf '  [ok] %s\n' "$*"; }

say ""
say "Pre-launch check: $(basename "$PWD")"
say "============================================================"

say ""
say "1. Search engine visibility"
n=$(grep -rl 'name="robots"[^>]*noindex' --include='*.html' . 2>/dev/null \
    | grep -v '404.html' | wc -l)
if [ "$n" -gt 0 ]; then
  bad "noindex is still on $n page(s) — the site will be invisible to Google:"
  grep -rl 'name="robots"[^>]*noindex' --include='*.html' . 2>/dev/null \
    | grep -v '404.html' | sed 's/^/      /'
else
  ok "no stray noindex on indexable pages"
fi

if grep -q '^[[:space:]]*Disallow:[[:space:]]*/[[:space:]]*$' robots.txt 2>/dev/null; then
  bad "robots.txt still blocks the whole site (Disallow: /)"
else
  ok "robots.txt allows crawling"
fi

say ""
say "2. Unverified claims"
n=$(grep -ro '\[CONFIRM\]' --include='*.html' . 2>/dev/null | wc -l)
if [ "$n" -gt 0 ]; then
  bad "$n [CONFIRM] marker(s) left — each is a fact nobody has verified:"
  grep -rn '\[CONFIRM\]' --include='*.html' . 2>/dev/null \
    | cut -c1-110 | sed 's/^/      /'
else
  ok "no [CONFIRM] markers left"
fi

say ""
say "3. Contact details"
# The real number is (513) 739-7393. Anything in the 555-01xx range is fiction.
if grep -rqo '555-01[0-9][0-9]' --include='*.html' . 2>/dev/null; then
  bad "fictional 555-01xx phone number in the markup"
else
  ok "no fictional phone numbers"
fi

if grep -rq '739-7393\|739\.7393' --include='*.html' . 2>/dev/null; then
  ok "the real phone number is present"
else
  bad "the business phone number is missing from the markup"
fi

dom=$(grep -rni 'YOURDOMAIN\|example\.com' --include='*.html' --include='*.xml' --include='*.txt' . 2>/dev/null \
      | grep -vi 'placeholder="you@example\.com"')
if [ -n "$dom" ]; then
  bad "placeholder domain still referenced:"
  printf '%s\n' "$dom" | cut -c1-110 | sed 's/^/      /'
else
  ok "no placeholder domains"
fi

say ""
say "4. The schedule goes stale on its own"
# Four dates are hard-coded in index.html. A food truck site showing last
# month's events is worse than one showing none, so this is a hard block.
today=$(date +%Y%m%d)
stale=0
while read -r d; do
  [ -z "$d" ] && continue
  [ "$d" -lt "$today" ] && stale=$((stale + 1))
done <<EOF
$(grep -o 'data-date="[0-9]\{8\}"' index.html 2>/dev/null | grep -o '[0-9]\{8\}')
EOF
listed=$(grep -c 'data-date="' index.html 2>/dev/null)
if [ "${listed:-0}" -eq 0 ]; then
  say "  [warn] no data-date attributes found — cannot check the schedule automatically"
elif [ "$stale" -gt 0 ]; then
  bad "$stale of $listed listed dates are in the past — update them from"
  say "                  https://streetfoodfinder.com/EastCoastEatz"
else
  ok "all $listed listed dates are still upcoming"
fi

say ""
say "5. Page weight"
big=$(find . -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \) -size +300k 2>/dev/null)
if [ -n "$big" ]; then
  say "  [warn] images over 300 KB (not blocking):"
  printf '%s\n' "$big" | while read -r f; do
    printf '      %s  %s\n' "$(du -h "$f" | cut -f1)" "$f"
  done
else
  ok "no oversized images"
fi

total=$(du -sk . 2>/dev/null | cut -f1)
say "  [info] package is ${total} KB on disk"

say ""
say "============================================================"
if [ "$fail" -eq 0 ]; then
  say "CLEAR TO LAUNCH."
else
  say "NOT READY — fix the [BLOCKS LAUNCH] items above."
fi
say ""
exit "$fail"
