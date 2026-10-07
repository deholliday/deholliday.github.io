#!/usr/bin/env python3
"""Quarto post-render: version the CV links in docs/cv.html.

Browser PDF viewers cache the embedded CV by URL, so a rebuilt PDF can keep
showing the old copy. Appending ?v=<hash of the PDF> changes the URL only
when the PDF itself changes. Idempotent; safe to run on any render.
"""
import hashlib
import pathlib
import re

DOCS = pathlib.Path(__file__).resolve().parent.parent / "docs"
pdf, page = DOCS / "Holliday_CV.pdf", DOCS / "cv.html"
if pdf.exists() and page.exists():
    v = hashlib.sha1(pdf.read_bytes()).hexdigest()[:10]
    html = page.read_text(encoding="utf-8")
    new = re.sub(r"Holliday_CV\.pdf(\?v=[0-9a-f]+)?", f"Holliday_CV.pdf?v={v}", html)
    if new != html:
        page.write_text(new, encoding="utf-8")
