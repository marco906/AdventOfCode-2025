struct Day11: AdventDay {
  init(data: String) {
    self.rack = data.split(separator: "\n").map { String($0) }
  }

  var rack: [String] = []

  class Device {
    var id: String
    var outputs: [Device] = []

    init(id: String) {
      self.id = id
    }
  }

  func buildGraphAndGetStartDevice(id: String) -> Device? {
    var deviceMap: [String: Device] = [:]
    for line in rack {
      let components = line.components(separatedBy: ": ")
      let id = components[0]
      let outputIds = components[1].components(separatedBy: " ")
      
      // Get or create the device
      let device = deviceMap[id] ?? Device(id: id)
      deviceMap[id] = device
      
      // Link to outputs
      for outputId in outputIds {
        let outputDevice = deviceMap[outputId] ?? Device(id: outputId)
        deviceMap[outputId] = outputDevice
        device.outputs.append(outputDevice)
      }
    }
    return deviceMap[id]
  }

  func part1() async -> Any {
    let startId = "you"
    let endId = "out"

    guard let startDevice = buildGraphAndGetStartDevice(id: startId) else {
      return 0
    }

    var visited = Set<String>()

    func dfs(device: Device, visited: inout Set<String>) -> Int {
      if device.id == endId {
        return 1
      }

      if visited.contains(device.id) {
        return 0
      }
      visited.insert(device.id)
      
      var count = 0
      for output in device.outputs {
        count += dfs(device: output, visited: &visited)
      }
      
      // backtrack
      visited.remove(device.id)
      return count
    }

    return dfs(device: startDevice, visited: &visited)
  }
  
  func part2() async -> Any {
    let startId = "svr"
    let endId = "out"
    let mandatory = Set(["dac", "fft"])

    guard let startDevice = buildGraphAndGetStartDevice(id: startId) else {
      return 0
    }

    // store number of paths from device to out that visit remaining mandatory nodes
    var cache: [String: [Set<String>: Int]] = [:]

    func dfs(device: Device, seen: Set<String>) -> Int {
      var seen = seen
      if mandatory.contains(device.id) {
        seen.insert(device.id)
      }
      
      if device.id == endId {
        return seen == mandatory ? 1 : 0
      }
      
      if let cached = cache[device.id]?[seen] {
        return cached
      }
      
      var count = 0
      for output in device.outputs {
        count += dfs(device: output, seen: seen)
      }
      
      cache[device.id, default: [:]][seen] = count
      return count
    }

    return dfs(device: startDevice, seen: Set())
  }
}
