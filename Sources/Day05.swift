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
  
  func part1() -> Int {
    let ranges = freshIngredientRanges
    let ingredients = availableIngredients
    let freshIngredients = ingredients.filter { ingredient in
      ranges.contains(where: { range in range.contains(ingredient) })
    }
    return freshIngredients.count
  }
  
  func part2() -> Int {
    return 0
  }
}
