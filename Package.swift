// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SleepingCatApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "SleepingCatApp", targets: ["SleepingCatApp"])
    ],
    targets: [
        .executableTarget(
            name: "SleepingCatApp",
            resources: [
                .process("Resources")
            ]
        )
    ]
)