//
//  MusicResponseMock.swift
//  AudoraTests
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation
@testable import Audora

struct MusicResponseMock {
    static let resultsResponse: [Audora.MusicItemResponse] = {
        var result: [Audora.MusicItemResponse] = []
        for i in 0..<10 {
            result.append(.init(
                artistID: i,
                collectionID: i,
                collectionName: "Collection Name-\(i)",
                artistName: "Collection Artis Name-\(i)",
                artworkUrl100: "Artwork 100-\(i)",
                previewURL: "Preview URL-\(i)",
                trackName: "Track Name-\(i)"))
        }
        
        return result
    }()

    static let response = Audora.MusicResponse(resultCount: 10, results: resultsResponse)
}


