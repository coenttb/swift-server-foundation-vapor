# swift-server-foundation-vapor

A comprehensive Swift package that bridges **ServerFoundation** with **Vapor**, providing essential server-side components for modern Swift web applications. This package extends ServerFoundation with Vapor-specific implementations, Fluent database integration, and testing utilities.

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

- [**Boiler**](https://github.com/coenttb/boiler) - A minimal Swift web framework for building type-safe servers

## Feedback is Much Appreciated!
  
If you're working on your own Swift server project, feel free to learn, fork, and contribute.

Got thoughts? Found something you love? Something you hate? Let me know! Your feedback helps make this project better for everyone. Open an issue or start a discussion—I'm all ears.

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Link on Linkedin](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

This project is licensed under the **Apache 2.0 License**. See the [LICENSE](LICENSE).
