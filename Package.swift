// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnergyPackage",
	platforms: [
		.macOS(.v12), .iOS(.v15)
	],
    products: [
		.library(
            name: "EnergyPackage",
            targets: ["EnergyPackage"]),
    ],
	dependencies: [
		.package(url: "https://github.com/sroebert/mqtt-nio", exact: .init(2, 8, 1)),
		.package(url: "https://github.com/influxdata/influxdb-client-swift", exact: .init(1, 6, 0))
	],
    targets: [
        .target(
            name: "EnergyPackage"),
        .testTarget(
            name: "EnergyPackageTests",
            dependencies: ["EnergyPackage"]),
    ]
)
