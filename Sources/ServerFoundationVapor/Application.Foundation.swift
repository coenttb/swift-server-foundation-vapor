//
//  File.swift
//  swift-server-foundation-vapor
//
//  Created by Coen ten Thije Boonkkamp on 31/07/2025.
//

import Foundation
import Vapor

extension Application {
    public struct Foundation: StorageKey & Sendable {
        public typealias Value = Application.Foundation

        var corsMiddlewareConfiguration: CORSMiddleware.Configuration?
    }
}

extension Application.Foundation {
    static let `default`: Self = .init(
        corsMiddlewareConfiguration: .default()
    )
}

extension Vapor.Application {
    var foundation: Application.Foundation {
        get {
            self.storage[Application.Foundation.self] ?? .default
        }
        set {
            self.storage[Application.Foundation.self] = newValue
        }
    }
}
