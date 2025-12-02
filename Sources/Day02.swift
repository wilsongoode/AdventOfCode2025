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
    idRanges.reduce(0) { sum, range in
      sum + range.striding(by: 1).reduce(0) { rangeSum, id in
        rangeSum + (Self.isIdValid(id) ? 0 : id)
      }
    }
  }
  
  func part2() -> Int {
    idRanges.reduce(0) { sum, range in
      sum + range.striding(by: 1).reduce(0) { rangeSum, id in
        rangeSum + (Self.isIdValidPart2(id) ? 0 : id)
      }
    }
  }
}

/** Preoptimized, debug
 Executing Advent of Code challenge 2...
 Part 1: 29940924880
 Part 2: 48631958998
 Part 1 took 3.1185505 seconds, part 2 took 55.773416542 seconds.
 Looks like you're benchmarking debug code. Try swift run -c release
 Program ended with exit code: 0
 
 Limited allocations, `swift run -c release AdventOfCode --benchmark`
 Executing Advent of Code challenge 2...
 Part 1: 29940924880
 Part 2: 48631958998
 Part 1 took 0.169590083 seconds, part 2 took 2.508390458 seconds.
 */
