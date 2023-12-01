#let numbers = (
  "zero",
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten"
)
#let num_reg = "(" + numbers.join("|") + "|\d)"

#let to_num = (str) => {
  let val = numbers.position(x => x == str)
  if val == none {
    val = int(str)
  }
  val
}

#let solve = (input) => {
  let first_reg = regex("[a-z]*?" + num_reg)
  let last_reg = regex(".*" + num_reg + "[a-z]*")
  let answ = input
    .split("\n")
    .filter(line => line.len() > 0)
    .map(line => {
      let first = to_num(line.match(first_reg).captures.at(0))
      let last = to_num(line.match(last_reg).captures.at(0))
      first * 10 + last
    })
    .sum()
  return answ
}
