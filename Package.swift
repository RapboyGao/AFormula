// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AFormula",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AFormula",
            targets: ["AFormula"]),
    ],
    dependencies: [
        .package(url: "https://github.com/RapboyGao/AValue.git", branch: "main"),
        .package(url: "https://github.com/RapboyGao/AFunction.git", branch: "main"),
        .package(url: "https://github.com/RapboyGao/AUnit.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AFormula",
            dependencies: [
                .product(name: "AValue", package: "AValue"),
                .product(name: "AFunction", package: "AFunction"),
                .product(name: "AUnit", package: "AUnit"),
            ]),
        .testTarget(
            name: "AFormulaTests",
            dependencies: ["AFormula"]),
    ])
