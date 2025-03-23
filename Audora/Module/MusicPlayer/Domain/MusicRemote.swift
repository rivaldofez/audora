//
//  MusicTarget.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation
import Combine
import Alamofire

protocol MusicRemoteProtocol: AnyObject {
    func getMusicList(query: String) -> AnyPublisher<MusicResponse?, NetworkError>
}

final class MusicRemote: NetworkClientManager<HttpRequest>, MusicRemoteProtocol {
    func getMusicList(query: String) -> AnyPublisher<MusicResponse?, NetworkError> {
        self.request(request: .init(request: MusicTarget.getMusicList(query: query)), scheduler: WorkScheduler.mainScheduler, responseObject: MusicResponse?.self)
    }
}

enum MusicTarget {
    case getMusicList(query: String)
}

extension MusicTarget: NetworkTarget {
    var baseURL: BaseURLType {
        return .production
    }
    
    var version: VersionType {
        return .none
    }
    
    var path: String? {
        return "search"
    }
    
    var methodType: HTTPMethod {
        .get
    }
    
    var queryParams: [String: String]? {
        switch self {
        case .getMusicList(let query):
            return ["term": query]
        }
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
