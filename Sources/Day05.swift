//
//  Day05.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/5/25.
//

struct Day05: AdventDay {
  var data: String
  
  var freshIngredientRanges: [ClosedRange<Int>] {
    guard let ranges = data.split(separator: "\n\n").first else { return [] }
    return ranges.split(separator: "\n").compactMap {
      let bounds = $0.split(separator: "-")
      if let lower = Int(bounds[0]), let upper = Int(bounds[1]) {
        return lower...upper
      } else {
        return nil
      }
    }
  }
  
  var availableIngredients: [Int] {
    guard let ingredients = data.split(separator: "\n\n").last else { return [] }
    return ingredients.split(separator: "\n").compactMap { Int($0) }
  }
  
  func disjointRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    // Sorting makes it easier to build up the larger range
    let sorted = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
    var lower = sorted[0].lowerBound
    var upper = sorted[0].upperBound
    var disjointRanges: [ClosedRange<Int>] = []
    for range in sorted.dropFirst() {
      // Check if range.lowerBound is within lower...upper, or adjacent
      if (lower...upper + 1).contains(range.lowerBound) {
        upper = max(upper, range.upperBound)
      } else { // Range is disjoint
        disjointRanges.append(lower...upper)
        lower = range.lowerBound
        upper = range.upperBound
      }
    }
    if !disjointRanges.contains(lower...upper) {
      disjointRanges.append(lower...upper)
    }
    return disjointRanges
  }
  
  func part1() -> Int {
    let ranges = freshIngredientRanges
    let ingredients = availableIngredients
    let freshIngredients = ingredients.filter { ingredient in
      ranges.contains(where: { range in range.contains(ingredient) })
    }
    return freshIngredients.count
  }
  
  func part2() -> Int {
    // Need to greatly simplify the number of ranges being considered
    let disjoint = disjointRanges(freshIngredientRanges)
    return disjoint.reduce(0) { $0 + $1.count }
  }
}

/**
 Executing Advent of Code challenge 5...
 Part 1: 617
 Part 2: 338258295736104
 Part 1 took 0.002469334 seconds, part 2 took 0.001155958 seconds.
 */
