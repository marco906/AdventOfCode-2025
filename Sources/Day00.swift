import Algorithms

struct Day00: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var turns: [Int] {
    let modData = data.replacingOccurrences(of: "L", with: "-").replacingOccurrences(of: "R", with: "")
    return modData.split(separator: "\n").compactMap { Int($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
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

  // Replace this with your solution for the second part of the day's challenge.
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
