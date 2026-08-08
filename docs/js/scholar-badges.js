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
      document.querySelectorAll(".pub[data-title]").forEach((pub) => {
        const key = norm(pub.dataset.title);
        if (!key) return;
        const hit = papers.find(
          (p) =>
            p.key === key ||
            p.key.startsWith(key.slice(0, 60)) ||
            key.startsWith(p.key.slice(0, 60))
        );
        if (!hit || !hit.cites) return;
        const side = pub.querySelector(".pub-side");
        if (!side) return;
        const a = document.createElement("a");
        a.className = "cite-badge";
        a.href = hit.cites_url || data.profile;
        a.target = "_blank";
        a.rel = "noopener";
        a.title = `Google Scholar, as of ${data.updated}`;
        a.textContent = `${hit.cites.toLocaleString()} citation${hit.cites === 1 ? "" : "s"}`;
        side.appendChild(a);
      });
    })
    .catch(() => {}); // no JSON, no badges — page still works
})();
