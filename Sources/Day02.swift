//
//  Day02.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/2/25.
//

struct Day02: AdventDay {
  var data: String
  
  var idRanges: [ClosedRange<Int>] {
    data.split(separator: ",").map {
      let range = $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "-")
      let lowerBound = Int(range[0])!
      let upperBound = Int(range[1])!
      return lowerBound...upperBound
    }
  }
  
  func isIdValid(_ id: Int) -> Bool {
    let string = String(id)
    guard string.count.isMultiple(of: 2) else { return true }
    let middleIndex = string.index(string.startIndex, offsetBy: string.count / 2)
    let firstHalf = String(string[..<middleIndex])
    let secondHalf = String(string[middleIndex...])
    return firstHalf != secondHalf
  }
  
  func part1() async throws -> Int {
    var invalidIDs: [Int] = []
    idRanges.forEach { range in
      range.striding(by: 1).forEach { id in
        if !isIdValid(id) {
          invalidIDs.append(id)
        }
      }
    }
    return invalidIDs.reduce(0, +)
  }
  
//  func part2() async throws -> Int {
//    <#code#>
//  }
}
