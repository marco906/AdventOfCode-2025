import Algorithms

struct Day10: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { Int(String($0)) ?? 0 } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[Int]] = []
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
  
  func isSummit(_ position: Position) -> Bool {
    return map[position.y][position.x] == 9
  }

  func hike(pos: Position, summits: inout Set<Position>) {
    if isSummit(pos) {
      summits.insert(pos)
      return
    }

    for dir in directions {
      let newPos = Position(x: pos.x + dir[0], y: pos.y + dir[1])
      guard isInBounds(newPos), map[newPos.y][newPos.x] == map[pos.y][pos.x] + 1 else {
        continue
      }
      hike(pos: newPos, summits: &summits)
    }
  }
  
  func hike(pos: Position, trails: inout Int, memory: inout [Position:Int]) {
    if isSummit(pos) {
      trails += 1
      return
    }
    
    let trailsBefore = trails
    if let memorized = memory[pos] {
      trails += memorized
      return
    }

    for dir in directions {
      let newPos = Position(x: pos.x + dir[0], y: pos.y + dir[1])
      guard isInBounds(newPos), map[newPos.y][newPos.x] == map[pos.y][pos.x] + 1 else {
        continue
      }
      hike(pos: newPos, trails: &trails, memory: &memory)
    }

    memory[pos] = trails - trailsBefore
  }

  func part1() async -> Any {
    var res = 0

    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let value = map[y][x]
        if value == 0 {
          var summits: Set<Position> = []
          hike(pos: Position(x: x, y: y), summits: &summits)
          res += summits.count
        }
      }
    }

    return res
  }
  
  func part2() async -> Any {
    var res = 0
    var memory = [Position:Int]()

    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let value = map[y][x]
        if value == 0 {
          var trails = 0
          hike(pos: Position(x: x, y: y), trails: &trails, memory: &memory)
          res += trails
        }
      }
    }

    return res
  }
}
