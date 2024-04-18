// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASN1Decoder",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ASN1Decoder",
            targets: ["ASN1Decoder"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ASN1Decoder",
            path: "ASN1Decoder",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("")
            ]
),
        .testTarget(
            name: "ASN1DecoderTests",
            dependencies: ["ASN1Decoder"]
        ),
    ]
)
