//
//  MusicUseCase.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation
import Combine

protocol MusicUseCaseProtocol: AnyObject {
    func getMusicList(query: String) -> AnyPublisher<MusicResponse?, NetworkError>
}

final class MusicUseCase: MusicUseCaseProtocol {
    private let musicRemote: MusicRemoteProtocol
    
    init(musicRemote: MusicRemoteProtocol = DIContainer.shared.inject(type: MusicRemoteProtocol.self)) {
        self.musicRemote = musicRemote
    }
    
    func getMusicList(query: String) -> AnyPublisher<MusicResponse?, NetworkError> {
        return self.musicRemote.getMusicList(query: query)
    }
}
