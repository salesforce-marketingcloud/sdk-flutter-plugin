// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sfmc",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "sfmc", targets: ["sfmc"])
    ],
    dependencies: [
        // Resolves against the FlutterFramework package that the Flutter tool
        // (3.41+) generates next to the plugin symlink; only valid when built
        // through a Flutter app, not standalone.
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Lower bound is 9.0.2, not 9.0.0: MarketingCloudSDK-iOS 9.0.0/9.0.1 pin
        // sfmc-sdk-ios to exact 2.0.0 while 9.0.2+ pin exact 2.0.1, and mixing tags
        // with different exact pins in the candidate set trips a SwiftPM resolver
        // InternalError ("mutually exclusive and can't be intersected").
        .package(url: "https://github.com/salesforce-marketingcloud/MarketingCloudSDK-iOS", "9.0.2"..<"9.1.0"),
        .package(url: "https://github.com/salesforce-marketingcloud/sfmc-sdk-ios", "2.0.0"..<"3.0.0")
    ],
    targets: [
        .target(
            name: "sfmc",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "MarketingCloudSDK", package: "MarketingCloudSDK-iOS"),
                .product(name: "SFMCSDK", package: "sfmc-sdk-ios")
            ],
            cSettings: [
                .headerSearchPath("include/sfmc")
            ]
        )
    ]
)
