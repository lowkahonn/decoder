// swift-tools-version:5.3
import PackageDescription
let package = Package(
    name: "decoder",
    products: [
        .executable(name: "decoder", targets: ["decoder"])
    ],
    dependencies: [
        .package(name: "JavaScriptKit", url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.13.0")
    ],
    targets: [
        .target(
            name: "decoder",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]),
        .testTarget(
            name: "decoderTests",
            dependencies: ["decoder"]),
    ]
)