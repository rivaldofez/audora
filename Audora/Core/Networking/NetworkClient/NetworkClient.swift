//
//  NetworkClient.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import Foundation
import Combine
import Alamofire

typealias BaseAPIProtocol = NetworkClientProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, NetworkError>

protocol NetworkClientProtocol: AnyObject {
    @available(iOS 13.0, *)
    @discardableResult
    func perform<M: Decodable, T>(with request: RequestBuilder,
                                  decoder: JSONDecoder,
                                  scheduler: T,
                                  responseObject type: M.Type) -> AnyPublisher<M, NetworkError> where M: Decodable, T: Scheduler
}

protocol Logging {
    func logRequest(request: URLRequest)
    func logResponse(response: URLResponse?, data: Data?)
}

final class NetworkClient: NetworkClientProtocol {
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
    
    let logging: Logging
    
    init(logging: Logging = NetworkDebugger()) {
        self.logging = logging
    }
    
    @discardableResult
    func perform<M, T>(with request: RequestBuilder,
                       decoder: JSONDecoder,
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisher<M, NetworkError> where M: Decodable, T: Scheduler {
        let urlRequest = request.buildURLRequest()
        self.logging.logRequest(request: urlRequest)
        
        if let reachability = NetworkReachabilityManager(), !reachability.isReachable {
            return Fail(error: NetworkError.noNetwork)
                .eraseToAnyPublisher()
        }
        
        return AF.request(urlRequest)
            .validate()
            .response(completionHandler: { response in
                self.logging.logResponse(response: response.response, data: response.data)
            })
            .publishDecodable(type: M.self)
            .value()
            .mapError { error in
                return NetworkError.alamofire(error)
            }
            .eraseToAnyPublisher()
    }
}

class NetworkClientManager<Target: RequestBuilder> {
    
    typealias AnyPublisherResult<M> = AnyPublisher<M, NetworkError>
    
    private let clientURLSession: NetworkClientProtocol
    
    public init(clientURLSession: NetworkClientProtocol = NetworkClient()) {
        self.clientURLSession = clientURLSession
    }
    
    func request<M, T>(request: Target,
                       decoder: JSONDecoder = .init(),
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisherResult<M> where M: Decodable, T: Scheduler {
        return clientURLSession.perform(with: request, decoder: decoder, scheduler: scheduler, responseObject: type)
    }
}
