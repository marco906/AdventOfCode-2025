import Foundation

struct Day02: AdventDay {
  var data: String

  var ranges: [[String]] {
    data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map {
      $0.split(separator: "-").map { String($0) }
    }
  }

  func part1() -> Any {
    var invalidNumbersSum = 0
    for range in ranges {
      let start = range[0]
      let end = range[1]
      let startNumber = Int(start)!
      let endNumber = Int(end)!
      
      let isEven = start.count % 2 == 0
      let halfLength = isEven ? start.count / 2 : (start.count + 1) / 2
      
      var nextHalf = isEven ? Int(String(start.prefix(halfLength)))! : Int(pow(10, Double(halfLength - 1)))
      var nextNumber = Int("\(nextHalf)\(nextHalf)")!
      
      if nextNumber < startNumber {
        nextHalf += 1
        nextNumber = Int("\(nextHalf)\(nextHalf)")!
      }
      
      while nextNumber <= endNumber {
        invalidNumbersSum += nextNumber
        nextHalf += 1
        nextNumber = Int("\(nextHalf)\(nextHalf)")!
      }
    }
    
    return invalidNumbersSum
  }
  
  func part2() -> Any {
    var invalidNumbersSum = 0
    for range in ranges {
      let start = range[0]
      let end = range[1]
      let startNumber = Int(start)!
      let endNumber = Int(end)!
      
      for n in startNumber...endNumber {
        let numberString = String(n)
        // Substring pattern check with double string overlap
        let s = (numberString + numberString).dropFirst().dropLast()
        if s.contains(numberString) {
          invalidNumbersSum += n
        }
      }
    }
    
    return invalidNumbersSum
  }
}
