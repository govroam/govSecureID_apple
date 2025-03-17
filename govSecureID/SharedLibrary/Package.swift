// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedLibrary",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MainModule",
            targets: ["MainModule"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Tiqr/tiqr-app-core-ios", revision: "34d63500ebbe4d810a29a6dc1f76e59ce853d5fd")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        // MainModule
        .target(
            name: "MainModule",
            dependencies: [
                "Theme",
                .product(name: "Tiqr", package: "tiqr-app-core-ios")]
        ),
        .target(
            name: "Theme",
            dependencies: [
                .product(name: "Tiqr", package: "tiqr-app-core-ios")]
        )
    ]
)
