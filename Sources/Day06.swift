struct Day06: AdventDay {
  var map: [[String]]
  var mapAligned: [[Character]]

  init(data: String) {
    let lines = data.split(separator: "\n").map { String($0) }
    self.map = lines.map { $0.split(separator: " ").map { String($0) } }
    self.mapAligned = lines.map { Array($0) }
  }

  func part1() async -> Any {
    var sum = 0
    for colIndex in 0..<map[0].count {
      let col = map.dropLast().map { Int($0[colIndex])! }
      let isMultiply = map.last![colIndex] == "*"
      sum += isMultiply ? col.reduce(1, *) : col.reduce(0, +)
    }
    return sum
  }

  func part2() async -> Any {
    let numberRows = mapAligned.dropLast()
    let operatorRow = mapAligned.last!
    
    var sum = 0
    var currentNumbers: [Int] = []
    var currentOperator: Character? = nil
    
    for colIndex in 0..<mapAligned[0].count {
      // concatenate digits top-to-bottom
      let verticalNumber = numberRows.map { String($0[colIndex]) }.filter { $0 != " " }.joined()
      
      if !verticalNumber.isEmpty {
        if currentOperator == nil {
          currentOperator = operatorRow[colIndex]
        }
        currentNumbers.append(Int(verticalNumber)!)

      } else {
        // Empty column: process previous group
        if !currentNumbers.isEmpty {
          let isMultiply = currentOperator == "*"
          sum += isMultiply ? currentNumbers.reduce(1, *) : currentNumbers.reduce(0, +)
          currentNumbers = []
          currentOperator = nil
        }
      }
    }
    
    // Handle last group
    if !currentNumbers.isEmpty {
      let isMultiply = currentOperator == "*"
      sum += isMultiply ? currentNumbers.reduce(1, *) : currentNumbers.reduce(0, +)
    }
    
    return sum
  }
}
