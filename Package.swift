// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

var swiftFlags = [
    "-whole-module-optimization",
    "-Xfrontend", "-disable-objc-interop",
    "-Xfrontend", "-disable-stack-protector",
    "-Xfrontend", "-function-sections",
    "-Xcc", "-DTARGET_EXTENSION"
]

#if RELEASE
swiftFlags.append(contentsOf: ["-Xfrontend", "-gline-tables-only"])
#endif

let package = Package(
    name: "Renzo",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Renzo",
            targets: ["Renzo"]
        ),
    ],
    dependencies: [
        .package(url: "https://source.marquiskurt.net/PDUniverse/PlaydateKit.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Renzo",
            dependencies: [
                .product(name: "PlaydateKit", package: "PlaydateKit")
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(swiftFlags),
            ],
        )
    ]
)