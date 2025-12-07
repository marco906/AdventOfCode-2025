struct Day04: AdventDay {
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
  
  func isRoll(_ position: Position, map: [[String]]) -> Bool {
    guard position.x >= 0 && position.y >= 0 else { return false }
    guard position.x < numCols && position.y < numRows else { return false }
    return map[position.y][position.x] == "@"
  }
  
  func getLiftableRolls(remove: Bool, map: inout [[String]]) -> Int {
    var liftableRolls: [Position] = []
    for rowIndex in 0..<numRows {
      for columnIndex in 0..<numCols{
        
        let current = Position(x: columnIndex, y: rowIndex)
        guard isRoll(current, map: map) else { continue }
        let top = Position(x: columnIndex - 1, y: rowIndex)
        let topLeft = Position(x: columnIndex - 1, y: rowIndex - 1)
        let topRight = Position(x: columnIndex - 1, y: rowIndex + 1)
        
        let bottom = Position(x: columnIndex + 1, y: rowIndex)
        let bottomLeft = Position(x: columnIndex + 1, y: rowIndex - 1)
        let bottomRight = Position(x: columnIndex + 1, y: rowIndex + 1)
        
        let left = Position(x: columnIndex, y: rowIndex - 1)
        let right = Position(x: columnIndex, y: rowIndex + 1)
        
        let adjacentRolls = [top, topLeft, topRight, bottom, bottomLeft, bottomRight, right, left].filter{ isRoll($0, map: map) }.count
        if adjacentRolls < 4 {
          liftableRolls += [current]
        }
      }
    }
    
    if remove {
      for pos in liftableRolls {
        map[pos.y][pos.x] = "."
      }
      
      if liftableRolls.count != 0 {
        return liftableRolls.count + getLiftableRolls(remove: true, map: &map)
      }
    }
    
    return liftableRolls.count
  }
  
  func part1() -> Any {
    var map = self.map
    return getLiftableRolls(remove: false, map: &map)
  }
  
  func part2() -> Any {
    var map = self.map
    return getLiftableRolls(remove: true, map: &map)
  }
}
