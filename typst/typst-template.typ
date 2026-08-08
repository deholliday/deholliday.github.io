// holliday-cv — Typst template mirroring the site brand (_brand.yml)
#let hh-paper = rgb("#F9F8F4")
#let hh-hairline = rgb("#E4E2D9")
#let hh-mist = rgb("#D9D6CB")
#let hh-ink = rgb("#1F2B27")
#let hh-ink-muted = rgb("#55645D")
#let hh-ink-faint = rgb("#71807A")
#let hh-spruce = rgb("#24352F")
#let hh-larch = rgb("#D9A84E")
#let hh-fir = rgb("#17754B")

// numbered entry with a fixed (descending-friendly) number
#let pub(n, body, ..notes) = grid(
  columns: (1.7em, 1fr),
  column-gutter: 0.75em,
  row-gutter: 0.45em,
  align(right + top, text(fill: hh-ink-faint, size: 8.8pt)[#n.]),
  {
    body
    for nt in notes.pos() {
      linebreak()
      text(size: 8.6pt, fill: hh-ink-muted)[#text(fill: hh-fir, weight: 700)[–] #nt]
    }
  },
)

#let holliday-cv(
  title: none,
  contact: (),
  updated: none,
  body,
) = {
  set page(
    paper: "us-letter",
    fill: hh-paper,
    margin: (top: 0.85in, bottom: 0.9in, x: 1in),
    footer: context [
      #set text(font: "Cabinet Grotesk", size: 7.2pt, fill: hh-ink-faint)
      #line(length: 100%, stroke: 0.5pt + hh-hairline)
      #v(4pt)
      #grid(columns: (1fr, 1fr, 1fr),
        align(left)[#title · Curriculum Vitae],
        align(center)[#counter(page).display("1 / 1", both: true)],
        align(right)[#updated],
      )
    ],
  )
  set text(font: "Cabinet Grotesk", size: 9.6pt, fill: hh-ink)
  set par(leading: 0.62em, spacing: 0.82em, justify: false)

  // links in fir, quiet
  show link: it => text(fill: hh-fir, it)

  // Cabinet Grotesk ships no italics; borrow Hanken (the OFL metric cousin)
  show emph: it => text(font: "Hanken Grotesk", style: "italic", it.body)

  // section headings: Fraunces over a hairline (gap ≈ 0.28× font size, like the site)
  show heading.where(level: 1): it => block(above: 1.3em, below: 0.55em,
    stack(dir: ttb, spacing: 3.5pt,
      text(font: "Fraunces 72pt Soft", weight: 600, size: 13.2pt, fill: hh-spruce, it.body),
      line(length: 100%, stroke: 0.6pt + hh-hairline),
    )
  )
  // subsections (institutions): bold sans
  show heading.where(level: 2): it => block(above: 1.05em, below: 0.55em)[
    #set text(font: "Cabinet Grotesk", weight: 700, size: 10pt, fill: hh-ink)
    #it.body
  ]

  // numbered lists (publications): hanging indent, tight
  set enum(indent: 0pt, body-indent: 0.75em, spacing: 0.85em,
           numbering: n => text(fill: hh-ink-faint, size: 8.8pt)[#n.])
  set list(indent: 0pt, body-indent: 0.7em, spacing: 0.55em,
           marker: text(fill: hh-fir, weight: 700)[–])

  // ---- header ----
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    stack(dir: ttb, spacing: 7pt,
      text(font: "Fraunces 72pt Soft", weight: 600, size: 25pt, fill: hh-spruce)[#title],
      box(width: 34pt, height: 3pt, radius: 1.5pt, fill: hh-larch),
    ),
    [
      #set text(size: 8.8pt, fill: hh-ink-muted)
      #set par(leading: 0.5em)
      #for c in contact [
        #let ctext = c.text.replace("\\@", "@").replace("\\", "")
        #if c.at("href", default: none) != none [
          #link(c.href)[#ctext] \
        ] else [
          #ctext \
        ]
      ]
    ],
  )
  v(0.4em)

  body
}
