struct Day07: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { String($0) } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[String]] = []
  var numRows: Int
  var numCols: Int
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }
  
  func isSplitter(_ position: Position) -> Bool {
    return map[position.y][position.x] == "^"
  }

  func isInBounds(_ position: Position) -> Bool {
    guard position.x >= 0 && position.y >= 0 else { return false }
    guard position.x < numCols && position.y < numRows else { return false }
    return true
  }
  
  func getNext(pos: Position) -> [Position] {
    var next = [Position]()
    if isSplitter(pos) {
      next.append(Position(x: pos.x + 1, y: pos.y + 1))
      next.append(Position(x: pos.x - 1, y: pos.y + 1))
    } else {
      next.append(Position(x: pos.x, y: pos.y + 1))
    }
    
    return next
  }
  
  func getSplits(pos: Position, visited: inout Set<Position>) -> Int {
    var splits = 0

    if visited.contains(pos) {
      return splits
    }
    visited.insert(pos)

    guard isInBounds(pos) else { return splits }
    
    let nextPositions = getNext(pos: pos)
    splits += nextPositions.count > 1 ? 1 : 0

    for position in getNext(pos: pos) {
      splits += getSplits(pos: position, visited: &visited)
    }
    
    return splits
  }

  func getTimelines(pos: Position, visited: inout [Position: Int]) -> Int {
    var timelines = 0

    if let cached = visited[pos] {
      return cached
    }

    guard isInBounds(pos) else {
      visited[pos] = timelines
      return timelines
    }

    let nextPositions = getNext(pos: pos)
    timelines += nextPositions.count > 1 ? 1 : 0

    for position in getNext(pos: pos) {
      timelines += getTimelines(pos: position, visited: &visited)
    }

    visited[pos] = timelines
    
    return timelines
  }
  
  func getStartPosition() -> Position {
    for y in 0..<numRows {
      for x in 0..<numCols {
        if map[y][x] == "S" {
          return Position(x: x, y: y)
        }
      }
    }
    fatalError("No start position found")
  }
  
  func part1() async -> Any {
    var visited = Set<Position>()
    let start = getStartPosition()
    return getSplits(pos: start, visited: &visited)
  }
  
  func part2() async -> Any {
    var visited = [Position: Int]()
    let start = getStartPosition()
    return getTimelines(pos: start, visited: &visited) + 1
  }
}
