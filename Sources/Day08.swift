import Algorithms

struct Day08: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { String($0) } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[String]] = []
  var numRows: Int
  var numCols: Int
  
  struct Position: Hashable {
    var x: Int
    var y: Int
  }
  
  func getAntennas() -> [String: [Position]] {
    var res = [String: [Position]]()
    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let value = map[y][x]
        if value != "." {
          res[value, default: []].append(Position(x: x, y: y))
        }
      }
    }
    
    return res
  }
  
  func isInBounds(_ position: Position) -> Bool {
    guard position.x >= 0 && position.y >= 0 else { return false }
    guard position.x < numCols && position.y < numRows else { return false }
    return true
  }
  
  func gcd(_ a: Int, _ b: Int) -> Int {
    let remainder = abs(a) % abs(b)
    if remainder != 0 {
      return gcd(abs(b), remainder)
    } else {
      return abs(b)
    }
  }
  
  func part1() async -> Any {
    var antiNodes: Set<Position> = []
    let antennas = getAntennas()
    
    for freqPositions in antennas.values {
      var postions = freqPositions
      
      while !postions.isEmpty {
        let position = postions.removeLast()
        
        for partner in postions {
          var antiNodesOfPair: [Position] = []
          let dx = partner.x - position.x
          let dy = partner.y - position.y
          
          antiNodesOfPair += [
            Position(x: position.x - dx, y: position.y - dy),
            Position(x: partner.x + dx, y: partner.y + dy),
          ]
          
          antiNodesOfPair.filter { isInBounds($0) }.forEach { antiNodes.insert($0) }
        }
      }
    }
    
    return antiNodes.count
  }
  
  func part2() async -> Any {
    var antiNodes: Set<Position> = []
    let antennas = getAntennas()
    
    for freqPositions in antennas.values {
      var postions = freqPositions
      
      while !postions.isEmpty {
        let position = postions.removeLast()
        
        for partner in postions {
          let dx = partner.x - position.x
          let dy = partner.y - position.y
          
          // get smallest grid distance vector
          let gcd = gcd(dx, dy)
          let dxMin = dx / gcd
          let dyMin = dy / gcd
          
          // move up along vector
          var antiNodeUp = Position(x: position.x + dxMin, y: position.y + dyMin)
          while isInBounds(antiNodeUp) {
            antiNodes.insert(antiNodeUp)
            antiNodeUp.x += dxMin
            antiNodeUp.y += dyMin
          }
          
          // move down along vector
          var antiNodeDown = Position(x: position.x - dxMin, y: position.y - dyMin)
          while isInBounds(antiNodeDown) {
            antiNodes.insert(antiNodeDown)
            antiNodeDown.x -= dxMin
            antiNodeDown.y -= dyMin
          }
          
          antiNodes.insert(position)
        }
      }
    }
    
    return antiNodes.count
  }
}
