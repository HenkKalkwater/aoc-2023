#let parse = (input) => {
  input
    .trim("\n")
    .split("\n")
    .map(line => {
      let parts = line.split(regex("[:|]"))
      let numbers = parts.at(1).matches(regex("\d+")).map(match => int(match.text)).sorted()
      let winning-numbers = parts.at(2).matches(regex("\d+")).map(match => int(match.text)).sorted()

      
      (numbers, winning-numbers)
    })
}

#let count-sorted = (list-a, list-b) => {
  let res = ()

  while (list-a.len() > 0 and list-b.len() > 0) {
    let a = list-a.last()
    let b = list-b.last()
    if (a == b) {
      res.push(a)
      a = list-a.pop()
      b = list-b.pop()
    } else if (a > b) {
      a = list-a.pop()
    } else if (a < b) {
      b = list-b.pop()
    }
  }

  res
}

#let solve = (input) => {
  let parsed = parse(input)


  parsed.map(pair => {
    let winning-count = count-sorted(pair.first(), pair.last()).len()
    let points = calc.pow(2, winning-count - 1)
    if points < 1 {
      points = 0
    }
    return points
  }).sum()
}

//#solve(read("day-4-input-test.txt"))
