//
//  RequestTimingMiddleware.swift
//  coenttb-server-vapor
//
//  Created by Coen ten Thije Boonkkamp on 23/07/2025.
//

import ServerFoundation
import Vapor
import Logging
import Foundation
import NIOCore

extension HTTPHeaders.Name {
    static let requestID = HTTPHeaders.Name("request-id")
}

extension Vapor.Middlewares {
    public struct RequestTiming: AsyncMiddleware {
        private let skipStaticFileDetection: Bool
        
        public init(skipStaticFileDetection: Bool = false) {
            self.skipStaticFileDetection = skipStaticFileDetection
        }

        public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
            let start = NIODeadline.now()
            
            let response = try await next.respond(to: request)
            
            let elapsedMs = Int((NIODeadline.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000)
            let requestID = request.headers.first(name: .requestID) ?? "-"
            
            // Check if this is likely a static file based on response headers
            let isStaticFile = skipStaticFileDetection ? false :
                isLikelyStaticFile(request: request, response: response)
            
            let level = logLevel(for: response.status, isStaticFile: isStaticFile)
            
            request.logger.log(
                level: level,
                "\(response.status.code) | \(elapsedMs)ms | \(request.method.rawValue) \(request.url.path)",
                metadata: [
                    "request_id": .string(requestID),
                    "elapsed_ms": .stringConvertible(elapsedMs),
                    "static_file": .stringConvertible(isStaticFile)
                ]
            )
            
            return response
        }
        
        private func isLikelyStaticFile(request: Request, response: Response) -> Bool {
            // Use response characteristics instead of file system checks
            guard request.method == .GET || request.method == .HEAD else { return false }
            guard response.status == .ok || response.status == .notModified else { return false }
            
            // Check content-type for common static file types
            if let contentType = response.headers.contentType {
                let staticTypes = ["image/", "text/css", "application/javascript",
                                 "font/", "video/", "audio/"]
                return staticTypes.contains { contentType.serialize().starts(with: $0) }
            }
            
            // Check file extension as fallback
            let path = request.url.path
            let staticExtensions = [".css", ".js", ".jpg", ".jpeg", ".png", ".gif",
                                  ".svg", ".ico", ".woff", ".woff2", ".ttf"]
            return staticExtensions.contains { path.hasSuffix($0) }
        }
        
        private func logLevel(for status: HTTPStatus, isStaticFile: Bool) -> Logger.Level {
            switch status.code {
            case 500...: return .error
            case 400..<500: return .warning
            case 304: return .debug  // Not Modified
            default:
                return isStaticFile ? .debug : .info
            }
        }
    }
}
