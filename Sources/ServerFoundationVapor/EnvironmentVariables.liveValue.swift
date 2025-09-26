//
//  File.swift
//  swift-server-foundation
//
//  Created by Coen ten Thije Boonkkamp on 01/08/2025.
//

import EnvironmentVariables
import Foundation
import Vapor

//extension EnvironmentVariables: @retroactive DependencyKey {
//    public static var liveValue: EnvironmentVariables {
//        @Dependency(\.projectRoot) var projectRoot
//        let environment = try? Vapor.Environment.detect()
//        return try! .live(
//            environmentConfiguration: .projectRoot(projectRoot, environment: environment?.name)
//        )
//    }
//}


extension EnvironmentVariables {
    public static func live()-> EnvironmentVariables {
        @Dependency(\.projectRoot) var projectRoot
        let environment = try? Vapor.Environment.detect()
        return try! .live(
            environmentConfiguration: .projectRoot(projectRoot, environment: environment?.name)
        )
    }
}
