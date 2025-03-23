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

        bindListener()
    }
    
    func getMusicList(query: String) {
        let resultQuery = query.isEmpty ? "bruno mars" : query
        call(argument: musicUseCase.getMusicList(query: resultQuery)) { [weak self] data in
            self?.musicList = data?.results ?? []
        }
    }
    
    private func bindListener() {
        $searchQuery
        .debounce(for: .seconds(0.5), scheduler: WorkScheduler.mainScheduler)
        .removeDuplicates()
        .sink { [weak self] newValue in
            self?.getMusicList(query: newValue)
        }
        .store(in: &cancellables)
    }
    
    func onTapNextTrack() {
        guard let currentIndex = musicList.firstIndex(where: { $0 == selectedMusic }) else {
            if !musicList.isEmpty {
                selectMusic(selectedMusic: musicList[0])
            }
            return
        }
        
        if currentIndex < musicList.count - 1 {
            selectMusic(selectedMusic: musicList[currentIndex + 1])
        }
    }
    
    func onTapPrevTrack() {
        guard let currentIndex = musicList.firstIndex(where: { $0 == selectedMusic }) else {
            if !musicList.isEmpty {
                selectMusic(selectedMusic: musicList[0])
            }
            return
        }
        
        if currentIndex > 0 {
            selectMusic(selectedMusic: musicList[currentIndex - 1])
        }
    }
    
    func onTapPlayTrack(state: Bool) {
        isPlayingMusic = state
    }
    
    func selectMusic(selectedMusic: MusicItemResponse) {
        self.selectedMusic = selectedMusic
        playerViewModel.setupPlayer(url: selectedMusic.previewURL ?? "")
        
    }
}

