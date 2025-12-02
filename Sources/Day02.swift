struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var ranges: [[String]] {
    data.split(separator: ",").map {
      $0.split(separator: "-").map { String($0) }
    }
  }

  func part1() -> Any {
    var invalidNumbersSum = 0
    for range in ranges {
      let start = range[0]
      let end = range[1]
      let endNumber = Int(end) ?? 0

      let isEven = start.count % 2 == 0
      var halfLength = isEven ? start.count / 2 : (start.count + 1) / 2

      var nextHalf = isEven ? Int(String(start.prefix(halfLength)))! : 10 ^ (halfLength - 1)
      var nextNumber = Int("\(nextHalf)\(nextHalf)")!
      
      print("\(start), \(end)")

      while nextNumber <= endNumber {
        print(nextNumber)
        invalidNumbersSum += nextNumber
        nextHalf += 1
        if String(nextHalf).count > halfLength {
          halfLength += 1
          nextHalf = 10 ^ (halfLength - 1)
        }
        nextNumber = Int("\(nextHalf)\(nextHalf)")!
        
      }
    }

    return invalidNumbersSum
  }

  func part2() -> Any {
    return 0
  }
}
