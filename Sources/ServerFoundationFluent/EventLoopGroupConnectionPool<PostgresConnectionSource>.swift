//
//  EventLoopGroupConnectionPoolKey.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import Dependencies
@preconcurrency import PostgresKit

extension DependencyValues {
    public var eventLoopGroupConnectionPool: EventLoopGroupConnectionPool<PostgresConnectionSource> {
        get { self[EventLoopGroupConnectionPool<PostgresConnectionSource>.self] }
        set { self[EventLoopGroupConnectionPool<PostgresConnectionSource>.self] = newValue }
    }
}

extension EventLoopGroupConnectionPool<PostgresConnectionSource>: @retroactive TestDependencyKey {
    public static var testValue: EventLoopGroupConnectionPool<PostgresConnectionSource> { .default }
}

extension EventLoopGroupConnectionPool<PostgresConnectionSource> {
    public static var `default`: Self {
        @Dependency(\.sqlConfiguration) var sqlConfiguration
        @Dependency(\.mainEventLoopGroup) var mainEventLoopGroup

        return .init(
            source: PostgresConnectionSource(sqlConfiguration: sqlConfiguration),
            on: mainEventLoopGroup
        )
    }
}
