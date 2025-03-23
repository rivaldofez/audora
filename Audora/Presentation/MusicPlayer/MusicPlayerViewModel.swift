//
//  MusicPlayerViewModel.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation

protocol DataFlowProtocol {
    associatedtype InputType
    func apply(_ input: InputType)
}

protocol MusicPlayerViewModelProtocol {
    func getMusicList(query: String)
}

final class MusicPlayerViewModel: DefaultViewModel, MusicPlayerViewModelProtocol {
    private let musicUseCase: MusicUseCaseProtocol
    
    init(musicUseCase: MusicUseCaseProtocol = DIContainer.shared.inject(type: MusicUseCaseProtocol.self)) {
        self.musicUseCase = musicUseCase
    }
    
    @Published private var musicData: MusicResponse?
    
    func getMusicList(query: String) {
        call(argument: musicUseCase.getMusicList(query: query)) { [weak self] data in
            self?.musicData = data
        }
    }
}

