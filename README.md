# swift-server-foundation-vapor

A comprehensive Swift package that bridges **ServerFoundation** with **Vapor**, providing essential server-side components for modern Swift web applications. This package extends ServerFoundation with Vapor-specific implementations, Fluent database integration, and testing utilities.

## 📦 What's Included

### ServerFoundationVapor
Core Vapor integration providing:
- **Application Extensions**: Enhanced Application functionality with mounting, execution, and Foundation integration
- **Middleware Stack**: Complete middleware suite including HTTPS redirect, host validation, rate limiting, and request timing
- **HTTP Utilities**: Extended Request/Response handling, cookies configuration, and HTML document support
- **Pipeline Components**: Streamlined request/response pipeline management
- **Environment Integration**: Seamless environment variables integration with Vapor

### ServerFoundationFluent
Database integration layer featuring:
- **Database Configuration**: Factory patterns for database setup and configuration
- **Schema Management**: Enhanced schema building utilities and field key management
- **PostgreSQL Integration**: Specialized PostgreSQL error handling and utilities
- **Database Keys**: Type-safe database key management

### ServerFoundationVaporTestSupport
Testing utilities including:
- **HTTP Testing**: Comprehensive HTTP request testing support
- **Vapor Test Integration**: Seamless integration with Vapor's testing framework

## 🚀 Installation

Add `swift-server-foundation-vapor` as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-server-foundation-vapor.git", from: "0.0.1")
]
```

Then add the specific targets you need:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "ServerFoundationVapor", package: "swift-server-foundation-vapor"),
            .product(name: "ServerFoundationFluent", package: "swift-server-foundation-vapor"), // Optional
            .product(name: "ServerFoundationVaporTestSupport", package: "swift-server-foundation-vapor"), // For testing
        ]
    )
]
```

## 💡 Usage

### Basic Vapor Integration

```swift
import ServerFoundationVapor
import Vapor

let app = Application()
defer { app.shutdown() }

// Mount your routes with ServerFoundation integration
app.mount { router in
    router.get("hello") { req in
        return "Hello, World!"
    }
}

try app.run()
```

### Database Integration with Fluent

```swift
import ServerFoundationFluent
import Fluent
import FluentPostgresDriver

// Configure database using ServerFoundation patterns
app.databases.use(
    DatabaseConfigurationFactory.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ),
    as: .psql
)
```

### Middleware Configuration

```swift
import ServerFoundationVapor

// Apply comprehensive middleware stack
app.middleware.use(HostValidationMiddleware(allowedHosts: ["example.com"]))
app.middleware.use(HTTPSRedirectMiddleware())
app.middleware.use(RateLimiter.Middleware())
app.middleware.use(RequestTimingMiddleware())
```

### Testing Support

```swift
import ServerFoundationVaporTestSupport
import XCTVapor

final class YourAppTests: XCTestCase {
    func testRoute() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        
        // Configure your app
        
        try app.test(.GET, "hello") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, World!")
        }
    }
}
```

## 🔧 Platform Requirements

- **macOS**: 14.0+
- **iOS**: 17.0+
- **Swift**: 6.0+

## 🌟 Key Dependencies

This package builds upon these excellent Swift server-side libraries:
- [**ServerFoundation**](https://github.com/coenttb/swift-server-foundation) - Core server foundation components
- [**Vapor**](https://github.com/vapor/vapor) - Swift web framework
- [**Fluent**](https://github.com/vapor/fluent) - Swift ORM framework
- [**VaporRouting**](https://github.com/pointfreeco/vapor-routing) - Type-safe routing for Vapor

## 🤝 Related Projects

- [**swift-server-foundation**](https://github.com/coenttb/swift-server-foundation) - Base server foundation
- [**swift-web-foundation**](https://github.com/coenttb/swift-web-foundation) - Web development foundation

## 📝 Feedback and Contribution

This package is part of the **coenttb** Swift ecosystem. Questions, feature requests, and contributions are welcome!

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.