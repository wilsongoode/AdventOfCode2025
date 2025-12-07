//
//  Day07.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/7/25.
//

struct Day07: AdventDay {
  var data: String
  
  var manifold: [[Character]] {
    let rows = data.split(separator: "\n").map(String.init)
    let characters = rows.map({ Array($0) })
    return characters
  }
  
  let tachyonSource: Character = "S"
  let beamSplitter: Character = "^"
  
  func part1() -> Int {
    var splitCount: Int = 0
    var currentBeamIndices: Set<Int> = []
    
    let yCount = manifold.count
    let xCount = manifold[0].count
    let source = manifold[0].firstIndex(of: tachyonSource)!
    currentBeamIndices.insert(source)
    
    for y in 1..<yCount {
      let positionsToCheck = Array(currentBeamIndices)
      for x in positionsToCheck {
        if manifold[y][x] == beamSplitter {
          splitCount += 1
          currentBeamIndices.remove(x)
          if x > 0 { currentBeamIndices.insert(x - 1) }
          if x < xCount - 1 { currentBeamIndices.insert(x + 1) }
        }
      }
    }
    
    return splitCount
  }
  
  func part2() -> Int {
    return 0
  }
}
