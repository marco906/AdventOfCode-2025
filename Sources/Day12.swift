struct Day12: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { String($0) } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[String]] = []
  var numRows: Int
  var numCols: Int

  var directions: [[Int]] = [[0,1], [0, -1], [1, 0], [-1,0]]
  var trailMemory = [Position:Int]()

  struct Position: Hashable {
    var x: Int
    var y: Int
  }

  func isInBounds(_ position: Position) -> Bool {
    guard position.x >= 0 && position.y >= 0 else { return false }
    guard position.x < numCols && position.y < numRows else { return false }
    return true
  }
  
  func value(_ position: Position) -> String {
    return map[position.y][position.x]
  }

  func fence(_ type: String, pos: Position, area: inout Int, perimeter: inout Int, visited: inout [String:Set<Position>]) async {
    if visited[type, default: []].contains(pos) {
      return
    }

    guard isInBounds(pos) else {
      visited[type, default: []].insert(pos)
      perimeter += 1
      return
    }

    let plant = value(pos)
    if plant == type {
      area += 1
      visited[type, default: []].insert(pos)
    } else {
      perimeter += 1
      return
    }

    for dir in directions {
      let newPos = Position(x: pos.x + dir[0], y: pos.y + dir[1])
      await fence(type, pos: newPos, area: &area, perimeter: &perimeter, visited: &visited)
    }
  }

  func fence(_ type: String, pos: Position, area: inout Int, edges: inout Set<Position>, visited: inout [String:Set<Position>]) async {
    guard isInBounds(pos) else {
      visited[type, default: []].insert(pos)
      edges.insert(pos)
      return
    }

    if visited[type, default: []].contains(pos) {
      edges.remove(pos)
      return
    }

    let plant = value(pos)
    if plant == type {
      area += 1
      edges.remove(pos)
      visited[type, default: []].insert(pos)
    } else {
      edges.insert(pos)
      return
    }

    for dir in directions {
      let newPos = Position(x: pos.x + dir[0], y: pos.y + dir[1])
      await fence(type, pos: newPos, area: &area, edges: &edges, visited: &visited)
    }
  }

  func part1() async -> Any {
    var cost = 0
    var visited = [String:Set<Position>]()

    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let type = map[y][x]
        var area = 0
        var perimeter = 0
        await fence(type, pos: Position(x: x, y: y), area: &area, perimeter: &perimeter, visited: &visited)
        cost += area * perimeter
      }
    }

    return cost
  }
  
  func part2() async -> Any {
    var cost = 0
    var visited = [String:Set<Position>]()

    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let type = map[y][x]
        var area = 0
        var edges = Set<Position>()
        await fence(type, pos: Position(x: x, y: y), area: &area, edges: &edges, visited: &visited)
        cost += area * edges.count
      }
    }

    return cost
  }
}
