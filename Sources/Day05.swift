import Algorithms

struct Day05: AdventDay {
  init(data: String) {
    let dataComponents = data.split(separator: "\n\n").map { String($0) }
    self.rules = dataComponents[0].split(separator: "\n").map { $0.components(separatedBy: "|").compactMap { Int($0) } }
    self.updates = dataComponents[1].split(separator: "\n").map { $0.components(separatedBy: ",").compactMap { Int($0) } }
  }
  
  var rules: [[Int]]
  var updates: [[Int]]
  
  func part1() -> Any {
    var res = 0
    let rulesDict = rules.reduce(into: [Int : Set<Int>]()) { $0[$1[1], default: []].insert($1[0]) }
    
    updateLoop: for update in updates {
      var pagesAfter = Set(update)

      for page in update {
        pagesAfter.remove(page)
        let pagesRequiredBefore = rulesDict[page] ?? []

        if pagesRequiredBefore.isEmpty || pagesAfter.isDisjoint(with: pagesRequiredBefore) {
          continue
        } else {
          continue updateLoop
        }
      }
      
      let middleIndex = update.count / 2
      res += update[middleIndex]
    }
    
    return res
  }
  
  func part2() -> Any {
    var res = 0
    let rulesDict = rules.reduce(into: [Int : Set<Int>]()) { $0[$1[1], default: []].insert($1[0]) }
    
    for update in updates {
      let pagesAll = Set(update)
      var pagesAfter = pagesAll
      var needsFix = false

      for page in update {
        pagesAfter.remove(page)
        let pagesRequiredBefore = rulesDict[page] ?? []

        if pagesRequiredBefore.isEmpty || pagesAfter.isDisjoint(with: pagesRequiredBefore) {
          continue
        } else {
          needsFix = true
          break
        }
      }
      
      if needsFix {
        let fixedUpdate = update.sorted{
          rulesDict[$1, default: []].intersection(pagesAll).count < rulesDict[$0, default: []].intersection(pagesAll).count
        }
        
        let middleIndex = fixedUpdate.count / 2
        res += fixedUpdate[middleIndex]
      }
    }
    
    return res
  }
}
