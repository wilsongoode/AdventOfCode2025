//
//  Day03.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/3/25.
//

struct Day03: AdventDay {
  var data: String
  
  var batteryBanks: [String] {
    data.split(separator: "\n").map(String.init)
  }
  
  /// Implementation for part 1 with only 2 batteries able to be turned on
  static func maxJoltage(bank: String) -> Int {
    let lastValidIndex = bank.index(before: bank.endIndex)
    var ratings: [Int: String.UnicodeScalarView.Index] = [:]
    for rating in 1...9 {
      let ratingChar = Character(String(rating))
      let firstIndexOfRating = bank.firstIndex(of: ratingChar)
      ratings[rating] = firstIndexOfRating
    }
    let largestNonLast = ratings.filter { $0.value != lastValidIndex }.max(by: { $0.key < $1.key })!
    let rest = bank.index(after: largestNonLast.value)..<bank.endIndex
    let nextLargestFollowing = bank[rest].max()!
    let combined = "\(largestNonLast.key)\(nextLargestFollowing)"
    return Int(combined)!
  }
  
  /// Implementation for part 2 where 12 batteries need to be turned on.
  ///
  /// Providing `batteries: 2` has the same result as part 1 implementation.
  static func maxJoltage(bank: String, batteries: Int) -> Int {
    // get highest digit at least num_batteries ahead of the end of the bank
    // prefer earliest possible
    // repeat with range bank[selectedDigit..<num_batteries-1]
    var joltage: String = ""
    var numPlacesToFill = batteries
    var searchStartIndex = bank.startIndex
    
    while numPlacesToFill > 0 {
      var ratings: [Int: String.UnicodeScalarView.Index] = [:]
      for rating in 1...9 {
        let ratingChar = Character(String(rating))
        guard let searchEndIndex = bank.index(
          bank.endIndex,
          offsetBy: -numPlacesToFill,
          limitedBy: searchStartIndex
        ) else {
          continue
        }
        let rangeToSearch = searchStartIndex...searchEndIndex
        let firstIndexOfRating = bank[rangeToSearch].firstIndex(of: ratingChar)
        ratings[rating] = firstIndexOfRating
      }
      let largest = ratings.max(by: { $0.key < $1.key })!
      joltage.append(String(largest.key))
      numPlacesToFill -= 1
      searchStartIndex = bank.index(after: largest.value)
    }
    
    return Int(joltage)!
  }
  
  func part1() -> Int {
    batteryBanks.reduce(0) { sum, bank in
      sum + Self.maxJoltage(bank: bank)
    }
  }
  
  func part2() -> Int {
    batteryBanks.reduce(0) { sum, bank in
      sum + Self.maxJoltage(bank: bank, batteries: 12)
    }
  }
}

/** Benchmark
 Executing Advent of Code challenge 3...
 Part 1: 17263
 Part 2: 170731717900423
 Part 1 took 0.001492208 seconds, part 2 took 0.005219583 seconds.
 */
