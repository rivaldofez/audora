//
//  MusicPlayerViewModelTests.swift
//  AudoraTests
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation
import XCTest
import Combine
@testable import Audora

final class MusicPlayerViewModelTests: XCTestCase {

    private var viewModelToTest: MusicPlayerViewModel!
    private var musicUseCase: MusicUseCaseMock!
    private var musicRemote: MusicRemoteMock!
    private var subscriber : Set<AnyCancellable> = []
    
    override func setUp()  {
        musicRemote = MusicRemoteMock()
        musicUseCase = MusicUseCaseMock(musicRemoteMock: musicRemote)
        viewModelToTest = MusicPlayerViewModel(musicUseCase: musicUseCase)
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        viewModelToTest = nil
        musicRemote = nil
        super.tearDown()
    }
    
    func testMainViewModel_WhenGetMusicList_ShouldReturnResponse() {
        //Arrange
        let data = MusicResponseMock.response
        let expectation = XCTestExpectation(description: "Result")

        musicRemote.getMusicResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMusicList(query: "test")
             
        viewModelToTest.$musicList
            .dropFirst()
            .sinkOnMain { result in
                XCTAssertEqual(result.count, data.results?.count ?? -1)
                XCTAssertEqual(result.first, data.results?.first)
                XCTAssertEqual(result.last, data.results?.last)
                expectation.fulfill()
            }.store(in: &subscriber)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenGetMusicList_ShouldReturnNil() {
        let data: Audora.MusicResponse? = nil
        let expectation = XCTestExpectation(description: "Result")

        musicRemote.getMusicResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMusicList(query: "test")
             
        viewModelToTest.$musicList
            .dropFirst()
            .sinkOnMain { result in
                XCTAssertEqual(result.count, 0)
                XCTAssertEqual(result.first, nil)
                XCTAssertEqual(result.last, nil)
                expectation.fulfill()
            }.store(in: &subscriber)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenSelectMusic_ShouldSuccess() {
        //Arrange
        let data = MusicResponseMock.response
        let expectation = XCTestExpectation(description: "Result")

        musicRemote.getMusicResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMusicList(query: "test")
             
        XCTAssertEqual(self.viewModelToTest.selectedMusic, nil)
        viewModelToTest.$musicList
            .dropFirst()
            .sinkOnMain { result in
                self.viewModelToTest.selectMusic(selectedMusic: result.first!)
                XCTAssertEqual(self.viewModelToTest.selectedMusic, result.first)
                expectation.fulfill()
            }.store(in: &subscriber)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenTapNextMusic_ShouldSuccess() {
        //Arrange
        let data = MusicResponseMock.response
        let expectation = XCTestExpectation(description: "Result")

        musicRemote.getMusicResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMusicList(query: "test")
             
        XCTAssertEqual(self.viewModelToTest.selectedMusic, nil)
        viewModelToTest.$musicList
            .dropFirst()
            .sinkOnMain { result in
                self.viewModelToTest.selectMusic(selectedMusic: result.first!)
                XCTAssertEqual(self.viewModelToTest.selectedMusic, result.first)
                self.viewModelToTest.onTapNextTrack()
                XCTAssertEqual(self.viewModelToTest.selectedMusic, result[1])
                
                expectation.fulfill()
            }.store(in: &subscriber)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenTapPrevMusic_ShouldSuccess() {
        let data = MusicResponseMock.response
        let expectation = XCTestExpectation(description: "Result")

        musicRemote.getMusicResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMusicList(query: "test")
             
        XCTAssertEqual(self.viewModelToTest.selectedMusic, nil)
        viewModelToTest.$musicList
            .dropFirst()
            .sinkOnMain { result in
                self.viewModelToTest.selectMusic(selectedMusic: result[2])
                XCTAssertEqual(self.viewModelToTest.selectedMusic, result[2])
                self.viewModelToTest.onTapPrevTrack()
                XCTAssertEqual(self.viewModelToTest.selectedMusic, result[1])
                
                expectation.fulfill()
            }.store(in: &subscriber)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenTapPlayMusic_ShouldSuccess() {
        let data = MusicResponseMock.response
        let expectation = XCTestExpectation(description: "Result")

        musicRemote.getMusicResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMusicList(query: "test")
             
        XCTAssertFalse(self.viewModelToTest.isPlayingMusic)
        viewModelToTest.$musicList
            .dropFirst()
            .sinkOnMain { result in
                self.viewModelToTest.selectMusic(selectedMusic: result[0])
                self.viewModelToTest.onTapPlayTrack(state: true)
                XCTAssertTrue(self.viewModelToTest.isPlayingMusic)
                expectation.fulfill()
            }.store(in: &subscriber)
        
        self.wait(for: [expectation], timeout: 1)
    }
}

//func onTapNextTrack() {
//    guard let currentIndex = musicList.firstIndex(where: { $0 == selectedMusic }) else {
//        if !musicList.isEmpty {
//            selectMusic(selectedMusic: musicList[0])
//        }
//        return
//    }
//    
//    if currentIndex < musicList.count - 1 {
//        selectMusic(selectedMusic: musicList[currentIndex + 1])
//    }
//}
//
//func onTapPrevTrack() {
//    guard let currentIndex = musicList.firstIndex(where: { $0 == selectedMusic }) else {
//        if !musicList.isEmpty {
//            selectMusic(selectedMusic: musicList[0])
//        }
//        return
//    }
//    
//    if currentIndex > 0 {
//        selectMusic(selectedMusic: musicList[currentIndex - 1])
//    }
//}
//
//func onTapPlayTrack(state: Bool) {
//    isPlayingMusic = state
//}
//
//func selectMusic(selectedMusic: MusicItemResponse) {
//    self.selectedMusic = selectedMusic
//    playerViewModel.setupPlayer(url: selectedMusic.previewURL ?? "")
//    
//}
