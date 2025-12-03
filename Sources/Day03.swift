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
  
  static func maxJoltage(bank: String) -> Int {
//    let bank = bank.
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
  
  func part1() -> Int {
    batteryBanks.reduce(0) { sum, bank in
      sum + Self.maxJoltage(bank: bank)
    }
  }
  
  func part2() -> Int {
    return 0
  }
}
