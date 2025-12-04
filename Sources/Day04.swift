//
//  Day04.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/4/25.
//

struct Day04: AdventDay {
  var data: String
  
  var shelves: [String] {
    data.split(separator: "\n").map(String.init)
  }
  
  // Maybe add memoization?
  static func containsRoll(row: Int, column: Int, shelves: [String]) -> Bool {
    guard (0..<shelves.count).contains(row) else { return false }
    let rowString = shelves[row]
    guard (0..<rowString.count).contains(column) else { return false }
    let character = rowString[rowString.index(rowString.startIndex, offsetBy: column)]
    return character == "@"
  }
  
  static func neighbors(_ row: Int, _ column: Int) -> [(Int, Int)] {
    [
      (row - 1, column - 1),
      (row - 1, column),
      (row - 1, column + 1),
      (row, column - 1),
      (row, column + 1),
      (row + 1, column - 1),
      (row + 1, column),
      (row + 1, column + 1),
    ]
  }
  
  static func rollAccessible(row: Int, column: Int, shelves: [String]) -> Bool {
    guard containsRoll(row: row, column: column, shelves: shelves) else { return false }
    let neighbors = neighbors(row, column)
    let neighborsWithRolls = neighbors.filter { r, c in
      containsRoll(row: r, column: c, shelves: shelves)
    }
    return neighborsWithRolls.count < 4
  }
  
  func part1() -> Int {
    let shelves = self.shelves
    let rowCount = shelves.count
    let columnCount = shelves[0].count
    var accessibleCount = 0
    for row in 0..<rowCount {
      for column in 0..<columnCount {
        if Self.rollAccessible(row: row, column: column, shelves: shelves) {
          accessibleCount += 1
        }
      }
    }
    return accessibleCount
  }
  
  func part2() -> Int {
    var shelves = self.shelves
    let rowCount = shelves.count
    let columnCount = shelves[0].count
    var removedCount = 0
    while true {
      let startOfRoundCount = removedCount
      var marked: [(Int, Int)] = []
      for row in 0..<rowCount {
        for column in 0..<columnCount {
          if Self.rollAccessible(row: row, column: column, shelves: shelves) {
            removedCount += 1
            marked.append((row, column))
          }
        }
      }
      if startOfRoundCount == removedCount {
        break
      }
      for rowGroup in marked.chunked(on: { r, _ in r }) {
        let row = rowGroup.0
        let columns = rowGroup.1.map(\.1)
        var rowArray = shelves[row].split(separator: "")
        for column in columns {
          rowArray[column] = "."
        }
        shelves[row] = rowArray.joined()
      }
    }
    
    return removedCount
  }
}

/**
 Executing Advent of Code challenge 4...
 Part 1: 1587
 Part 2: 8946
 Part 1 took 0.052384208 seconds, part 2 took 1.569295334 seconds.
 */
