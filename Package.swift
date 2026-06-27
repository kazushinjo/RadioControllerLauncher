// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RadioControllerLauncher",
    platforms: [.macOS(.v14)],
    products: [.executable(name: "RadioControllerLauncher", targets: ["RadioControllerLauncher"])],
    targets: [
        .executableTarget(name: "RadioControllerLauncher", path: "Sources"),
        .testTarget(name: "RadioControllerLauncherTests", dependencies: ["RadioControllerLauncher"], path: "Tests")
    ]
)
