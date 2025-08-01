//
//  File.swift
//  coenttb-server-vapor
//
//  Created by Coen ten Thije Boonkkamp on 18/02/2025.
//

import Fluent
import Foundation
import PostgresKit
import ServerFoundation

extension DatabaseConfigurationFactory {
    public static var postgres: Self {
        @Dependency(\.sqlConfiguration) var sqlConfiguration
        @Dependency(\.databaseConfiguration) var databaseConfiguration

        return .postgres(
            configuration: sqlConfiguration,
            maxConnectionsPerEventLoop: databaseConfiguration.maxConnectionsPerEventLoop,
            connectionPoolTimeout: databaseConfiguration.connectionPoolTimeout
        )
    }
}
