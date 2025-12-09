struct Day09: AdventDay {
  init(data: String) {
    self.tiles = data.split(separator: "\n").map { $0.split(separator: ",").map { Int(String($0))!} }.map { Position(x: $0[0], y: $0[1]) }
  }
  
  var tiles: [Position] = []
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }

  func part1() async -> Any {
    var maxArea = 0
    
    for i in 0..<tiles.count {
      for j in (i + 1)..<tiles.count {
        let t1 = tiles[i]
        let t2 = tiles[j]
        let area = (abs(t2.x - t1.x) + 1) * (abs(t2.y - t1.y) + 1)
        maxArea = max(maxArea, area)
      }
    }
    
    return maxArea
  }
  
  func part2() async -> Any {
    var horizontalEdges: [(y: Int, xMin: Int, xMax: Int)] = []
    var verticalEdges: [(x: Int, yMin: Int, yMax: Int)] = []
    var maxArea = 0
    
    func isInside(_ pos: Position) -> Bool {
      var count = 0
      for edge in verticalEdges {
        if edge.x < pos.x && edge.yMin < pos.y && pos.y < edge.yMax {
          count += 1
        }
      }
      // If crossing odd number of edges, point is inside polygon
      return count % 2 == 1
    }
    
    func isRectangleInsidePolygon(x1: Int, y1: Int, x2: Int, y2: Int) -> Bool {
      let minX = min(x1, x2)
      let maxX = max(x1, x2)
      let minY = min(y1, y2)
      let maxY = max(y1, y2)
      
      // line or point from red tiles is always inside
      if minX == maxX || minY == maxY {
        return true
      }
      
      if !isInside(Position(x: minX + 1, y: minY + 1)) {
        return false
      }
      
      // Check horizontal edge intersection
      for edge in horizontalEdges {
        if edge.y > minY && edge.y < maxY {
          if edge.xMin < maxX && edge.xMax > minX {
            return false
          }
        }
      }
      
      // Check vertical edge intersection
      for edge in verticalEdges {
        if edge.x > minX && edge.x < maxX {
          if edge.yMin < maxY && edge.yMax > minY {
            return false
          }
        }
      }
      
      return true
    }

    // Get polygon edges by connecting all red tiles
    for i in 0..<tiles.count {
      let current = tiles[i]
      let next = tiles[(i + 1) % tiles.count]
      
      if current.y == next.y {
        horizontalEdges.append((y: current.y, xMin: min(current.x, next.x), xMax: max(current.x, next.x)))
      } else {
        verticalEdges.append((x: current.x, yMin: min(current.y, next.y), yMax: max(current.y, next.y)))
      }
    }
    
    // Check all possible rectangles from red tiles if inside polygon
    for i in 0..<tiles.count {
      for j in (i + 1)..<tiles.count {
        let t1 = tiles[i]
        let t2 = tiles[j]
        
        if isRectangleInsidePolygon(x1: t1.x, y1: t1.y, x2: t2.x, y2: t2.y) {
          let area = (abs(t2.x - t1.x) + 1) * (abs(t2.y - t1.y) + 1)
          maxArea = max(maxArea, area)
        }
      }
    }
    
    return maxArea
  }
}
