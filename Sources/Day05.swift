struct Day05: AdventDay {
  init(data: String) {
    let dataComponents = data.split(separator: "\n\n").map { String($0) }
    self.rangesFresh = dataComponents[0].split(separator: "\n").map { $0.components(separatedBy: "-").map { Int($0)! } }
    self.available = dataComponents[1].split(separator: "\n").map { Int($0)! }
  }
  
  var rangesFresh: [[Int]]
  var available: [Int]
  
  func part1() -> Any {
    var count = 0
    
    outerloop: for a in available {
      for range in rangesFresh {
        if range[0] <= a && a <= range[1] {
          count += 1
          continue outerloop
        }
      }
    }
    
    return count
  }
  
  func part2() -> Any {
    let sorted = rangesFresh.sorted { $0[0] < $1[0] }
    var start = sorted[0][0]
    var end = sorted[0][1]
    var count = 0
    for range in sorted.dropFirst() {
      if range[0] <= end + 1 {
        end = max(end, range[1])
      } else {
        count += end - start + 1
        start = range[0]
        end = range[1]
      }
    }
    count += end - start + 1
    return count
  }
}

