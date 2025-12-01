struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  func performInstructions(_ memory: String) -> Int {
    var res = 0
    let pattern = /mul\((\d{1,3}),(\d{1,3})\)/
    
    for match in memory.matches(of: pattern) {
      res += (Int(match.1) ?? 0) * (Int(match.2) ?? 0)
    }
    
    return res
  }
  
  func part1() -> Any {
    return performInstructions(data)
  }
  
  func part2() -> Any {
    let dontPattern = /don't\(\)/
    let doPattern = /do\(\)/
    
    var modData = ""
    let parts = data.split(separator: dontPattern, omittingEmptySubsequences: false).map { String($0) }
    
    for part in parts {
      if let doMatchRange = part.firstMatch(of: doPattern)?.range {
        modData += part[doMatchRange.upperBound...]
      } else {
        if modData.isEmpty {
          modData += part
        }
      }
    }
    
    return performInstructions(modData)
  }
}
