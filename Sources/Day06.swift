//
//  Day06.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/6/25.
//

struct Day06: AdventDay {
  var data: String
  
  enum Operation: String {
    case multiply = "*"
    case add = "+"
  }
  
  func part1() -> Int {
    let rows: [[String]] = data.split(separator: "\n").map { row in
      row.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
    }
    let groups: [[Int]] = rows.dropLast().map { row in row.compactMap { Int($0) } }
    guard let operationRow = rows.last else { return 0 }
    let rowCount = groups.count
    guard let columnCount = groups.first?.count,
          groups.allSatisfy( { $0.count == columnCount }) else {
      return 0
    }
    
    var total: Int = 0
    for column in 0..<columnCount {
      var values: [Int] = []
      for row in 0..<rowCount {
        values.append(groups[row][column])
      }
      guard let operation = Operation(rawValue: operationRow[column]) else { return 0 }
      switch operation {
      case .multiply:
        total += values.reduce(1, *)
      case .add:
        total += values.reduce(0, +)
      }
    }
    return total
  }
  
  func part2() -> Int {
    return 0
  }
}
