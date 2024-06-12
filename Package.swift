// swift-tools-version:5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DevNetworking",
    platforms: [.iOS("17.2")],
    products: [
        .library(name: "DevNetworking", targets: ["DevNetworking"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "DevNetworking",
            path: "OutputFramework/DevNetworking.xcframework"
        )
    ]
)
