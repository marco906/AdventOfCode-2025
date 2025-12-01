import Algorithms

struct Day04: AdventDay {
  init(data: String) {
    self.matrix = data.split(separator: "\n").map { $0.map { String($0) } }
  }
  
  var matrix: [[String]]
  
  var rows: [String] {
    matrix.map { $0.joined() }
  }
  
  var columns: [String] {
    guard let first = matrix.first else { return [] }
    let indices = first.indices
    
    return indices.map { index in
      matrix.map { $0[index] }.joined()
    }
  }
  
  var diagonals: [String] {
    guard !matrix.isEmpty && matrix.count == matrix[0].count else {
        return []
    }
    
    let size = matrix.count
    var diagonals = [String]()
    
    // Downward diagonals
    for d in -(size - 1)..<size {
        var diagonal = [String]()
        for i in 0..<size {
            let j = i + d
            if j >= 0 && j < size {
                diagonal.append(matrix[i][j])
            }
        }
      diagonals.append(diagonal.joined())
    }
    
    // Upward diagonals
    for d in 0..<(2 * size - 1) {
        var diagonal = [String]()
        for i in 0..<size {
            let j = d - i
            if j >= 0 && j < size {
                diagonal.append(matrix[i][j])
            }
        }
      diagonals.append(diagonal.joined())
    }
    
    return diagonals
  }
  
  func isXmasDiagonal(_ vector: String) -> Bool {
    let pattern = /MAS|SAM/
    
    return vector.wholeMatch(of: pattern) != nil
  }
  
  func part1() -> Any {
    let pattern = /XMAS/
    let patternReverse = /SAMX/
    
    var count = 0
    
    for vector in rows + columns + diagonals {
      count += vector.matches(of: pattern).count
      count += vector.matches(of: patternReverse).count
    }
    
    return count
  }
  
  func part2() -> Any {
    var res = 0
    
    for rowIndex in 1..<matrix.count - 1 {
      for columnIndex in 1..<matrix[rowIndex].count - 1 {
        let current = matrix[rowIndex][columnIndex]
        guard current == "A" else { continue }
        let topLeft = matrix[rowIndex - 1][columnIndex - 1]
        let bottomRight = matrix[rowIndex + 1][columnIndex + 1]
        
        let diagonal1 = [topLeft, current, bottomRight].joined()
        guard isXmasDiagonal(diagonal1) else { continue }
        
        let topRight = matrix[rowIndex - 1][columnIndex + 1]
        let bottomLeft = matrix[rowIndex + 1][columnIndex - 1]
        
        let diagonal2 = [topRight, current, bottomLeft].joined()
        guard isXmasDiagonal(diagonal2) else { continue }
        
        res += 1
      }
    }
    
    return res
  }
}
