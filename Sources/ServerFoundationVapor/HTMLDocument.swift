//
//  HTMLDocument.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 27/05/2022.
//

// import PointFreeHTML
// import Vapor
//
// extension HTMLDocument: @retroactive AsyncResponseEncodable {
//    public func encodeResponse(for request: Request) async throws -> Vapor.Response {
//        var headers = HTTPHeaders()
//        headers.add(name: .contentType, value: "text/html")
//        return .init(status: .ok, headers: headers, body: .init(data: Data(self.render())))
//    }
// }

// Cannot extend protocol with inheritence clause. The conforming type should declare AsyncResponseEncodable.
// extension HTMLDocument: AsyncResponseEncodable {}
