// Inject Google Scholar citation-count badges into the publications list.
// Reads data/scholar.json (refreshed by tools/update_citations.py) and
// matches entries to .pub elements by normalized title.
(function () {
  const norm = (s) =>
    (s || "")
      .toLowerCase()
      .replace(/[^a-z0-9 ]+/g, " ")
      .replace(/\s+/g, " ")
      .trim();

  fetch("data/scholar.json")
    .then((r) => (r.ok ? r.json() : Promise.reject(r.status)))
    .then((data) => {
      const papers = data.papers.map((p) => ({ ...p, key: norm(p.title) }));
      const match = (key) =>
        papers.find(
          (p) =>
            p.key === key ||
            p.key.startsWith(key.slice(0, 60)) ||
            key.startsWith(p.key.slice(0, 60))
        );
      document.querySelectorAll(".pub[data-title]").forEach((pub) => {
        // data-scholar-alt lists other titles the same work appears under on
        // Scholar (e.g. a preprint not yet merged into the published entry);
        // separate with " | ". Hits are de-duplicated, so counts stay right
        // once Scholar merges the records.
        const keys = [pub.dataset.title]
          .concat((pub.dataset.scholarAlt || "").split("|"))
          .map(norm)
          .filter(Boolean);
        const hits = [...new Set(keys.map(match))].filter((h) => h && h.cites);
        if (!hits.length) return;
        const cites = hits.reduce((n, h) => n + h.cites, 0);
        const side = pub.querySelector(".pub-side");
        if (!side) return;
        const a = document.createElement("a");
        a.className = "cite-badge";
        a.href = (hits.length === 1 && hits[0].cites_url) || data.profile;
        a.target = "_blank";
        a.rel = "noopener";
        a.title = `Google Scholar, as of ${data.updated}`;
        a.textContent = `${cites.toLocaleString()} citation${cites === 1 ? "" : "s"}`;
        side.appendChild(a);
      });
    })
    .catch(() => {}); // no JSON, no badges — page still works
})();
