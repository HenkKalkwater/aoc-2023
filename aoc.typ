#let year = 2023

#let stars = (body) => [
  #set text(fill: rgb("#ffff66"))
  #body
]

#let appendix = (..args) => heading(supplement: [Appendix], numbering: "A.", ..args)

#let day-part = (day, part, input-file, visualise: false) => [
  #let story-file = "parts/day-" + str(day) + "-" + str(part) + "-story.typ"
  #let file = "parts/day-" + str(day) + "-" + str(part) + ".typ"
  #let input = read(input-file)
  == Part #{part}
  #include story-file

  #import file: solve
  #let answ = solve(input)
  #if type(answ) == dictionary and answ.at("value", default: none) != none [
    My answer is: #raw(repr(answ.at("value")))

    #if visualise [
      #answ.at("visualisation", default: [])
    ]
  ] else [
    My answer is: #raw(repr(answ))
  ]

  The source code for the answer is:
  #raw(read(file), lang: "typ", block: true)
]

#let day = (day, solved-parts: 0) => [
  #pagebreak()
  #let date_disp = (c) => datetime(year: year, month: 12, day: c).display("[weekday], [day padding:none] [month repr:long]")
  #metadata((
    day: day,
    input: solved-parts > 0
  )) <day-meta>
  = #date_disp(day)
  #let input-file = "parts/day-" + str(day) + "-input.txt"

  #for part in range(1, solved-parts + 1) [
    #day-part(day, part, input-file)
  ]

  #if solved-parts == 0 [
    To begin, #link("https://adventofcode.com/" + str(year) + "/day/" + str(day) + "/input")[get your puzzle input]
  ] else {
    locate(loc => [
      #let appendices = query(heading.where(supplement: [Appendix]), loc)
      #if appendices == () [
        To begin, #link("https://adventofcode.com/" + str(year) + "/day/" + str(day) + "/input")[get your puzzle input]
      ] else [
        The input is available in #repr(appendices.at(day - 1))
      ]
    ])
  }

  #if solved-parts == 1 {
    stars[The first half of this puzzle is complete! It provides one gold star: \*]
  } else if solved-parts == 2 {
    stars[Both parts of this puzzle are complete! They provide two gold stars: \*\*]
  }
]



#let template = (title: "", year: 2023, body) => [
  #set text(
    font: ("Source Code Pro", "monospace"),
    fill: rgb("#cccccc")
  )
  #set page(
    background: rect(width: 100%, height: 100%, fill: rgb("#0f0f23"))
  )
  #set heading(numbering: none)
  #show heading.where(level: 1): set text(fill: rgb("#00cc00"))
  #show heading.where(level: 2): it => [
    #set text(fill: rgb("#ffffff"))
    \-\-\- #it.body \-\-\-

  ]

  #show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    set text(fill: rgb("#009900"))
    it
  }

  #show link: set text(fill: rgb("#009900"))

  #show raw.where(block: false): box.with(
    fill: rgb("#10101a"),
    stroke: rgb("#333340"),
    inset: (x: 0.25em, y: 0.1em),
    outset: (x: 0.25em)
  )

  #show raw.where(block: true): block.with(
    fill: rgb("#10101a"),
    stroke: rgb("#333340"),
    inset: (x: 1em, y: 1em),
  )

  #heading(title, numbering: none, outlined: false)

  #body

  #pagebreak()
  
  #locate(loc => {
    for day-meta in query(<day-meta>, loc) {
      let input = day-meta.value.at("input", default: none)
      let day = day-meta.value.at("day")
      if input [
        #appendix[Input for #day]
        #raw(read("parts/day-" + str(day) + "-input.txt"), block: true)
      ]
    }
  })
]
