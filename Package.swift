// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "KAPinField",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "KAPinField",
            targets: ["KAPinField"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KAPinField",
            path: "KAPinField",
            exclude: [
                "Example",
                "Sources/Info.plist",
                "Sources/KAPinField.h",
            ],
            sources: [
                "Sources",
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        ),
    ]
)
