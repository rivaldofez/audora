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
    
    @Published private var musicData: MusicResponse?
    @Published var searchQuery: String = ""
    @Published var playerViewModel: PlayerViewModel!
    @Published var musicList: [MusicItemResponse]
    @Published var isPlayingMusic: Bool = false
    @Published var selectedMusic: MusicItemResponse?
    
    
    init(musicUseCase: MusicUseCaseProtocol = DIContainer.shared.inject(type: MusicUseCaseProtocol.self)) {
        self.musicUseCase = musicUseCase
        self.musicList = []
        super.init()
        self.playerViewModel = PlayerViewModel(
            onTapNextTrack: { [weak self] in self?.onTapNextTrack() },
            onTapPrevTrack: { [weak self] in self?.onTapPrevTrack() },
            onTapPlayTrack: { [weak self] in self?.onTapPlayTrack(state: $0) }
        )
        
        getMusicList(query: "die with a smile")
    }
    
    func getMusicList(query: String) {
        call(argument: musicUseCase.getMusicList(query: query)) { [weak self] data in
            self?.musicList = data?.results ?? []
        }
    }
    
    func searchMusic(query: String) {
        
    }
    
    func onTapNextTrack() {

    }
    
    func onTapPrevTrack() {

    }
    
    func onTapPlayTrack(state: Bool) {
        isPlayingMusic = state
    }
    
    func selectMusic(selectedMusic: MusicItemResponse) {
        self.selectedMusic = selectedMusic
        playerViewModel.setupPlayer(url: selectedMusic.previewURL ?? "")
        
    }
}

