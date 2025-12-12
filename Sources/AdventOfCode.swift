
// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
//  Day01(),
//  Day02(),
//  Day03(),
//  Day04(),
//  Day05(),
//  Day06(),
//  Day07(),
//  Day08(),
//  Day09(),
//  Day10(),
//  Day11(),
  Day12(),
]

@main
struct AdventOfCode {
  //@Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  // @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = true

  // @Flag(help: "Run all the days available")
  var all: Bool = false
  
  public static func main() async {
    do {
      try await AdventOfCode().run()
    } catch {
      print(error)
    }
  }

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError.noSolution
        }
      } else {
        return latestChallenge
      }
    }
  }
  
  enum ValidationError: Swift.Error {
    case noSolution
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

  func run<T>(part: () async throws -> T, named: String) async -> Duration {
    var result: Result<T, Error>?
    let timing = await ContinuousClock().measure {
      do {
        result = .success(try await part())
      } catch {
        result = .failure(error)
      }
    }
    
    let formatted = timing.formatted(
      .units(allowed: [.seconds], width: .abbreviated, fractionalPart: .show(length: 4)))
    
    switch result! {
    case .success(let success):
      print("\(named): \(formatted)\t\(success)")
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    let challenges =
      if all {
        allChallenges
      } else {
        try [selectedChallenge]
      }

    var totalTime = Duration.zero

    for challenge in challenges {
      let day = String(format: "%02d", challenge.day)

      let timing1 = await run(part: challenge.part1, named: "Day \(day).1")
      let timing2 = await run(part: challenge.part2, named: "Day \(day).2")
      print("-")

      totalTime += timing1 + timing2

      if benchmark {
        #if DEBUG
          print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }

    print("Total: \(totalTime.formatted(.units(allowed: [.seconds], width: .abbreviated, fractionalPart: .show(length: 4))))")
  }
}
