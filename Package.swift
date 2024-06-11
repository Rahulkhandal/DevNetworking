// swift-tools-version:5.9.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DevNetworking",
    platforms: [
        .iOS(.v17_2),   // Adjust the version as needed
        // Add other platforms (watchOS, tvOS) as needed
    ],
    products: [
        .library(name: "DevNetworking", targets: ["DevNetworking"]),
    ],
    targets: [
        .binaryTarget(
            name: "DevNetworking",
            url: "https://github.com/Rahulkhandal/DevNetworking/OutputFramework/DevNetworking.xcframework.zip",
            checksum: "f29df42b1f9f2d8bcd513f03a5850c2615521d86c500eabd38d08c907a6300ce"
        ),
    ]
)
