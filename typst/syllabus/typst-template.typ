// holliday-syllabus — Typst template mirroring the site brand (_brand.yml)
// Sibling of typst/typst-template.typ (the CV); same tokens and type system.
#let hh-paper = rgb("#F9F8F4")
#let hh-paper-2 = rgb("#F1F0EA")
#let hh-hairline = rgb("#E4E2D9")
#let hh-mist = rgb("#D9D6CB")
#let hh-ink = rgb("#1F2B27")
#let hh-ink-muted = rgb("#55645D")
#let hh-ink-faint = rgb("#71807A")
#let hh-spruce = rgb("#24352F")
#let hh-larch = rgb("#D9A84E")
#let hh-fir = rgb("#17754B")
#let hh-moss = rgb("#BCC8AA")

// due-date flag: larch-edged strip for deadlines in the schedule
#let due(body) = block(
  above: 0.95em, below: 0.95em, width: 100%,
  inset: (x: 0.8em, y: 0.55em),
  fill: hh-paper-2,
  stroke: (left: 2pt + hh-larch),
  radius: (top-right: 4pt, bottom-right: 4pt),
  text(size: 9pt)[#text(weight: 700, fill: hh-spruce)[Due] #h(0.5em) #body],
)

// course description: moss-edged card under the header (echoes the site's
// pub-abstract treatment)
#let course-description(body) = block(
  above: 1.2em, below: 1.4em, width: 100%,
  inset: (x: 1em, top: 0.8em, bottom: 0.9em),
  fill: hh-paper-2,
  stroke: (left: 3pt + hh-moss),
  radius: (top-right: 6pt, bottom-right: 6pt),
  [
    #text(size: 7.8pt, weight: 700, fill: hh-ink-faint, tracking: 0.07em)[COURSE DESCRIPTION]
    #v(0.15em)
    #body
  ],
)

#let holliday-syllabus(
  title: none,
  coursenum: none,
  semester: none,
  meets: none,
  contact: (),
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
        align(left)[#coursenum · Syllabus],
        align(center)[#counter(page).display("1 / 1", both: true)],
        align(right)[#semester],
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
  show heading.where(level: 1): it => block(above: 1.3em, below: 0.55em, sticky: true,
    stack(dir: ttb, spacing: 3.5pt,
      text(font: "Fraunces 72pt Soft", weight: 600, size: 13.2pt, fill: hh-spruce, it.body),
      line(length: 100%, stroke: 0.6pt + hh-hairline),
    )
  )
  // subsections (policy blocks, schedule sections/modules): bold sans
  show heading.where(level: 2): it => block(above: 1.3em, below: 0.6em, sticky: true)[
    #set text(font: "Cabinet Grotesk", weight: 700, size: 10.2pt, fill: hh-ink)
    #it.body
  ]
  // class meetings (weeks/dates): fir-edged strip — chunks the schedule into
  // scannable blocks (sibling of the larch due() flag)
  show heading.where(level: 3): it => block(
    above: 1.5em, below: 0.75em, width: 100%, sticky: true,
    inset: (x: 0.8em, y: 0.55em),
    fill: hh-paper-2,
    stroke: (left: 2pt + hh-fir),
    radius: (top-right: 4pt, bottom-right: 4pt),
  )[
    #set text(font: "Cabinet Grotesk", weight: 700, size: 9.8pt, fill: hh-spruce)
    #it.body
  ]
  // reading groups (dates within weeks, topic labels): uppercase eyebrow,
  // like the site's pub-abstract-label
  show heading.where(level: 4): it => block(above: 1.1em, below: 0.4em, sticky: true)[
    #set text(font: "Cabinet Grotesk", weight: 700, size: 7.8pt, fill: hh-ink-faint, tracking: 0.07em)
    #upper(it.body)
  ]

  // lists: hanging indent, fir dashes; nested levels indent naturally
  set enum(indent: 0pt, body-indent: 0.75em, spacing: 0.85em,
           numbering: n => text(fill: hh-ink-faint, size: 8.8pt)[#n.])
  set list(indent: 0pt, body-indent: 0.7em, spacing: 0.55em,
           marker: (text(fill: hh-fir, weight: 700)[–], text(fill: hh-ink-faint)[–], text(fill: hh-mist)[–]))

  // tables (grade schema, grading contract): centered, hairline rules, spruce header rule
  show table: it => align(center, it)
  show table: set text(size: 8.8pt)
  set table(
    stroke: (x, y) => (
      top: if y == 0 { 1pt + hh-spruce } else { 0.5pt + hh-hairline },
      bottom: 0.5pt + hh-hairline,
    ),
    inset: (x: 7pt, y: 6pt),
  )
  show table.cell.where(y: 0): set text(weight: 700, fill: hh-spruce)

  // ---- header ----
  grid(
    columns: (1fr, auto),
    column-gutter: 1.2em,
    align: (left + top, right + top),
    stack(dir: ttb, spacing: 7pt,
      text(size: 8.6pt, fill: hh-ink-faint, weight: 700, tracking: 0.07em)[#upper[#coursenum · #semester]],
      text(font: "Fraunces 72pt Soft", weight: 600, size: 20pt, fill: hh-spruce)[#title],
      box(width: 34pt, height: 3pt, radius: 1.5pt, fill: hh-larch),
      text(size: 8.8pt, fill: hh-ink-muted)[#meets],
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
