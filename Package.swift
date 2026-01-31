// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

var swiftFlags = [
    "-whole-module-optimization",
    "-Xfrontend", "-disable-objc-interop",
    "-Xfrontend", "-disable-stack-protector",
    "-Xfrontend", "-function-sections",
    "-Xcc", "-DTARGET_EXTENSION",
]

#if RELEASE
    swiftFlags.append(contentsOf: ["-Xfrontend", "-gline-tables-only"])
#endif

let package = Package(
    name: "Renzo",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Renzo", targets: ["Renzo"])
    ],
    dependencies: [
        .package(url: "https://source.marquiskurt.net/PDUniverse/PlaydateKit.git", branch: "main"),
        .package(url: "https://source.marquiskurt.net/PDUniverse/PDKUtils.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Renzo",
            dependencies: [
                .product(name: "PlaydateKit", package: "PlaydateKit"),
                .product(name: "PDGraphics", package: "PDKUtils"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(swiftFlags),
            ],
        )
    ]
)
