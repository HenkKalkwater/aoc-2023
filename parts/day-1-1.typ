#let solve = (input) => {
  let first_reg = regex("[a-z]*(\d)")
  let last_reg = regex(".*(\d)[a-z]*")
  let answ = input
    .split("\n")
    .filter(line => line.len() > 0)
    .map(line => {
      let first = int(line.match(first_reg).captures.at(0))
      let last = int(line.match(last_reg).captures.at(0))
      first * 10 + last
    })
    .sum()
  return answ
}
