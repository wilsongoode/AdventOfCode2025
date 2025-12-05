//
//  Day01.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 11/30/25.
//

struct Day01: AdventDay {
  var data: String
  
  func part1() -> Int {
    let dial = Dial()
    let operations = data.split(separator: "\n").compactMap { Rotation(string: String($0)) }
    dial.applySequence(operations)
    return dial.countZeroAtEnd
  }
  
  func part2() -> Int {
    let dial = Dial()
    let operations = data.split(separator: "\n").compactMap { Rotation(string: String($0)) }
    dial.applySequence(operations)
    return dial.countEveryZero
  }
}

fileprivate final class Dial {
  var currentHeading: Int
  let range: ClosedRange<Int>
  var countZeroAtEnd: Int = 0
  var countEveryZero: Int = 0
  
  init(range: ClosedRange<Int> = 0...99, startingAt: Int = 50) {
    precondition(range.contains(startingAt))
    self.range = range
    self.currentHeading = startingAt
  }
  
  private let degreesPerStep = 3.6
  
  private func increment(n: Int) {
    for _ in 0..<n {
      if (currentHeading + 1) > range.upperBound {
        currentHeading = 0
        countEveryZero += 1
      } else {
        currentHeading += 1
      }
    }
  }
  
  private func decrement(n: Int) {
    for _ in 0..<n {
      if (currentHeading - 1) < range.lowerBound {
        currentHeading = 99
      } else {
        currentHeading -= 1
        if currentHeading == 0 {
          countEveryZero += 1
        }
      }
    }
  }
  
  func apply(rotation: Rotation) {
    switch rotation.direction {
    case .left: decrement(n: rotation.steps)
    case .right: increment(n: rotation.steps)
    }
    if currentHeading == 0 {
      countZeroAtEnd += 1
    }
  }
  
  func applySequence(_ rotations: [Rotation]) {
    print("The dial starts by pointing at \(currentHeading).")
    print("Applying a sequence of \(rotations.count) operations.")
    let showPrints = rotations.count < 20
    rotations.forEach {
      apply(rotation: $0)
      if showPrints { print("The dial is rotated \($0.string) to point at \(currentHeading).") }
    }
  }
}

fileprivate struct Rotation {
  let direction: RotationDirection
  let steps: Int
  
  var string: String {
    "\(direction)\(steps)"
  }
  
  init(direction: RotationDirection, steps: Int) {
    self.direction = direction
    self.steps = steps
  }
  
  init?(string: String) {
    guard
      let firstChar = string.first,
      let direction = RotationDirection(rawValue: firstChar),
      let steps = Int(string.dropFirst())
    else {
      return nil
    }
    self.direction = direction
    self.steps = steps
  }
}

fileprivate enum RotationDirection: Character {
  case left = "L"
  case right = "R"
}

/**
 Executing Advent of Code challenge 1...
 The dial starts by pointing at 50.
 Applying a sequence of 4036 operations.
 Part 1: 984
 The dial starts by pointing at 50.
 Applying a sequence of 4036 operations.
 Part 2: 5657
 Part 1 took 0.001932791 seconds, part 2 took 0.001808584 seconds.
 */
