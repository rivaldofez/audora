//
//  RequestBuilder.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import Foundation

protocol RequestBuilder: NetworkTarget {
    init(request: NetworkTarget)
    var pathAppendedURL: URL { get }
    func setQuery(to urlRequest: inout URLRequest)
    func encodedBody() -> Data?
    func buildURLRequest() -> URLRequest
}
