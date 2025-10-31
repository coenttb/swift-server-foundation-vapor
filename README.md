# swift-server-foundation-vapor

[![CI](https://github.com/coenttb/swift-server-foundation-vapor/workflows/CI/badge.svg)](https://github.com/coenttb/swift-server-foundation-vapor/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A Swift package that bridges ServerFoundation with Vapor, providing Vapor-specific implementations and testing utilities.

## Overview

This package extends [swift-server-foundation](https://github.com/coenttb/swift-server-foundation) with Vapor-specific components, middleware, and testing support. It provides custom middleware for common server operations, HTTP header extensions, and utilities for testing Vapor applications.

## Features

- **Middleware Extensions**: Custom Vapor middleware implementations including:
  - Rate limiting middleware with throttling support
  - HTTPS redirecting middleware
  - Host validation middleware
  - Canonical URL redirecting middleware
  - Session management middleware
  - Request timing middleware
  - Closure-based middleware for inline request handling
- **HTTP Extensions**: Additional HTTP header names for rate limiting, security, and proxy headers
- **Environment Integration**: Live environment variables configuration with Vapor environment detection
- **Testing Support**: Utilities for testing Vapor applications with URLRouting integration
- **Favicon Response**: Built-in favicon serving capabilities

## Installation

Add `swift-server-foundation-vapor` as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-server-foundation-vapor.git", from: "0.1.0")
]
```

Then add the products to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "ServerFoundationVapor", package: "swift-server-foundation-vapor"),
            // For testing support:
            .product(name: "ServerFoundationVaporTestSupport", package: "swift-server-foundation-vapor"),
        ]
    )
]
```

## Quick Start

### Using Closure-Based Middleware

```swift
import ServerFoundationVapor

let app = Application()

app.middleware.use { request, next in
    print("Request received: \(request.url)")
    let response = try await next.respond(to: request)
    print("Response status: \(response.status)")
    return response
}
```

### Using Rate Limiting Middleware

```swift
import ServerFoundationVapor
import Throttling

let rateLimiter = RateLimiter<String>(
    windows: [.minutes(1, maxAttempts: 100)]
)

let middleware = RateLimiter.Middleware(
    rateLimiter: rateLimiter,
    getKey: { request in
        request.headers.first(name: .xRealIp) ?? "unknown"
    },
    onRejected: nil
)

app.middleware.use(middleware)
```

### Using Custom HTTP Headers

```swift
import ServerFoundationVapor

func handler(request: Request) async throws -> Response {
    let response = Response(status: .ok)

    // Add rate limit headers
    response.headers.add(name: .xRateLimitLimit, value: "100")
    response.headers.add(name: .xRateLimitRemaining, value: "95")

    // Add security headers
    response.headers.add(
        name: .strictTransportSecurity,
        value: "max-age=31536000; includeSubDomains"
    )

    return response
}
```

## Platform Requirements

- macOS 14.0+
- iOS 17.0+
- Swift 6.0+

## Related Packages

### Dependencies

- [swift-favicon](https://github.com/coenttb/swift-favicon): A Swift package for type-safe favicons.
- [swift-server-foundation](https://github.com/coenttb/swift-server-foundation): A Swift package with tools to simplify server development.

### Used By

- [coenttb-blog](https://github.com/coenttb/coenttb-blog): A Swift package for blog functionality with HTML generation.
- [coenttb-com-server](https://github.com/coenttb/coenttb-com-server): Production server for coenttb.com built with Boiler.
- [coenttb-newsletter](https://github.com/coenttb/coenttb-newsletter): A Swift package for newsletter subscription and email management.
- [coenttb-server](https://github.com/coenttb/coenttb-server): A Swift package for building fast, modern, and safe servers.
- [coenttb-server-vapor](https://github.com/coenttb/coenttb-server-vapor): A Swift package providing Vapor integration for coenttb-server.
- [coenttb-syndication](https://github.com/coenttb/coenttb-syndication): A Swift package for RSS and Atom feed generation.
- [swift-identities](https://github.com/coenttb/swift-identities): The Swift library for identity authentication and management.

### Third-Party Dependencies

- [pointfreeco/vapor-routing](https://github.com/pointfreeco/vapor-routing): A bidirectional Vapor router with more type safety and less fuss.
- [vapor/vapor](https://github.com/vapor/vapor): A server-side Swift HTTP web framework.

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.

## License

This project is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for details.
