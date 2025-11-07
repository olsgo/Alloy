// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Alloy",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "Alloy",
            targets: ["Alloy", "AlloyShadersSharedTypes"]
        )
    ],
    targets: [
        .target(
            name: "AlloyShadersSharedTypes",
            publicHeadersPath: "."
        ),
        .target(
            name: "Alloy",
            dependencies: [
                .target(name: "AlloyShadersSharedTypes")
            ],
            resources: [
                .process("Shaders/Shaders.metal")
            ]
        ),
        .target(
            name: "AlloyTestsResources",
            path: "Tests/AlloyTestsResources",
            resources: [
                .copy("Shared"),
                .copy("TextureCopy")
            ]
        ),
        .testTarget(
            name: "AlloyTests",
            dependencies: ["Alloy", "AlloyTestsResources"],
            resources: [
                .process("Shaders/Shaders.metal")
            ]
        )
    ]
)
