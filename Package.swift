// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Bota_Faladura_Pro_Max",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "Bota_Faladura_Pro_Max", targets: ["Bota_Faladura_Pro_Max"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Bota_Faladura_Pro_Max",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
