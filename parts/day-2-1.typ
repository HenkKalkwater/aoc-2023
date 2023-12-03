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
    .filter(game => {
      let draws= game.at(1)
      draws.all(cubes => cubes.at("red", default: 0) <= 12 and cubes.at("green", default: 0) <= 13 and cubes.at("blue", default: 0) <= 14)
    })
    .map(game => game.at(0))
    .sum()

    games
}
