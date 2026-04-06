#import "setup.typ": *
#import "@preview/equate:0.3.2": equate

// ===
// SET 
// ===
#set math.mat(delim: "[")
#set math.mat(row-gap: 0.5em)
#set math.mat(column-gap: 1em)

#set math.equation(
  numbering: (..nums) => numbering("(1)", ..nums),
  supplement: none,
)

#set heading(numbering: (..nums) => {
  let pos = nums.pos()
  if pos.len() == 1 {
    numbering("I", pos.at(0))
  } else {
    numbering("1.1", ..pos.slice(1))
  }
})

#set table(
  stroke: (x, y) => {
    if y == 0 {
//      (bottom: 1pt + black)
      (top: 1pt + black)
    }
  },
  align: (x, y) => (
    if x > 0 { center }
    else { left }
  )
)

#set enum(indent: 10pt)

// ====
// SHOW
// ====
#show: project.with()
#show table: block.with(stroke: (y: 1pt))
#show ref: theoretic.show-ref
#show ref: link => text(blue, link)
#show link: set text(blue)
#show: equate.with(breakable: true, sub-numbering: false, number-mode: "label")

//#set heading(numbering: (n1, ..x) => numbering("1.1", n1 - 1, ..x))

// Doesn't work if i put it in noteworthy.typ
#show heading.where(level: 1): it => {
  let width = 70%
  npage
  if it.numbering != none {
    block(width: 75%)[
      #set text(25pt)
      #set align(center)
      #counter(heading).display(it.numbering) \
      #line(length: 100%)
      #set text(18pt, weight: "regular")
      #block(width: width, breakable: true)[*#it.body*]
      #v(4em)
    ]
  }
  else {
    block(width: 100%)[
      #v(4em)
      #set text(25pt)
      #block(width: width, breakable: true)[*#it.body*]
      #v(4em)
    ]
  }
}

#show heading.where(level: 2): it => {
  if it.numbering != none and not counter(heading).display(it.numbering).ends-with("1.") {
    npage
  }
  block(width: 100%)[
    #v(0.5em)
    #set align(center)
    #counter(heading).display(it.numbering) #it.body
    #v(0.5em)
  ]
}

#show heading.where(level: 3): it => {
  block(width: 100%)[
    #counter(heading).display(it.numbering) #it.body
  ]
}

#show heading.where(level: 4): it => {
  block(width: 100%)[
    #counter(heading).display(it.numbering) #it.body
  ]
}

#show heading.where(level: 5): it => {
  block(width: 100%)[
    #it.body
  ]
}

//#show heading: smallcaps

// =======
// CONTENT
// =======

