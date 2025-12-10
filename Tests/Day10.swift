import Testing

@testable import AdventOfCode

struct Day10Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    [#.#..###.] (2,3,4,5) (3,4,5) (0,1,2,3,5,6) (1,3,7) (0,1,3,7) (0,1,4,5,7,8) (0,1,3,6,7,8) (1,2,3,5,6,8) (0,2,5,6) {59,48,29,42,22,50,38,35,27}
    """

  @Test
  func testPart1() async throws {
    let challenge = Day10(data: testData)
    await #expect(String(describing: challenge.part1()) == "2")
  }

  @Test
  func testPart2() async throws {
    let challenge = Day10(data: testData)
    await #expect(String(describing: challenge.part2()) == "71")
  }
}
