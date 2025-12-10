import Foundation

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
    
    /// Find minimum button presses to reach light configuration (each button pressed 0 or 1 time)
    func minPressesForLights() -> Int {
      var minPushes = Int.max
      
      for combo in 0..<(1 << buttons.count) {
        var currentState = [Int](repeating: -1, count: lights.count)
        var pushCount = 0
        
        for buttonIdx in 0..<buttons.count {
          if (combo >> buttonIdx) & 1 == 1 {
            pushCount += 1
            for lightIdx in buttons[buttonIdx] {
              currentState[lightIdx] *= -1
            }
          }
        }
        
        if currentState == lights {
          minPushes = min(minPushes, pushCount)
        }
      }
      
      return minPushes == Int.max ? 0 : minPushes
    }
    
    /// Meet-in-the-middle with greedy upper bound
    func minPressesForJoltages() -> Int {
      guard !buttons.isEmpty else { return 0 }
      
      // Constraint propagation: fix buttons that uniquely cover an index
      var reducedJoltages = joltages
      var fixedPresses = 0
      var activeButtons = Array(0..<buttons.count)
      var buttonPresses = [Int](repeating: -1, count: buttons.count)  // -1 = not fixed
      
      var changed = true
      while changed {
        changed = false
        for i in 0..<reducedJoltages.count {
          if reducedJoltages[i] == 0 { continue }
          
          // Find buttons that cover this index
          let coveringButtons = activeButtons.filter { buttons[$0].contains(i) }
          
          if coveringButtons.isEmpty {
            return 0  // Impossible - no button covers this index
          }
          
          if coveringButtons.count == 1 {
            // Only one button covers this index - must press it exactly reducedJoltages[i] times
            let buttonIdx = coveringButtons[0]
            let presses = reducedJoltages[i]
            
            // Apply this button's effect
            for idx in buttons[buttonIdx] where idx < reducedJoltages.count {
              reducedJoltages[idx] -= presses
              if reducedJoltages[idx] < 0 { return 0 }  // Overshot
            }
            
            fixedPresses += presses
            buttonPresses[buttonIdx] = presses
            activeButtons.removeAll { $0 == buttonIdx }
            changed = true
            break
          }
        }
      }
      
      // Check if fully solved by constraint propagation
      if reducedJoltages.allSatisfy({ $0 == 0 }) {
        return fixedPresses
      }
      
      // MITM with adaptive left half size
      let remainingButtons = activeButtons.map { buttons[$0] }
      let n = reducedJoltages.count
      
      // Each button's max presses bounded by min target it affects
      let maxPresses: [Int] = remainingButtons.map { button in
        button.filter { $0 < n }.map { reducedJoltages[$0] }.min() ?? 0
      }
      
      // Sort by maxPresses ascending
      let sortedIndices = maxPresses.indices.sorted { maxPresses[$0] < maxPresses[$1] }
      let sortedButtons = sortedIndices.map { remainingButtons[$0] }
      let sortedMaxPresses = sortedIndices.map { maxPresses[$0] }
      
      // Greedy upper bound
      var bestAnswer = greedy(remaining: reducedJoltages, buttons: remainingButtons, maxPresses: maxPresses) ?? Int.max
      let maxEffectPerPress = remainingButtons.map { $0.count }.max() ?? 1
      
      // Balanced split using log-product heuristic
      let mid = findBalancedSplit(sortedMaxPresses)
      let leftHalf = (buttons: Array(sortedButtons[..<mid]), maxPresses: Array(sortedMaxPresses[..<mid]))
      let rightHalf = (buttons: Array(sortedButtons[mid...]), maxPresses: Array(sortedMaxPresses[mid...]))
      
      // Build left half lookup
      var leftResults: [[Int]: Int] = [:]
      enumerateLeft(leftHalf, target: reducedJoltages, results: &leftResults, bestAnswer: bestAnswer)
      
      // Search right half
      enumerateRight(rightHalf, target: reducedJoltages, leftResults: leftResults, maxEffectPerPress: maxEffectPerPress, bestAnswer: &bestAnswer)
      
      return fixedPresses + (bestAnswer == Int.max ? 0 : bestAnswer)
    }
    
    private func findBalancedSplit(_ maxPresses: [Int]) -> Int {
      let n = maxPresses.count
      if n <= 2 { return n / 2 }
      
      let logCosts = maxPresses.map { log(Double($0 + 1)) }
      let totalLog = logCosts.reduce(0, +)
      let halfLog = totalLog / 2
      
      var cumLog = 0.0
      for i in 0..<n {
        cumLog += logCosts[i]
        if cumLog >= halfLog {
          return max(1, min(n - 1, i + 1))
        }
      }
      return n / 2
    }
    
    private func greedy(remaining: [Int], buttons: [[Int]], maxPresses: [Int]) -> Int? {
      var remaining = remaining
      var totalPresses = 0
      while !remaining.allSatisfy({ $0 == 0 }) {
        var bestButton = -1
        var bestScore = 0
        var bestPresses = 0
        
        for (i, button) in buttons.enumerated() {
          let maxForButton = button.filter { $0 < remaining.count }.map { remaining[$0] }.min() ?? 0
          let actualMax = min(maxForButton, maxPresses[i])
          if actualMax > 0 {
            let reduction = button.filter { $0 < remaining.count }.count * actualMax
            if reduction > bestScore {
              bestScore = reduction
              bestButton = i
              bestPresses = actualMax
            }
          }
        }
        if bestButton == -1 { return nil }
        for idx in buttons[bestButton] where idx < remaining.count {
          remaining[idx] -= bestPresses
        }
        totalPresses += bestPresses
      }
      return totalPresses
    }
    
    private func enumerateLeft(_ group: (buttons: [[Int]], maxPresses: [Int]), target: [Int], results: inout [[Int]: Int], bestAnswer: Int) {
      let n = target.count
      
      func recurse(index: Int, sum: [Int], presses: Int) {
        if presses >= bestAnswer { return }
        
        if index == group.buttons.count {
          if results[sum] == nil || results[sum]! > presses {
            results[sum] = presses
          }
          return
        }
        
        let button = group.buttons[index]
        for count in 0...group.maxPresses[index] {
          var newSum = sum
          for idx in button where idx < n {
            newSum[idx] += count
          }
          if newSum.enumerated().contains(where: { $0.element > target[$0.offset] }) { break }
          recurse(index: index + 1, sum: newSum, presses: presses + count)
        }
      }
      recurse(index: 0, sum: [Int](repeating: 0, count: n), presses: 0)
    }
    
    private func enumerateRight(_ group: (buttons: [[Int]], maxPresses: [Int]), target: [Int], leftResults: [[Int]: Int], maxEffectPerPress: Int, bestAnswer: inout Int) {
      let n = target.count
      let minLeftPresses = leftResults.values.min() ?? 0
      
      func recurse(index: Int, sum: [Int], presses: Int) {
        if presses >= bestAnswer { return }
        if presses + minLeftPresses >= bestAnswer { return }
        
        let remaining = zip(target, sum).map { max(0, $0 - $1) }.reduce(0, +)
        if presses + (remaining + maxEffectPerPress - 1) / maxEffectPerPress >= bestAnswer { return }
        
        if index == group.buttons.count {
          let needed = zip(target, sum).map { $0 - $1 }
          guard needed.allSatisfy({ $0 >= 0 }) else { return }
          if let leftPresses = leftResults[needed] {
            bestAnswer = min(bestAnswer, presses + leftPresses)
          }
          return
        }
        
        let button = group.buttons[index]
        for count in 0...group.maxPresses[index] {
          var newSum = sum
          for idx in button where idx < n {
            newSum[idx] += count
          }
          if newSum.enumerated().contains(where: { $0.element > target[$0.offset] }) { break }
          recurse(index: index + 1, sum: newSum, presses: presses + count)
        }
      }
      recurse(index: 0, sum: [Int](repeating: 0, count: n), presses: 0)
    }
  }

  func part1() async -> Any {
    machines.map { $0.minPressesForLights() }.reduce(0, +)
  }
  
  func part2() async -> Any {
    var total = 0
    for (index, machine) in machines.enumerated() {
        let res = machine.minPressesForJoltages()
        total += res
        print("Current machine number: \(index + 1), \(res)")
    }
    return total
  }
}
