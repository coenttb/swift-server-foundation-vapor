//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import Dependencies
import IssueReporting
@preconcurrency import PostgresKit

extension DependencyValues {
    public var sqlConfiguration: SQLPostgresConfiguration {
        get { self[SQLPostgresConfigurationKey.self] }
        set { self[SQLPostgresConfigurationKey.self] = newValue }
    }
}

public enum SQLPostgresConfigurationKey: TestDependencyKey {
    public static var testValue: SQLPostgresConfiguration {
        reportIssue(
          """
          You need to provide a custom SQLPostgresConfiguration.
          """,
          fileID: #fileID,
          filePath: #filePath,
          line: #line,
          column: #column
        )

        fatalError()
    }
}

