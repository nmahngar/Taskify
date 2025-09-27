// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Taskify",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "Taskify",
            targets: ["Taskify"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.4")
    ],
    targets: [
        .executableTarget(
            name: "Taskify",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios")
            ]
        )
    ]
)
