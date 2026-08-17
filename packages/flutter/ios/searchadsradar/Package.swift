// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "searchadsradar",
    platforms: [.iOS("16.0")],
    products: [
        .library(name: "searchadsradar", targets: ["searchadsradar"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "searchadsradar",
            dependencies: [],
            resources: [.process("PrivacyInfo.xcprivacy")]
        )
    ]
)
