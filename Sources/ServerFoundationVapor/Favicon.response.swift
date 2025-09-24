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

        // First, check for in-memory data (programmatic icons)
        if let data = favicon.data(for: route) {
            return Response(
                status: .ok,
                headers: [
                    "Content-Type": favicon.contentType(for: route),
                    "Cache-Control": "public, max-age=31536000, immutable" // 1 year, immutable
                ],
                body: .init(data: data)
            )
        }

        // Fallback to file system
        let filePath = mapRouteToFilePath(route)
        let fullPath = request.application.directory.publicDirectory + filePath

        guard FileManager.default.fileExists(atPath: fullPath) else {
            throw Abort(.notFound)
        }

        // Stream the file with appropriate headers
        let response = try await request.fileio.asyncStreamFile(at: fullPath)
        response.headers.add(name: "Cache-Control", value: "public, max-age=31536000, immutable")
        return response
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
