// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let serverFoundationVapor: Self = "ServerFoundationVapor"
    static let serverFoundationVaporTesting: Self = "ServerFoundationVaporTestSupport"
}

extension Target.Dependency {
    static var serverFoundationVapor: Self { .target(name: .serverFoundationVapor) }
    static var serverFoundationVaporTesting: Self { .target(name: .serverFoundationVaporTesting) }
}

extension Target.Dependency {
    static var serverFoundation: Self { .product(name: "ServerFoundation", package: "swift-server-foundation") }
    static var favicon: Self { .product(name: "Favicon", package: "swift-favicon") }
    static var vapor: Self { .product(name: "Vapor", package: "vapor") }
    static var vaporRouting: Self { .product(name: "VaporRouting", package: "vapor-routing") }
    static var vaporTesting: Self { .product(name: "VaporTesting", package: "vapor") }
}

let package = Package(
    name: "swift-server-foundation-vapor",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .serverFoundationVapor, targets: [.serverFoundationVapor]),
        .library(name: .serverFoundationVaporTesting, targets: [.serverFoundationVaporTesting])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-favicon", from: "0.1.0"),
        .package(url: "https://github.com/coenttb/swift-server-foundation.git", from: "0.1.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing.git", from: "0.1.3"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.102.1")
    ],
    targets: [
        .target(
            name: .serverFoundationVapor,
            dependencies: [
                .serverFoundation,
                .vapor,
                .vaporRouting,
                .favicon
            ]
        ),
        .target(
            name: .serverFoundationVaporTesting,
            dependencies: [
                .serverFoundationVapor,
                .vaporTesting
            ]
        ),
        .testTarget(
            name: "ServerFoundationVaporTests",
            dependencies: [
                .serverFoundationVapor,
                .serverFoundationVaporTesting,
                .vaporTesting
            ]
        )

    ],
    swiftLanguageModes: [.v6]
)
