#!/usr/bin/env python3
"""Refresh Google Scholar citation counts -> data/scholar.json.

Scholar has no API; this parses the public profile page. Run it whenever you
want fresh counts (each site render does NOT need it — the page reads the
committed JSON):

    python3 tools/update_citations.py

For hands-off updates, run it on a schedule (cron / GitHub Action) and commit
the changed JSON. Scholar sometimes blocks datacenter IPs (Actions runners);
from a personal machine it essentially always works.
"""
import json
import pathlib
import re
import sys
import urllib.request
from datetime import date

USER = "XGtWgEwAAAAJ"
URL = (
    "https://scholar.google.com/citations?"
    f"user={USER}&hl=en&cstart=0&pagesize=100&sortby=pubdate"
)
UA = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0 Safari/537.36"
)
OUT = pathlib.Path(__file__).resolve().parent.parent / "data" / "scholar.json"

req = urllib.request.Request(URL, headers={"User-Agent": UA})
try:
    html = urllib.request.urlopen(req, timeout=30).read().decode("utf-8")
except Exception as e:  # noqa: BLE001
    sys.exit(f"Could not reach Google Scholar ({e}). Counts left unchanged.")

rows = re.findall(r'<tr class="gsc_a_tr">(.*?)</tr>', html, re.S)
papers = []
for row in rows:
    m_title = re.search(r'class="gsc_a_at"[^>]*>(.*?)</a>', row, re.S)
    m_cell = re.search(r'<td class="gsc_a_c">(.*?)</td>', row, re.S)
    m_cite = None
    if m_cell:
        m_cite = re.search(r'<a[^>]*href="([^"]*)"[^>]*>(\d+)</a>', m_cell.group(1), re.S)
    m_year = re.search(r'class="gsc_a_h[^"]*"[^>]*>(\d{4})?', row, re.S)
    if not m_title:
        continue
    title = re.sub(r"<[^>]+>", "", m_title.group(1)).strip()
    cites = int(m_cite.group(2)) if (m_cite and m_cite.group(2)) else 0
    cites_url = m_cite.group(1).replace("&amp;", "&") if m_cite else ""
    if cites_url.startswith("/"):
        cites_url = "https://scholar.google.com" + cites_url
    papers.append(
        {
            "title": title,
            "cites": cites,
            "cites_url": cites_url,
            "year": m_year.group(1) if (m_year and m_year.group(1)) else None,
        }
    )

if not papers:
    sys.exit("Scholar page fetched but no rows parsed (blocked or layout change).")

OUT.parent.mkdir(exist_ok=True)
OUT.write_text(
    json.dumps(
        {
            "updated": date.today().isoformat(),
            "profile": f"https://scholar.google.com/citations?user={USER}",
            "papers": papers,
        },
        indent=1,
    )
)
print(f"Wrote {OUT.relative_to(OUT.parent.parent)} — {len(papers)} papers, "
      f"{sum(p['cites'] for p in papers)} total citations.")
