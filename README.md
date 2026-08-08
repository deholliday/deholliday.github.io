# derekholliday.com

Personal academic site, built with [Quarto](https://quarto.org) and the
Holliday design system (PNW fog-and-forest palette, Fraunces + Cabinet
Grotesk).

## How it works

- Sources: `*.qmd` at the repo root, styled by `holliday-site.scss`.
- `quarto render` writes the finished site to `docs/`, which GitHub Pages
  serves (Settings → Pages → `master` / `docs`). `CNAME` is copied in
  automatically.
- `cv-pdf.qmd` renders `Holliday_CV.pdf` via Typst using the system-installed
  brand fonts; `cv.qmd` embeds it.
- Publication figures live in `research/figs/`; each paper on the research
  page is an accordion with abstract + figure. Google Scholar citation badges
  read `data/scholar.json` client-side.

## Updating

```sh
# refresh Google Scholar citation counts
python3 tools/update_citations.py

# rebuild the site into docs/
quarto render

git add -A && git commit -m "Update site" && git push
```

Citation counts change only when `update_citations.py` is re-run — run it
whenever (it takes ~2 seconds), then `quarto render` copies the fresh JSON
into `docs/`.

The wider design system (ggplot theme, Quarto slide theme, PowerPoint
template, icon set) lives in the private `theme_personal` folder; this repo
only carries the compiled site pieces.
