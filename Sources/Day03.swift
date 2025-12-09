struct Day03: AdventDay {
  var data: String
  
  var batteryRows: [[Int]] {
    data.split(separator: "\n").map { $0.map { Int(String($0))! } }
  }
  
  func getJoltage(digits: Int) -> Int {
    var sum = 0
    for row in batteryRows {
      var joltage = ""
      var modRow = row
      var currentDigit = digits
      while currentDigit > 0 {
        let number = modRow.dropLast(currentDigit - 1).max()!
        let index = modRow.firstIndex(of: number)!
        let nextIndex = min(modRow.count - 1, index + 1)
        modRow = Array(modRow[nextIndex...])
        currentDigit -= 1
        joltage += String(number)
      }
      sum += Int(joltage)!
    }
    return sum
  }
  
  func part1() -> Any {
    return getJoltage(digits: 2)
  }
  
  func part2() -> Any {
    getJoltage(digits: 12)
  }
}
