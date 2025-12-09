struct Day01: AdventDay {
  var data: String

  var turns: [Int] {
    return data.split(separator: "\n").compactMap { Int($0.starts(with: "L") ? "-\($0.dropFirst())" : "\($0.dropFirst())") }
  }

  func part1() -> Any {
    var position = 50
    var zerosVisited = 0
    
    for turn in turns {
      // handle negative modulo in swift
      let newPos = ((position + turn) % 100 + 100) % 100
      
      if newPos == 0 {
        zerosVisited += 1
      }
      
      position = newPos
    }
    
    return zerosVisited
  }

  func part2() -> Any {
    var position = 50
    var zerosVisited = 0

    for turn in turns {
      let increment = turn > 0 ? 1 : -1  // +1 for R (right), -1 for L (left).
      let clicks = abs(turn)

      for _ in 0..<clicks {
        // handle negative modulo in swift
        position = ((position + increment) % 100 + 100) % 100

        if position == 0 {
          zerosVisited += 1
        }
      }
    }

    return zerosVisited
  }
}
