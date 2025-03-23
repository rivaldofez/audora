//
//  MusicResponse.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation

struct MusicResponse: Codable {
    let resultCount: Int?
    let results: [MusicItemResponse]?
}

struct MusicItemResponse: Codable, Hashable {
    let artistID, collectionID: Int?
    let collectionName, artistName: String?
    let artworkUrl100: String?
    let previewURL: String?
    let trackName: String?

    enum CodingKeys: String, CodingKey {
        case artistID = "artistId"
        case collectionID = "collectionId"
        case collectionName, artistName
        case artworkUrl100
        case previewURL = "previewUrl"
        case trackName
    }
}
