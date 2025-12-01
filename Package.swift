// swift-tools-version: 6.0
import PackageDescription

let dependencies: [Target.Dependency] = [
]

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)],
  dependencies: [
  ],
  targets: [
    .executableTarget(
      name: "AdventOfCode",
      dependencies: dependencies,
      resources: [.copy("Data")]
    ),
    .testTarget(
      name: "AdventOfCodeTests",
      dependencies: ["AdventOfCode"] + dependencies
    )
  ],
  swiftLanguageModes: [.v6]
)
