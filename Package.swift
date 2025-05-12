// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "LiveTranscriber",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "LiveTranscriber", targets: ["LiveTranscriber"]),
    ],
    targets: [
        .target(
            name: "LiveTranscriber",
            dependencies: []
        ),
        .testTarget(
            name: "LiveTranscriberTests",
            dependencies: ["LiveTranscriber"]
        )
    ]
)
