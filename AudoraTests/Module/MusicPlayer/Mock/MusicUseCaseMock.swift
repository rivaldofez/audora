//
//  MusicUseCaseMock.swift
//  AudoraTests
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation
import Combine
@testable import Audora


final class MusicUseCaseMock: MusicUseCaseProtocol {
    let musicRemoteMock: MusicRemoteMock
    
    init(musicRemoteMock: MusicRemoteMock) {
        self.musicRemoteMock = musicRemoteMock
    }
    
    func getMusicList(query: String) -> AnyPublisher<Audora.MusicResponse?, Audora.NetworkError> {
        return musicRemoteMock.getMusicList(query: query)
    }
}

