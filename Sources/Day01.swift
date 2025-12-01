import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() -> Any {
    let l1 = entities.map { $0[0] }.sorted()
    let l2 = entities.map { $0[1] }.sorted()

    return l1.indices.reduce(0) { $0 + abs(l1[$1] - l2[$1]) }
  }

  func part2() -> Any {
    let l1 = entities.map { $0[0] }
    let l2 = entities.map { $0[1] }

    let frequencyL2 = l2.reduce(into: [:]) { $0[$1, default: 0] += 1 }

    return l1.reduce(0) { $0 + ($1 * frequencyL2[$1, default: 0]) }
  }
}
