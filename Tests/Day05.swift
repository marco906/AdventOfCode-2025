import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day05Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """
  
  let testData2 = """
    3-5
    10-14
    16-20
    12-18
    
    0
    """

  @Test
  func testPart1() async throws {
    let challenge = Day05(data: testData)
    #expect(String(describing: challenge.part1()) == "3")
  }

  @Test
  func testPart2() async throws {
    let challenge = Day05(data: testData2)
    #expect(String(describing: challenge.part2()) == "14")
  }
}
