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
    
    /// Bit-packed MITM solution with greedy bound pruning for minimum button presses
    func minPressesForJoltages() -> Int {
      let target = joltages
      let n = target.count
      guard !buttons.isEmpty else { return 0 }

      // Bit-packed state: 8 bits per position, up to 16 positions in UInt128 equivalent
      struct PackedState: Hashable {
        var low: UInt64
        var high: UInt64

        init() { low = 0; high = 0 }

        init(low: UInt64, high: UInt64) { self.low = low; self.high = high }

        mutating func add(at i: Int, value: Int) {
          if i < 8 {
            low = low &+ (UInt64(value) << (i * 8))
          } else {
            high = high &+ (UInt64(value) << ((i - 8) * 8))
          }
        }

        func get(at i: Int) -> Int {
          if i < 8 {
            return Int((low >> (i * 8)) & 0xFF)
          } else {
            return Int((high >> ((i - 8) * 8)) & 0xFF)
          }
        }

        func subtract(_ other: PackedState) -> PackedState {
          PackedState(low: low &- other.low, high: high &- other.high)
        }
      }

      func pack(_ arr: [Int]) -> PackedState {
        var s = PackedState()
        for (i, v) in arr.enumerated() { s.add(at: i, value: v) }
        return s
      }

      let targetPacked = pack(target)

      // Greedy upper bound: iteratively pick best button until solved or limit reached
      func greedyUpperBound() -> Int {
        var current = [Int](repeating: 0, count: n)
        var presses = 0
        let iterationLimit = 1000
        var iterations = 0

        while current != target && iterations < iterationLimit {
          iterations += 1
          let remaining = (0..<n).map { target[$0] - current[$0] }

          var bestButton = -1
          var bestScore = -1.0

          for (i, indices) in buttons.enumerated() {
            var useful = 0
            var waste = 0

            for idx in indices where idx < n {
              if remaining[idx] > 0 {
                useful += 1
              } else {
                waste += 1  // overshooting
              }
            }

            if useful == 0 { continue }

            let score = Double(useful) * 100.0 - Double(waste) * 10.0
                      + Double(useful) / Double(indices.count)

            if score > bestScore {
              bestScore = score
              bestButton = i
            }
          }

          if bestButton == -1 {
            for (i, indices) in buttons.enumerated() {
              if indices.contains(where: { $0 < n && remaining[$0] > 0 }) {
                bestButton = i
                break
              }
            }
          }

          if bestButton == -1 { break }

          for idx in buttons[bestButton] where idx < n {
            current[idx] += 1
          }
          presses += 1
        }

        return current == target ? presses : Int.max
      }

      // Try greedy first - if it finds a solution, use it and skip MITM
      let greedyResult = greedyUpperBound()
      if greedyResult != Int.max {
        print("Greedy solution found: \(greedyResult)")
        return greedyResult
      }

      // Greedy failed, run MITM to find optimal solution
      print("Greedy solution not found, running MITM...")

      // Max presses per button (bounded by min target value it affects)
      let maxPresses: [Int] = buttons.map { button in
        button.filter { $0 < n }.map { target[$0] }.min() ?? 0
      }

      // Sort buttons by maxPresses ascending for better pruning
      let sortedIndices = maxPresses.indices.sorted { maxPresses[$0] < maxPresses[$1] }
      let sortedButtons = sortedIndices.map { buttons[$0] }
      let sortedMaxPresses = sortedIndices.map { maxPresses[$0] }

      // Precompute button effects
      let buttonEffects: [PackedState] = sortedButtons.map { button in
        var s = PackedState()
        for i in button where i < n { s.add(at: i, value: 1) }
        return s
      }

      // Balanced split using log-product heuristic
      func findBalancedSplit() -> Int {
        let count = sortedButtons.count
        if count <= 2 { return count / 2 }
        let logCosts = sortedMaxPresses.map { log(Double($0 + 1)) }
        let totalLog = logCosts.reduce(0, +)
        var cumLog = 0.0
        for i in 0..<count {
          cumLog += logCosts[i]
          if cumLog >= totalLog / 2 { return max(1, min(count - 1, i + 1)) }
        }
        return count / 2
      }

      let mid = findBalancedSplit()

      // Check if state exceeds target
      func exceedsTarget(_ state: PackedState) -> Bool {
        for i in 0..<n { if state.get(at: i) > target[i] { return true } }
        return false
      }

      // Enumerate left half
      var leftStates: [PackedState: Int] = [:]

      func enumerateLeft(_ idx: Int, _ state: PackedState, _ presses: Int) {
        if idx == mid {
          if let existing = leftStates[state], existing <= presses { return }
          leftStates[state] = presses
          return
        }
        var s = state
        for count in 0...sortedMaxPresses[idx] {
          if count > 0 {
            s.low = s.low &+ buttonEffects[idx].low
            s.high = s.high &+ buttonEffects[idx].high
          }
          if exceedsTarget(s) { break }
          enumerateLeft(idx + 1, s, presses + count)
        }
      }
      enumerateLeft(0, PackedState(), 0)

      // Enumerate right half
      var bestPresses = Int.max

      func enumerateRight(_ idx: Int, _ state: PackedState, _ presses: Int) {
        if presses >= bestPresses { return }
        if idx == sortedButtons.count {
          let needed = targetPacked.subtract(state)
          // Verify no underflow (each component should be <= target)
          for i in 0..<n {
            let v = needed.get(at: i)
            if v > target[i] { return }  // underflow happened
          }
          if let leftPresses = leftStates[needed] {
            bestPresses = min(bestPresses, presses + leftPresses)
          }
          return
        }
        var s = state
        for count in 0...sortedMaxPresses[idx] {
          if count > 0 {
            s.low = s.low &+ buttonEffects[idx].low
            s.high = s.high &+ buttonEffects[idx].high
          }
          if exceedsTarget(s) { break }
          enumerateRight(idx + 1, s, presses + count)
        }
      }
      enumerateRight(mid, PackedState(), 0)

      return bestPresses == Int.max ? 0 : bestPresses
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
