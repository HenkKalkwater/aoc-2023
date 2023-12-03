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

#let GRID_SYMBOL = -1
#let GRID_EMPTY  = -2

#let parse_grid = (input) => {
  let numbers = ()
  let grid = ()
  let grid_row = ()

  let cur_number = (number: 0, pos: ())
  let x = 0
  let y = 0
  for char in input {
    if char.match(regex("[0-9]")) != none {
      cur_number = (
        number: cur_number.number * 10 + int(char),
        pos: cur_number.pos + ((x, y),)
      )
      grid_row.push(numbers.len())
    } else {
      // Finished reading number, push it to the number list
      if cur_number.pos.len() > 0 {
        numbers.push(cur_number)
        cur_number = (number: 0, pos: ())
      }

      if char == "." {
        grid_row.push(GRID_EMPTY)
      } else if char != "\n" {
        grid_row.push(GRID_SYMBOL)
      }
    }
    
    if char == "\n" {
      x = 0
      y += 1
      grid.push(grid_row)
      grid_row = ()
    } else {
      x += 1
    }
  }

  // Push last row in case of no ending newline
  if x != 0 {
    grid.push(grid_row)
  }
  (
    grid: grid,
    numbers: numbers,
  )
}

#let grid_cell_value = (grid, x, y) => {
  if x < 0 or x >= grid.first().len() or y < 0 or y >= grid.len() {
    GRID_EMPTY
  } else {
    grid.at(y).at(x)
  }
}

#let is_part_no = (grid, x, y) => {
  let sur_positions = (
    (-1, -1), ( 0, -1), ( 1, -1),
    (-1,  0),           ( 1,  0),
    (-1,  1), ( 0,  1), ( 1,  1)
  )

  for pos in sur_positions {
    if grid_cell_value(grid, x + pos.first(), y + pos.last()) == GRID_SYMBOL {
      return true
    }
  }

  false
}

#let visualise(res, numbers, part_numbers) = [
  #let vis_cells = ()
  #for y in range(res.grid.len()) {
    let row = res.grid.at(y)
    for x in range(row.len()) {
      let val = grid_cell_value(res.grid, x, y)
      let cell = none
      if val < 0 {
        if val == GRID_SYMBOL {
          cell = [\*]
        } else {
          cell = [ ]
        }
      } else {
        let number = res.numbers.at(val).number
        cell = [ #number ]
      }
      vis_cells.push(cell)
    }
  }
  #table(
    columns: 4,
    [*Row*], [*Col start*], [*Col end*], [*Part numbers*], 
    ..part_numbers.map(n => {
      let row = n.pos.first().last()
      let x1 = n.pos.first().first()
      let x2 = n.pos.last().first()
      return ([#row], [#x1], [#x2], [#n.number],)
    }).flatten(),
    [], [], [], [*Sum*: #part_numbers.map(n => n.number).sum()] 
  )
  #[
    #set page(width: auto, height: auto)
    #table(
      columns: res.grid.first().len(),
      align: center,
      fill: (x, y) => {
        let val = grid_cell_value(res.grid, x, y)
        if val == GRID_SYMBOL {
          rgb("#888833")
        } else if val >= 0 {
          for number in numbers {
            for pos in number.pos {
              if pos.first() == x and pos.last() == y {
                if number.at("is-part", default: false) {
                  return rgb("#004400")
                } else {
                  return rgb("#00440044")
                }
              }
            }
          }
          none
        } else {
          none
        }
      },
      ..vis_cells
    )
  ]
  
]

#let solve = (input) => {
  let res = parse_grid(input.trim("\n"))

  let numbers = res.numbers
    .map(num => {
      for num_pos in num.pos {
        let x = num_pos.first()
        let y = num_pos.last()
        if is_part_no(res.grid, x, y) {
          num.insert("is-part", true)
          return num
        }
      }
      num.insert("is-part", false)
      num
    })

  let part_numbers = numbers.filter(n => n.at("is-part", default: false))



  (
    value: part_numbers
      .map(x => x.number)
      .sum(),
    visualisation: visualise(res, numbers, part_numbers)
  )

}
