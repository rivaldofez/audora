//
//  Configuration.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import Foundation

enum BaseURLType {
    case production
    case staging

    var value: URL {
        switch self {
        case .production:
            guard let url = URL(string: "https://itunes.apple.com/") else { fatalError("Invalid URL")}
            return url
        case .staging:
            guard let url = URL(string: "https://itunes.apple.com/") else { fatalError("Invalid URL")}
            return url
        }
    }
}

enum VersionType {
    case none
    var value: String {
        switch self {
        case .none:
            return ""
        }
    }
}
