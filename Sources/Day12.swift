struct Day12: AdventDay {
  var data: String
  
  struct Region {
    let width: Int
    let height: Int
    let cells: Int
    let pieces: Int
    
    var area: Int { width * height }
    var boxes3x3: Int { (width / 3) * (height / 3) }
  }
  
  func parse() -> [Region] {
    let blocks = data.components(separatedBy: "\n\n")
    let cellCounts = blocks.filter { !$0.contains("x") }.map { $0.filter { $0 == "#" }.count }
    
    return data.split(separator: "\n")
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { $0.contains("x") }
      .map { line in
        let parts = line.split(separator: ":")
        let dims = parts[0].split(separator: "x")
        let pieceCount = parts[1].split(separator: " ").map { Int($0)! }
        return Region(
          width: Int(dims[0])!,
          height: Int(dims[1])!,
          cells: zip(pieceCount, cellCounts).map(*).reduce(0, +),
          pieces: pieceCount.reduce(0, +)
        )
      }
  }
  
  func canFit(_ region: Region) -> Bool? {
    if region.cells > region.area { return false }
    // Since all parts have a 3x3 bounding box, they always fit if area is large enough
    if region.pieces <= region.boxes3x3 { return true }
    return nil
  }

  func part1() async -> Any {
    var count = 0
    var uncertain = 0
    for region in parse() {
      if let fits = canFit(region) {
        if fits { count += 1 }
      } else {
        uncertain += 1
      }
    }
    
    if uncertain > 0 {
      return "Sorry, optimistic approach doesn't work: \(uncertain) regions need backtracking"
    }
    return count
  }
  
  func part2() async -> Any { 0 }
}
