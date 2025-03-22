//
//  CustomError.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import Foundation

enum NetworkError: Error {
    case general
    case timeout
    case notFound
    case noData
    case noNetwork
    case unknownError
    case serverError
    case redirection
    case clientError
    case invalidResponse(httpStatusCode: Int)
    case statusMessage(message: String)
    case decodingError(Error)
    case connectionError(Error)
    case unauthorizedClient
    case urlError(URLError)
    case httpError(HTTPURLResponse)
    case type(Error)
}
