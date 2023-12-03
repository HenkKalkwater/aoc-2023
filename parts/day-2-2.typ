#let solve = (input) => {
  let game_r = regex("Game (\d+):")
  let cubes_r = regex("(\d+) (\w+)")
  let games = input
    .split("\n")
    .filter(line => line.len() > 0)
    .map(line => {
      let game = int(line.match(game_r).captures.at(0))
      let game_draws = line.split(";")
      let draws = ()

      for draw in game_draws {
        let game_matches = draw.matches(cubes_r)
        let game_vals = (:)
        for match in game_matches {
          game_vals.insert(match.captures.at(1), int(match.captures.at(0)))
        }
        draws.push(game_vals)
      }
      (game, draws)
    })
    .map(game => {
      let draws = game.at(1)
      draws.fold((:), (l, r) => {
        let result = (:)
        for color in ("red", "green", "blue") {
          result.insert(color, calc.max(l.at(color, default: 0), r.at(color, default: 0)))
        }
        result
      }).values().product()
    })
    .sum()

    games
}
