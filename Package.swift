// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Flow",
    products: [
        .library(
            name: "Flow",
            targets: ["Flow"]
        ),
    ],
    targets: [
        .target(
            name: "Flow",
            dependencies: []
        ),
        .testTarget(
            name: "FlowTests",
            dependencies: ["Flow"]
        ),
    ]
)
