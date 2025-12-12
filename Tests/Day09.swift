import Testing

@testable import AdventOfCode

struct Day09Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    7,1
    11,1
    11,10
    9,10
    9,6
    2,6
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
    await #expect(String(describing: challenge.part2()) == "32")
  }
}
