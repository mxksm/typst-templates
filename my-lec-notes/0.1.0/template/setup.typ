#import "config.typ": *
#import "environments.typ": *
#import "@preview/hydra:0.6.2": hydra

#let project(title: title, authors: authors, show_info: true, body) = {
  // Set the document's basic properties.
  let title = course + " " + title
  set document(author: authors, title: title)
  set page(paper: "us-letter")
  set page(header: context {
      if here().page() == 1 {
        let ts = datetime.today().display("[year]-[month]-[day]")
        align(right, str(here().page()) + h(1fr) + emph("Compiled on " + ts))
      }
      else {
        if calc.odd(here().page()) {
          align(right, h(1fr) + str(here().page()))
        } 
        else {
          align(left, str(here().page()))
        }
      }
      line(length: 100%)
    },
    footer: context {
      line(length: 100%)
    }
  ) 
  set text(font-size, font: font, lang: "en")
  show raw: text.with(font: font)

  if show_info {
    // Title row.
    align(center + horizon)[
      #box(
        text(weight: "black", size: 25pt, smallcaps(title)),
      )
    
      // Author information.
      #pad(
        top: 0.5em,
        bottom: 0.5em,
        x: 2em,
        grid(
          columns: (1fr,) * calc.min(3, authors.len()),
          gutter: 1em,
          ..authors.map(author => align(center, smallcaps(strong(author)))),
        ),
      )
    ]
    // Table of Contents
    show outline.entry.where(
      level: 1
    ): set block(above: 1.2em)
    show outline.entry.where(level: 1): it => {
      link(
        it.element.location(),
        text(weight: "bold")[Lecture #it.prefix()] + " " + strong(emph(it.body())),
      )
    }

    outline(title: "Table of Contents", depth: 3)
  }
  
  // Main body.
  set par(justify: true)

  body
}
