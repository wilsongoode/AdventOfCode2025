//
//  Day02.swift
//  AdventOfCode
//
//  Created by Wilson Goode on 12/2/25.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day02Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
    1698522-1698528,446443-446449,38593856-38593862,565653-565659,
    824824821-824824827,2121212118-2121212124
    """

  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part1()) == "1227775554")
  }

  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part2()) == "4174379265")
  }
  
  @Test(arguments: [
    (11, false),
    (22, false),
    (99, false),
    (111, false),
    (999, false),
    (1010, false),
    (1188511885, false),
    (222222, false),
    (446446, false),
    (38593859, false),
    (565656, false),
    (824824824, false),
    (2121212121, false),
    (1234567, true),
    (89256, true),
    (1111122222, true),
  ])
  func testPart2Valid(_ id: Int, expectedValid: Bool) {
    #expect(Day02.isIdValidPart2(id) == expectedValid)
  }
}
