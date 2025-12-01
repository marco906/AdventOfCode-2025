struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var reports: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func isSafe(_ report: [Int], allowBadLevel: Bool = false) -> Bool {
    let diffs = zip(report, report.dropFirst()).map { $1 - $0 }

    let isIncreasing = diffs.allSatisfy { $0 > 0 && $0 <= 3 }
    let isDecreasing = diffs.allSatisfy { $0 < 0 && $0 >= -3 }

    if isIncreasing || isDecreasing {
      return true
    }

    if allowBadLevel {
      for index in 0..<report.count {
        var modReport = report
        modReport.remove(at: index)
        if isSafe(modReport, allowBadLevel: false) {
          return true
        }
      }
    }

    return false
  }

  func part1() -> Any {
    return reports.filter { isSafe($0, allowBadLevel: false) }.count
  }

  func part2() -> Any {
    return reports.filter { isSafe($0, allowBadLevel: true) }.count
  }
}
