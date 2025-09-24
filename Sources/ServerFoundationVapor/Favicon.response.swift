//
//  File.swift
//  swift-server-foundation-vapor
//
//  Created by Coen ten Thije Boonkkamp on 24/09/2025.
//

import Vapor
@_exported import Favicon
import URLRouting
import Dependencies
import Foundation

extension Favicon {
    public static func response(
        route: Favicon.Route
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.request) var request
        @Dependency(\.favicon) var favicon

        guard let request else { throw Abort(.internalServerError) }

        // Map the route to a file path
        let filePath = mapRouteToFilePath(route)
        let fullPath = request.application.directory.publicDirectory + filePath

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: fullPath) else {
            // For favicon data stored in memory, return generated data
            if let data = favicon.data(for: route) {
                let contentType = favicon.contentType(for: route)
                return Response(
                    status: .ok,
                    headers: [
                        "Content-Type": contentType,
                        "Cache-Control": "public, max-age=31536000" // 1 year
                    ],
                    body: .init(data: data)
                )
            }
            throw Abort(.notFound)
        }

        // Stream the file
        return try await request.fileio.asyncStreamFile(at: fullPath)
    }

    private static func mapRouteToFilePath(_ route: Favicon.Route) -> String {
        switch route {
        case .favicon:
            return "favicons/favicon.ico"
        case .icon(let format):
            switch format {
            case .png(let size):
                switch size.width {
                case 16:
                    return "favicons/favicon-16x16.png"
                case 32:
                    return "favicons/favicon-32x32.png"
                case 192:
                    return "favicons/favicon-192x192.png"
                case 512:
                    return "favicons/favicon.png"
                default:
                    return "favicons/favicon.png"
                }
            case .svg:
                return "favicons/favicon.svg"
            }
        case .appleTouchIcon:
            return "favicons/apple-touch-icon.png"
        case .appleTouchIconPrecomposed:
            return "favicons/apple-touch-icon.png"
        }
    }
}
