// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDSCalendarViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SDSCalendarViews",
            targets: ["SDSCalendarViews"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/tyagishi/SDSViewExtension", from: "4.0.0"),
        .package(url: "https://github.com/tyagishi/SDSSwiftExtension", from: "2.1.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.56.1"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SDSCalendarViews",
            dependencies: ["SDSViewExtension", "SDSSwiftExtension"],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        )
    ]
)
