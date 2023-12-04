#import "day-4-1.typ": parse, count-sorted

#let solve = (input) => {
  let winning-numbers-count = parse(input).map(pair => count-sorted(pair.first(), pair.last()).len())
  let card-count = range(winning-numbers-count.len()).map(_ => 1)

  for (i, win-count) in winning-numbers-count.enumerate() {
    card-count = card-count.enumerate()
      .map(((j, count)) => {
        if j > i and j <= i + win-count {
          count + card-count.at(i, default: 0) 
        } else {
          count
        }
      })
    
  }

  //card-count.sum()
  (card-count.sum(), winning-numbers-count, card-count)
}
