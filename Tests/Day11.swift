import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day11Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    aaa: you hhh
    you: bbb ccc
    bbb: ddd eee
    ccc: ddd eee fff
    ddd: ggg
    eee: out
    fff: out
    ggg: out
    hhh: ccc fff iii
    iii: out
    """
  let testData2: String = """
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """

  @Test
  func testPart1() async throws {
    let challenge = Day11(data: testData)
    await #expect(String(describing: challenge.part1()) == "5")
  }

  @Test
  func testPart2() async throws {
    let challenge = Day11(data: testData2)
    await #expect(String(describing: challenge.part2()) == "2")
  }
}
