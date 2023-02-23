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
        .package(url: "https://github.com/tyagishi/SDSViewExtension", .upToNextMajor(from: "4.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SDSCalendarViews",
            dependencies: ["SDSViewExtension", "SwiftLintXcode"]),
        // 1. Specify where to download the compiled swiftlint tool from.
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/juozasvalancius/SwiftLint/releases/download/spm-accommodation/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "cdc36c26225fba80efc3ac2e67c2e3c3f54937145869ea5dbcaa234e57fc3724"
        ),
        // 2. Define the SPM plugin.
        .plugin(
            name: "SwiftLintXcode",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        // 3. Use the plugin in your project.
//        .executableTarget(
//            name: "SDSCalendarViews",
//            plugins: ["SwiftLintXcode"]
//        )
    ]
)
