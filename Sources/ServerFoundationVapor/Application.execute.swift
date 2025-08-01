//
//  Application.main.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2024.
//

import ServerFoundation
import Vapor

extension Vapor.Application.Foundation {
    public static func execute<R: Parser & Sendable>(
        router: R,
        use response: @escaping @Sendable (R.Output) async throws -> any AsyncResponseEncodable,
        configure: @Sendable (Vapor.Application) async throws -> Void = { _ in }
    ) async throws where R.Input == URLRequestData {

        try await Vapor.Application.Foundation.execute(
            configure: { application in
                application.mount(router, use: response)
                try await configure(application)
            }
        )
    }
}

extension Vapor.Application.Foundation {
    public static func execute(
        use response: @escaping @Sendable () async throws -> any AsyncResponseEncodable,
        configure: @Sendable (Vapor.Application) async throws -> Void = { _ in }
    ) async throws {

        struct VoidParser: Parser {
            func parse(_ input: inout URLRouting.URLRequestData) throws {()}
        }

        try await Vapor.Application.Foundation.execute(
            configure: { application in
                application.mount(VoidParser(), use: { _ in try await response() })
                try await configure(application)
            }
        )
    }
}

extension Vapor.Application.Foundation {
    public static func execute(
        configure: @Sendable (Vapor.Application) async throws -> Void = { _ in }
    ) async throws {

        let environment: Environment = try .detect()

        do {
            @Dependency(\.mainEventLoopGroup) var mainEventLoopGroup

            let application = try await Vapor.Application.make(environment, .shared(mainEventLoopGroup))
            defer { Task { try? await application.asyncShutdown() } }

            prepareDependencies {
                $0.logger.logLevel = $0.envVars.logLevel ?? .info
            }

            @Dependency(\.logger) var logger

            logger.info("Application starting with environment: \(environment)")

            do {

                @Dependency(\.envVars.port) var port
                application.http.server.configuration.port = port

                application.middleware = .init()

                @Dependency(\.envVars.allowedInsecureHosts) var allowedInsecureHosts
                @Dependency(\.envVars.canonicalHost) var canonicalHost
                @Dependency(\.envVars.baseUrl) var baseUrl

                if let allowedInsecureHosts = allowedInsecureHosts, !allowedInsecureHosts.isEmpty {
                    application.middleware.use(
                        HostValidationMiddleware(
                            allowedHosts: allowedInsecureHosts,
                            logger: logger
                        )
                    )
                }

                if let canonicalHost = canonicalHost {
                    application.middleware.use(
                        CanonicalRedirectMiddleware(
                            canonicalHost: canonicalHost,
                            baseUrl: baseUrl,
                            logger: logger
                        )
                    )
                }

                application.middleware.use { request, next in
                    return try await withDependencies {
                        $0.request = request
                    } operation: {
                        try await next.respond(to: request)
                    }
                }

                application.middleware.use(FileMiddleware(publicDirectory: application.directory.publicDirectory))

                try await configure(application)

                @Dependency(\.envVars.httpsRedirect) var httpsRedirect
                application.middleware.use(HTTPSRedirectMiddleware(on: httpsRedirect == true), at: .beginning)
                if let corsMiddlewareConfiguration = application.foundation.corsMiddlewareConfiguration {
                    application.middleware.use(CORSMiddleware(configuration: corsMiddlewareConfiguration), at: .beginning)
                }
                application.middleware.use(ErrorMiddleware.default(environment: application.environment), at: .beginning)
                application.middleware.use(RequestTimingMiddleware(), at: .beginning)

                prepareDependencies {
                    application.logger = $0.logger
                    $0.application = application
                }

                try await application.execute()
            } catch {
                logger.critical("Application failed to start: \(error.localizedDescription)")
                throw error
            }

        } catch {
            @Dependency(\.logger) var logger
            logger.critical("Critical failure: \(error.localizedDescription)")
            throw error
        }
    }
}
