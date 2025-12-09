import Testing

@testable import AdventOfCode
// the Elves would like to find the largest rectangle that uses red tiles for two of its opposite corners. They even have a list of where the red tiles are located in the grid (your puzzle input).

struct Day09Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

  @Test
  func testPart1() async throws {
    let challenge = Day09(data: testData)
    await #expect(String(describing: challenge.part1()) == "50")
  }

  @Test
  func testPart2() async throws {
    let challenge = Day09(data: testData)
    await #expect(String(describing: challenge.part2()) == "24")
  }
}
