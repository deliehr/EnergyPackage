// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SolarPowerKit",
	platforms: [
		.macOS(.v12), .iOS(.v15)
	],
    products: [
		.library(
            name: "SolarPowerKit",
            targets: ["SolarPowerKit"]),
    ],
	dependencies: [
		.package(url: "https://github.com/sroebert/mqtt-nio", exact: .init(2, 8, 1)),
		.package(url: "https://github.com/influxdata/influxdb-client-swift", exact: .init(1, 6, 0))
	],
    targets: [
        .target(name: "SolarPowerKit", dependencies: [
			.product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
			.product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift"),
			.product(name: "MQTTNIO", package: "mqtt-nio"),
		]),
        .testTarget(
            name: "SolarPowerKitTests",
            dependencies: ["SolarPowerKit"]),
    ]
)
