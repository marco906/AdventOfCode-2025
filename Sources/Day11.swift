struct Day11: AdventDay {
  init(data: String) {
    self.stones = data.split(separator: " ").map { Int(String($0)) ?? 0 }
  }
  
  var stones: [Int] = []

  func blink(stone: Int, count: Int, memory: inout [Int:[Int:Int]]) -> Int {
    if count == 0 {
      return 1
    }

    if let memorized = memory[stone, default: [:]][count] {
      return memorized
    }

    var newStones = [Int]()

    if stone == 0 {
      newStones = [1]
    } else {
      let str = String(stone)
      if str.count % 2 == 0 {
        let mid = str.index(str.startIndex, offsetBy: str.count / 2)
        let left = String(str[..<mid])
        let right = String(str[mid...])
        newStones = [Int(left) ?? 0, Int(right) ?? 0]
      } else {
        newStones = [stone * 2024]
      }
    }

    let res = newStones.reduce(0) { $0 + blink(stone: $1, count: count - 1, memory: &memory) }
    memory[stone, default: [:]][count] = res

    return res
  }

  func part1() async -> Any {
    var memory = [Int:[Int:Int]]()
    return stones.reduce(0) { $0 + blink(stone: $1, count: 25, memory: &memory) }
  }
  
  func part2() async -> Any {
    var memory = [Int:[Int:Int]]()
    return stones.reduce(0) { $0 + blink(stone: $1, count: 75, memory: &memory) }
  }
}
