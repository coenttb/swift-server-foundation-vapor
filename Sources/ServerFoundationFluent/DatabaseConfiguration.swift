//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import Dependencies
import Foundation
import NIO

public struct DatabaseConfiguration: Sendable {
    public var maxConnectionsPerEventLoop: Int
    public var connectionPoolTimeout: TimeAmount

    public init(
        maxConnectionsPerEventLoop: Int,
        connectionPoolTimeout: TimeAmount
    ) {
        self.maxConnectionsPerEventLoop = maxConnectionsPerEventLoop
        self.connectionPoolTimeout = connectionPoolTimeout
    }
}

extension DependencyValues {
    public var databaseConfiguration: DatabaseConfiguration {
        get { self[DatabaseConfiguration.self] }
        set { self[DatabaseConfiguration.self] = newValue }
    }
}

extension DatabaseConfiguration: TestDependencyKey {
    public static var testValue: Self { .default }
}

extension DatabaseConfiguration {
    public static var `default`: DatabaseConfiguration {
        DatabaseConfiguration(
            maxConnectionsPerEventLoop: 1,
            connectionPoolTimeout: .seconds(10)
        )
    }
}
