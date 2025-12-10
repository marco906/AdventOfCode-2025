struct Day10: AdventDay {
  init(data: String) {
    self.machines = data.split(separator: "\n").map { Machine(String($0)) }
  }
  
  var machines: [Machine] = []

  struct Machine: Hashable {
    var lights: [Int]
    var buttons: [[Int]]
    var joltages: [Int]
    init(_ instruction: String) {
      let components = instruction.components(separatedBy: " ")
      self.lights = components[0].dropFirst().dropLast().map { $0 == "#" ? 1 : -1 }
      self.buttons = components.dropFirst().dropLast().map { $0.dropFirst().dropLast().components(separatedBy: ",").map { Int($0)! } }
      self.joltages = components.last!.dropFirst().dropLast().components(separatedBy: ",").map { Int($0)! }
    }
  }

  func part1() async -> Any {
    var totalMinPushes = 0
    
    for machine in machines {
      let numLights = machine.lights.count
      let numButtons = machine.buttons.count
      
      var minPushes = Int.max
      
      for combo in 0..<(1 << numButtons) {
        var currentState = [Int](repeating: -1, count: numLights)
        var pushCount = 0
        
        for buttonIdx in 0..<numButtons {
          if (combo >> buttonIdx) & 1 == 1 {
            pushCount += 1
            // Toggle each light this button affects
            for lightIdx in machine.buttons[buttonIdx] {
              currentState[lightIdx] *= -1
            }
          }
        }
        
        // Check if we reached target configuration
        if currentState == machine.lights {
          minPushes = min(minPushes, pushCount)
        }
      }
      
      if minPushes != Int.max {
        totalMinPushes += minPushes
      }
    }
    
    return totalMinPushes
  }
  
  // bfs too slow!
  func part2() async -> Any {
    var totalMinPushes = 0
    var machineNumber = 0
    
    for machine in machines {
      print(machine)
      machineNumber += 1
      let numIndices = machine.joltages.count
      
      var visited: [[Int]: Int] = [:] // diff state -> min pushes to reach it
      var queue: [([Int], Int)] = [] 
      
      let startDiff = machine.joltages
      queue.append((startDiff, 0))
      visited[startDiff] = 0
      
      var minPushes = Int.max
      
      while !queue.isEmpty {
        let (currentDiff, pushes) = queue.removeFirst()
        
        if currentDiff.allSatisfy({ $0 == 0 }) {
          minPushes = pushes
          break
        }
        
        if pushes >= minPushes { continue }
        
        if currentDiff.contains(where: { $0 < 0 }) { continue }
        
        // prioritize buttons that zero out at least one index
        let candidates = machine.buttons.sorted { buttonA, buttonB in
          let zerosA = buttonA.filter { idx in idx < numIndices && currentDiff[idx] == 1 }.count
          let zerosB = buttonB.filter { idx in idx < numIndices && currentDiff[idx] == 1 }.count
          return zerosA > zerosB
        }
        
        for button in candidates {
          var newDiff = currentDiff
          for idx in button {
            if idx < numIndices {
              newDiff[idx] -= 1
            }
          }
          
          let newPushes = pushes + 1
          if visited[newDiff] == nil || visited[newDiff]! > newPushes {
            visited[newDiff] = newPushes
            queue.append((newDiff, newPushes))
          }
        }
      }
      
      if minPushes != Int.max {
        totalMinPushes += minPushes
      }
    }
    
    return totalMinPushes
  }
}
