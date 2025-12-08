struct Day08: AdventDay {
  init(data: String) {
    self.boxes = data.split(separator: "\n").map { $0.split(separator: ",").map { Int(String($0))!} }.map { Position(x: $0[0], y: $0[1], z: $0[2]) }
  }
  
  var boxes: [Position] = []
  
  struct Position: Hashable {
    let x: Int
    let y: Int
    let z: Int
  }
  
  class Circuit {
    let pos: Position
    var parent: Circuit?
    var size: Int = 1
    
    init(pos: Position) {
      self.pos = pos
    }
    
    func getRoot() -> Circuit {
      parent?.getRoot() ?? self
    }
    
    func connect(with other: Circuit) {
      let rootA = self.getRoot()
      let rootB = other.getRoot()
      guard rootA !== rootB else { return }
      rootA.parent = rootB
      rootB.size += rootA.size
    }
    
    func distanceSquared(to other: Circuit) -> Int {
      let dx = pos.x - other.pos.x
      let dy = pos.y - other.pos.y
      let dz = pos.z - other.pos.z
      return dx*dx + dy*dy + dz*dz
    }
  }
  
  func getClosestPairs(circuits: [Circuit]) -> [(Circuit, Circuit, Int)] {
    var pairs: [(Circuit, Circuit, Int)] = []
    for i in 0..<circuits.count {
      for j in i+1..<circuits.count {
        let dist = circuits[i].distanceSquared(to: circuits[j])
        pairs.append((circuits[i], circuits[j], dist))
      }
    }
    pairs.sort{ $0.2 < $1.2 }
    return pairs
  }
  
  func part1() async -> Any {
    let iterations = 1000
    let circuits = boxes.map { Circuit(pos: $0) }
    let pairs = getClosestPairs(circuits: circuits)

    for (a, b, _) in pairs.prefix(iterations) {
      a.connect(with: b)
    }
    
    let sizes = circuits.filter { $0.parent == nil }.map { $0.size }.sorted(by: >)
    return sizes.prefix(3).reduce(1, *)
  }
  
  func part2() async -> Any {
    let circuits = boxes.map { Circuit(pos: $0) }
    let pairs = getClosestPairs(circuits: circuits)
    
    var lastA: Circuit?
    var lastB: Circuit?
    
    for (a, b, _) in pairs {
      if a.getRoot() !== b.getRoot() {
        lastA = a
        lastB = b
        a.connect(with: b)
        
        if a.getRoot().size == circuits.count {
          break
        }
      }
    }
    
    return lastA!.pos.x * lastB!.pos.x
  }
}
