// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SleepingCat",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "SleepingCat", targets: ["SleepingCat"])
    ],
    targets: [
        .executableTarget(
            name: "SleepingCat",
            resources: [
                .process("Resources")
            ]
        )
    ]
)