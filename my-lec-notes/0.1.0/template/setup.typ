#import "config.typ": *
#import "environments.typ": *
#import "@preview/hydra:0.6.2": hydra

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}

#let show-theorem-ref(it) = {
  let el = it.element
  if el != none and el.func() == metadata and type(el.value) == dictionary and el.value.at("theorem-kind", default: none) != none {
    let val = el.value
    let number = strip-leading-number-part(val.number)

    if it.supplement == [?] {
      link(it.target, [#val.supplement])
    } else if val.title != none {
      if number != none {
        if it.supplement == [-] {
          link(it.target, [#val.supplement #number])
        } else if it.supplement == [--] {
          link(it.target, [#number])
        } else if it.supplement == [!!!] {
          link(it.target, [#val.title])
        } else if it.supplement == [!!] {
          link(it.target, [#val.title (#number)])
        } else if it.supplement == [!] {
          link(it.target, [#val.title (#val.supplement #number)])
        } else if it.supplement == auto {
          link(it.target, [#val.supplement #number (#val.title)])
        } else {
          link(it.target, [#it.supplement #number (#val.title)])
        }
      } else {
        if it.supplement == [-] or it.supplement == auto {
          link(it.target, [#val.supplement (#val.title)])
        } else if it.supplement == [--] {
          link(it.target, [(#val.title)])
        } else if it.supplement == [!!!] or it.supplement == [!!] {
          link(it.target, [#val.title])
        } else if it.supplement == [!] {
          link(it.target, [#val.title (#val.supplement)])
        } else {
          link(it.target, [#it.supplement (#val.title)])
        }
      }
    } else if number != none {
      if it.supplement == [-] or it.supplement == [!] or it.supplement == [!!] or it.supplement == [!!!] or it.supplement == auto {
        link(it.target, [#val.supplement #number])
      } else if it.supplement == [--] {
        link(it.target, [#number])
      } else {
        link(it.target, [#it.supplement #number])
      }
    } else {
      if it.supplement == [-] or it.supplement == [--] or it.supplement == [!] or it.supplement == [!!] or it.supplement == [!!!] or it.supplement == auto {
        link(it.target, [#val.supplement])
      } else {
        link(it.target, [#it.supplement #number])
      }
    }
  } else {
    it
  }
}

#let project(title: title, authors: authors, show_info: true, body) = {
  // Set the document's basic properties.
  let title = course + " " + title
  set document(author: authors, title: title)
  set page(paper: "us-letter")
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
      if to-string(it.body()) == "Bibliography" {
        link(
          it.element.location(),
          text(weight: "bold")[#it.prefix()] + " " + strong(emph(it.body())),
        )
      }
      else {
        link(
          it.element.location(),
          text(weight: "bold")[#it.prefix().] + " " + strong(emph(it.body())),
        )
      }
    }

    outline(title: "Table of Contents", depth: 3)
  }
  
  // Main body.
  set par(first-line-indent: 1em, justify: true, spacing: 0.65em)

  body
}
