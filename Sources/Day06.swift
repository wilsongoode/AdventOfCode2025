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
  
  /// Helper function for part 2 that parses a group of numbers that belong to the same operation.
  func resultFromGroup(_ lines: [String]) -> Int {
    let valueLines = Array(lines.dropLast())
    guard let firstChar = lines.last?.first,
          let operation = Operation(rawValue: String(firstChar)) else {
      return -1
    }
    var values: [Int] = []
    let columnCount = valueLines[0].count
    for column in 0..<columnCount {
      let columnString = valueLines.reduce(into: "") { s, l in
        let x = l[l.index(l.startIndex, offsetBy: column)]
        s.append(x)
      }
      guard let columnValue = Int(columnString.trimmingCharacters(in: .whitespaces)) else {
        return -2
      }
      values.append(columnValue)
    }
    let result: Int = switch operation {
    case .multiply:
      values.reduce(1, *)
    case .add:
      values.reduce(0, +)
    }
    return result
  }
  
  func part2() -> Int {
    let rows: [String] = data.split(separator: "\n").map(String.init)
    let spaceIndices = rows.map { $0.indices(of: " ") }
    var commonSpaces = RangeSet(rows[0].indices, within: rows[0])
    for row in spaceIndices {
      commonSpaces = commonSpaces.intersection(row)
    }
    
    var total: Int = 0
    var previousIndex = rows[0].startIndex
    
    for common in commonSpaces.ranges {
      let range = previousIndex..<common.lowerBound
      let result = resultFromGroup(rows.map { String($0[range]) })
      total += result
      previousIndex = common.upperBound
    }
    
    // Last group
    let lastResult = resultFromGroup(rows.map { String($0[previousIndex...]) })
    total += lastResult
    
    return total
  }
}

/**
 Executing Advent of Code challenge 6...
 Part 1: 5322004718681
 Part 2: 9876636978528
 Part 1 took 0.001015167 seconds, part 2 took 0.004268333 seconds.
 */
