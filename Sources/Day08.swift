//
//  Day08.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/8/25.
//

struct Day08: AdventDay {

  var data: String
  
  var junctionBoxes: [JunctionBox] {
    data.split(separator: "\n").map(String.init).compactMap(JunctionBox.init)
  }
  
  func part1() -> Int {
    let maxConnections = 1000
    
    let boxes = junctionBoxes
    var distances: [Cable: Double] = [:]
    for box in boxes {
      for otherBox in boxes where box != otherBox {
        let distance = box.distance(to: otherBox)
        let cable = Cable(ends: [box, otherBox])
        if distances.keys.contains(cable) { continue }
        distances[cable] = distance
      }
    }
    var connectionsMade = 0
    let sortedCables = distances.sorted(by: { $0.value < $1.value })
    var circuits: Set<Circuit> = []
    for (cable, distance) in sortedCables {
      if connectionsMade >= maxConnections { break }
      // One of the circuits already has both cable ends
      if circuits.contains(where: { $0.junctionBoxes.isSuperset(of: cable.ends) }) {
        connectionsMade += 1
        continue
      }
      // At least one of the circuits has an overlap with the cable
      let circuitsWithOverlap = circuits.filter({ !$0.junctionBoxes.isDisjoint(with: cable.ends) })
      if !circuitsWithOverlap.isEmpty {
        // Only one circuit has overlap
        if circuitsWithOverlap.count == 1, var circuit = circuitsWithOverlap.first {
          circuits.remove(circuit)
          circuit.insert(cable)
          circuits.insert(circuit)
          connectionsMade += 1
          continue
        }
        // Two circuits have overlap
        guard circuitsWithOverlap.count == 2 else {
          fatalError("This shouldn't happen!")
        }
        
        for circuit in circuitsWithOverlap {
          circuits.remove(circuit)
        }
        var combinedCircuit = Circuit(junctionBoxes: Set(circuitsWithOverlap.flatMap(\.junctionBoxes)))
        combinedCircuit.insert(cable)
        circuits.insert(combinedCircuit)
        connectionsMade += 1
        
        continue
      }
      // No circuit touches this cable
      let newCircuit = Circuit(junctionBoxes: cable.ends)
      circuits.insert(newCircuit)
      connectionsMade += 1
    }
//    print(circuits)
    let threeLargestCircuits = circuits.sorted(by: { $0.junctionBoxes.count > $1.junctionBoxes.count }).prefix(3)
    let result = threeLargestCircuits.reduce(1) { $0 * $1.junctionBoxes.count }
    
    return result
  }
  
  func part2() -> Int {
    
    let boxes = junctionBoxes
    let boxSet = Set(boxes)
    var distances: [Cable: Double] = [:]
    for box in boxes {
      for otherBox in boxes where box != otherBox {
        let distance = box.distance(to: otherBox)
        let cable = Cable(ends: [box, otherBox])
        if distances.keys.contains(cable) { continue }
        distances[cable] = distance
      }
    }
    
    var lastCable: Cable? = nil
    let sortedCables = distances.sorted(by: { $0.value < $1.value })
    var circuits: Set<Circuit> = []
    for (cable, distance) in sortedCables {
      // One circuit contains all of the boxes; we're done.
      if circuits.first?.junctionBoxes.isSuperset(of: boxSet) ?? false {
        break
      }
      // One of the circuits already has both cable ends
      if circuits.contains(where: { $0.junctionBoxes.isSuperset(of: cable.ends) }) {
        continue
      }
      // At least one of the circuits has an overlap with the cable
      let circuitsWithOverlap = circuits.filter({ !$0.junctionBoxes.isDisjoint(with: cable.ends) })
      if !circuitsWithOverlap.isEmpty {
        // Only one circuit has overlap
        if circuitsWithOverlap.count == 1, var circuit = circuitsWithOverlap.first {
          circuits.remove(circuit)
          circuit.insert(cable)
          circuits.insert(circuit)
          lastCable = cable
          continue
        }
        // Two circuits have overlap
        guard circuitsWithOverlap.count == 2 else {
          fatalError("This shouldn't happen!")
        }
        
        for circuit in circuitsWithOverlap {
          circuits.remove(circuit)
        }
        var combinedCircuit = Circuit(junctionBoxes: Set(circuitsWithOverlap.flatMap(\.junctionBoxes)))
        combinedCircuit.insert(cable)
        circuits.insert(combinedCircuit)
        lastCable = cable
        continue
      }
      // No circuit touches this cable
      let newCircuit = Circuit(junctionBoxes: cable.ends)
      circuits.insert(newCircuit)
    }
    guard let lastCable else {
      fatalError("no last cable")
    }
    let result = lastCable.ends.map(\.x).reduce(1, *)
    return result
  }
}

struct Circuit: Hashable {
  var junctionBoxes: Set<JunctionBox>
  
  mutating func insert(_ cable: Cable) {
    self.junctionBoxes.formUnion(cable.ends)
  }
}

struct Cable: Hashable {
  var ends: Set<JunctionBox>
}

struct JunctionBox: Hashable {
  var x: Int
  var y: Int
  var z: Int
  
  init(x: Int, y: Int, z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  init?(_ s: String) {
    let a = s.split(separator: ",").compactMap { Int($0) }
    guard a.count == 3 else { return nil }
    self.init(x: a[0], y: a[1], z: a[2])
  }
  
  func distance(to other: JunctionBox) -> Double {
    let dx = other.x - self.x
    let dy = other.y - self.y
    let dz = other.z - self.z
    return Double(dx * dx + dy * dy + dz * dz).squareRoot()
  }
}

/**
 Executing Advent of Code challenge 8...
 Part 1: 175500
 Part 2: 6934702555
 Part 1 took 0.957556125 seconds, part 2 took 0.985781459 seconds.
 */
