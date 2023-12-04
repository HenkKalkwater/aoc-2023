#import "aoc.typ"

#show: aoc.template.with(
  title: "Advent of Code 2023 (single part version)"
)

#let year = 2023
#let day = 4
#let part = 2
#let test = false
#let visualise = true

#let input = "parts/day-" + str(day) + "-input"
#if test {
  input += "-test"
}
#let input = input + ".txt";

// Content
This file is used to test the solution of a single day

= Day #day

To begin, #link("https://adventofcode.com/" + str(year) + "/day/" + str(day) + "/input")[get your puzzle input]

#aoc.day-part(day, part, input, visualise: visualise)
