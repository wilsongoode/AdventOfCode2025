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
  
  static func isIdValid(_ id: Int) -> Bool {
    let string = String(id)
    guard string.count.isMultiple(of: 2) else { return true }
    let middleIndex = string.index(string.startIndex, offsetBy: string.count / 2)
    let firstHalf = String(string[..<middleIndex])
    let secondHalf = String(string[middleIndex...])
    return firstHalf != secondHalf
  }
  
  static func isIdValidPart2(_ id: Int) -> Bool {
    let string = String(id)
    guard string.count > 1 else { return true }
    for chunkSize in 1...(string.count / 2) {
      let chunks = string.chunks(ofCount: chunkSize)
      if Set(chunks).count == 1 {
        return false
      }
    }
    return true
  }
  
  func part1() -> Int {
    var invalidIDs: [Int] = []
    idRanges.forEach { range in
      range.striding(by: 1).forEach { id in
        if !Self.isIdValid(id) {
          invalidIDs.append(id)
        }
      }
    }
    return invalidIDs.reduce(0, +)
  }
  
  func part2() -> Int {
    var invalidIDs: [Int] = []
    idRanges.forEach { range in
      range.striding(by: 1).forEach { id in
        if !Self.isIdValidPart2(id) {
          invalidIDs.append(id)
        }
      }
    }
    return invalidIDs.reduce(0, +)
  }
}
