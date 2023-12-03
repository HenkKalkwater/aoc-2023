#let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

#let TYPE_EMPTY  = 0
#let TYPE_SYMBOL = 1
#let TYPE_NUMBER = 2

#let parse_grid = (input) => {
  // Pass 1: assemble a dictionary of (x, y, type)
  let numbers = ()
  let grid = ()
  let cols = 0

  let cur_number = (number: 0, pos: ())
  let x = 0
  let y = 0
  for char in input {
    if char.match(regex("[0-9]")) != none {
      cur_number = (
        number: cur_number.number * 10 + int(char),
        pos: cur_number.pos + ((x, y),)
      )
      grid.push((
        x: x,
        y: y,
        type: TYPE_NUMBER,
        number: numbers.len(),
      ))
    } else {
      // Finished reading number, push it to the number list
      if cur_number.pos.len() > 0 {
        numbers.push(cur_number)
        cur_number = (number: 0, pos: ())
      }

      if char == "." {
        grid.push((x: x, y: y, type: TYPE_EMPTY))
      } else if char != "\n" {
        grid.push((x: x, y: y, type: TYPE_SYMBOL))
      }
    }
    
    if char == "\n" {
      cols = x
      x = 0
      y += 1
    } else {
      x += 1
    }
  }

  // Pass 2: map values to the grid cells
  grid = grid.map(c => {
    if c.type == TYPE_NUMBER {
      let num = numbers.at(c.number)
      c.insert("number-value", num.number)
      c.insert("number-start", num.pos.first().first())
      c.insert("number-end", num.pos.last().first())
    }
    c
  })


  (
    cells: grid,
    numbers: numbers,
    cols: cols,
    rows: y + 1
  )
}

#let grid_cell = (grid, x, y) => {
  if x < 0 or x >= grid.cols or y < 0 or y >= grid.rows {
    GRID_EMPTY
  } else {
    grid.cells.at(y * grid.cols + x)
  }
}

#let surrounding_nos = (grid, x, y) => {
  let sur_positions = (
    (-1, -1), ( 0, -1), ( 1, -1),
    (-1,  0),           ( 1,  0),
    (-1,  1), ( 0,  1), ( 1,  1)
  )

  let nos = ()

  for pos in sur_positions {
    let cell = grid_cell(grid, x + pos.first(), y + pos.last())
    if cell.type == TYPE_NUMBER {
      nos.push(cell)
    }
  }
  nos = nos.dedup(key: cell => cell.number)

  nos
}

#let power_level = (grid, cell) => {
  let nos = surrounding_nos(grid, cell.x, cell.y)
  if nos.len() == 2 {
    nos
      .map(no => no.number-value)
      .product()
  } else {
    none
  }
}

#let visualise(grid) = [
  #[
    #set page(width: auto, height: auto)
    #table(
      columns: grid.cols,
      align: center,
      fill: (x, y) => {
        let cell = grid.cells.at(y * grid.cols + x)
        if cell.type == TYPE_SYMBOL {
          rgb("#888833")
        } else {
          none
        }
      },
      ..grid.cells.map(cell => {
        if cell.type == TYPE_NUMBER {
          [#cell.number-value]
        } else if cell.type == TYPE_SYMBOL {
          let power_level = power_level(grid, cell)
          [#power_level]
        }
      })
    )
  ]
  
]

#let solve = (input) => {
  let grid = parse_grid(input.trim("\n"))

  let symbols = grid.cells
    .filter(c => c.type == TYPE_SYMBOL)
    .map(c => power_level(grid, c))
    .filter(pl => pl != none)
    .sum()
  (
    value: symbols,
    visualisation: visualise(grid)
  )

}
