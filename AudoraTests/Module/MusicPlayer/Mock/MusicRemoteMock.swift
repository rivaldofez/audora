//
//  MusicRemoteMock.swift
//  AudoraTests
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation
import Alamofire
import Combine
@testable import Audora

enum MusicTargetMock {
    case getMusicList(query: String)
}

extension MusicTargetMock: NetworkTarget {
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
    
    var queryParamsEncoding: Audora.URLEncoding? {
        return .default
    }
}

final class MusicRemoteMock: Audora.MusicRemoteProtocol {
    var getMusicResult: AnyPublisher<Audora.MusicResponse?,Audora.NetworkError>!
    func getMusicList(query: String) -> AnyPublisher<Audora.MusicResponse?, Audora.NetworkError> {
        return getMusicResult
    }
}
