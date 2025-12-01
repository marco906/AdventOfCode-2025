struct Day06: AdventDay {
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
  
  func getStartPositionAndHeading() -> (Position, Position) {
    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let value = map[y][x]
        switch value {
        case "^":
          return (Position(x: x, y: y), Position(x: x, y: y - 1))
        case ">":
          return (Position(x: x, y: y), Position(x: x + 1, y: y))
        case "<":
          return (Position(x: x, y: y), Position(x: x - 1, y: y))
        case "v":
          return (Position(x: x, y: y), Position(x: x, y: y + 1))
        default:
          break
        }
      }
    }
    
    return (Position(x: 0, y: 0), Position(x: 0, y: 0))
  }
  
  func isObstacle(_ position: Position, map: [[String]]) -> Bool? {
    guard position.x >= 0 && position.y >= 0 else { return nil }
    guard position.x < numCols && position.y < numRows else { return nil }
    return map[position.y][position.x] == "#"
  }
  
  func move(current: Position, heading: Position, visited: inout [Position : Set<Position>], map: [[String]]) async -> Bool {
    if let obstacle = isObstacle(heading, map: map) {
      
      let dx = heading.x - current.x
      let dy = heading.y - current.y
      
      if obstacle {
        // stay and rotate 90 degrees
        let newHeadingX = current.x - dy
        let newHeadingY = current.y + dx
        let newHeading = Position(x: newHeadingX, y: newHeadingY)
        
        // check if stuck
        if visited[current, default: []].contains(newHeading) {
          return false
        }
        
        visited[current, default: []].insert(newHeading)
        
        return await move(current: current, heading: newHeading, visited: &visited, map: map)
        
      } else {
        // move ahead
        let newHeadingX = heading.x + dx
        let newHeadingY = heading.y + dy
        let newHeading = Position(x: newHeadingX, y: newHeadingY)
        
        // check if stuck
        if visited[current, default: []].contains(newHeading) {
          return false
        }
        
        visited[heading, default: []].insert(newHeading)
        
        return await move(current: heading, heading: newHeading, visited: &visited, map: map)
      }
      
    } else {
      return true
    }
  }
  
  func part1() async -> Any {
    let start = getStartPositionAndHeading()
    let startPosition = start.0
    let startHeading = start.1
    
    var visited = [Position : Set<Position>]()
    visited[startPosition, default: []].insert(startHeading)
    
    let _ = await move(current: startPosition, heading: startHeading, visited: &visited, map: map)
    
    return visited.count
  }
  
  func part2() async -> Any {
    let start = getStartPositionAndHeading()
    let startPosition = start.0
    let startHeading = start.1
    
    var visited = [Position : Set<Position>]()
    visited[startPosition, default: []].insert(startHeading)
    
    let _ = await move(current: startPosition, heading: startHeading, visited: &visited, map: map)
    
    var res = 0
    
    visited.removeValue(forKey: startPosition)
    
    for visitedPos in visited.keys {
      var visited = [Position : Set<Position>]()
      visited[startPosition, default: []].insert(startHeading)
      
      var modMap = map
      modMap[visitedPos.y][visitedPos.x] = "#"
      let escaped = await move(current: startPosition, heading: startHeading, visited: &visited, map: modMap)
      if !escaped {
        res += 1
      }
    }
    
    return res
  }
}
