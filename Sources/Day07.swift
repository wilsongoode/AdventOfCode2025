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
  
  func originalPart1() -> Int {
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
  
  func part1() -> Int {
    let yCount = manifold.count
    let source = manifold[0].firstIndex(of: tachyonSource)!
    var beamTree = BeamTree(sourceX: source)
    
    for y in 1..<yCount {
      if manifold[y][source] == beamSplitter {
        beamTree.addChild(Splitter(x: source, y: y))
        break
      }
    }
    guard var firstSplit = beamTree.child else { return -1 }
    search(
      beamTree: &beamTree,
      childrenOf: &firstSplit,
      inManifoldSubset: manifold[firstSplit.y...]
    )
    let splitterCount = beamTree.countSplitters
    return splitterCount
  }
  
  
  func part2() -> Int {
    let yCount = manifold.count
    let source = manifold[0].firstIndex(of: tachyonSource)!
    var beamTree = BeamTree(sourceX: source)
    
    for y in 1..<yCount {
      if manifold[y][source] == beamSplitter {
        beamTree.addChild(Splitter(x: source, y: y))
        break
      }
    }
    guard var firstSplit = beamTree.child else { return -1 }
    search(
      beamTree: &beamTree,
      childrenOf: &firstSplit,
      inManifoldSubset: manifold[firstSplit.y...]
    )
    let timelineCount = beamTree.countTimelines
    return timelineCount
  } //: part2
  
  
  func search(
    beamTree: inout BeamTree,
    childrenOf splitter: inout Splitter,
    inManifoldSubset manifoldSubset: ArraySlice<Array<Character>>
  ) {
    guard let xEndIndex = manifoldSubset.first?.endIndex else { return }
    for x in [splitter.leftX, splitter.rightX] {
      guard x >= 0, x < xEndIndex else {
        continue
      }
      for y in splitter.y..<manifoldSubset.endIndex {
        if manifoldSubset[y][x] == beamSplitter {
          if let alreadyFoundSplitter = beamTree.findSplitter(x: x, y: y) {
//            print("already found splitter at \(x), \(y)")
            splitter.add(child: alreadyFoundSplitter)
          } else {
//            print("found new splitter at \(x), \(y)")
            var newSplitter = Splitter(x: x, y: y)
            splitter.add(child: newSplitter)
            search(
              beamTree: &beamTree,
              childrenOf: &newSplitter,
              inManifoldSubset: manifoldSubset[newSplitter.y...]
            )
            beamTree.timelineCounts[newSplitter] = newSplitter.countTimelines
          }
          break
        }
      } //: for y
    } //: for x
  } //: search
}

class BeamTree {
  var sourceX: Int
  var child: Splitter? = nil
  
  var allSplitters = Set<Splitter>()
  var timelineCounts: [Splitter: Int] = [:]
  
  init(sourceX: Int) {
    self.sourceX = sourceX
  }
  
  func addChild(_ splitter: Splitter) {
    child = splitter
    splitter.root = self
    allSplitters.insert(splitter)
  }
  
  var countSplitters: Int {
    allSplitters.count
  }
  
  var countTimelines: Int {
    return child?.countTimelines ?? 1
  }
  
  func findSplitter(x: Int, y: Int) -> Splitter? {
    allSplitters.first(where: { $0.x == x && $0.y == y })
  }
}

class Splitter {
  var x: Int
  var y: Int
  var children: [Splitter] = []
  weak var root: BeamTree?
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
  
  init(x: Int, y: Int, children: [Splitter]) {
    self.x = x
    self.y = y
    self.children = children
  }
  
  func add(child: Splitter) {
    children.append(child)
    child.root = root
    root?.allSplitters.insert(child)
  }
  
  var leftX: Int { x - 1 }
  var rightX: Int { x + 1 }
  
  var isLeaf: Bool {
    children.isEmpty
  }
  
  var countTimelines: Int {
    guard let root else { return 0 }
    if let existing = root.timelineCounts[self] {
      return existing
    }
    let count = (2 - children.count) + children.reduce(0) { $0 + $1.countTimelines }
    root.timelineCounts[self] = count
    return count
  }
}

extension Splitter: Hashable {
  static func == (lhs: Splitter, rhs: Splitter) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

/**
 Executing Advent of Code challenge 7...
 Part 1: 1662
 Part 2: 40941112789504
 Part 1 took 0.012229125 seconds, part 2 took 0.012046583 seconds.
 */
