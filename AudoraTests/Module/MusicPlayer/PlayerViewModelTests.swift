//
//  PlayerViewModelTests.swift
//  AudoraTests
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import XCTest
import AVFoundation
@testable import Audora

class PlayerViewModelTests: XCTestCase {
    var viewModel: PlayerViewModel!
    
    override func setUp() {
        super.setUp()
        let url = URL(string: "https://www.example.com/audio.mp3")!
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        viewModel = PlayerViewModel(player: player)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    func waitUntilCurrentTimeIsValid() {
        let expectation = self.expectation(description: "Waiting for valid current time")
        DispatchQueue.global().async {
            while self.viewModel.player.currentTime().seconds.isNaN {
                usleep(100000)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    func testPlayerViewModel_InitialState() {
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertEqual(viewModel.currentTime, 0.0)
        XCTAssertEqual(viewModel.duration, 1.0)
        XCTAssertEqual(viewModel.volume, 0.5)
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testPlayerViewModel_TogglePlayPause() {
        viewModel.togglePlayPause()
        XCTAssertTrue(viewModel.isPlaying)
        
        viewModel.togglePlayPause()
        XCTAssertFalse(viewModel.isPlaying)
    }
    
    func testPlayerViewModel_SeekForward() {
        waitUntilCurrentTimeIsValid()
        let expectation = self.expectation(description: "Seek forward completes")
        let initialTime = viewModel.player.currentTime().seconds
        viewModel.seekForward()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newTime = self.viewModel.player.currentTime().seconds
            XCTAssertEqual(newTime, initialTime + 10, accuracy: 0.1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testPlayerViewModel_SeekBackward() {
        waitUntilCurrentTimeIsValid()
        let expectation = self.expectation(description: "Seek backward completes")
        viewModel.player.seek(to: CMTimeMakeWithSeconds(20, preferredTimescale: 1))
        viewModel.seekBackward()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newTime = self.viewModel.player.currentTime().seconds
            XCTAssertEqual(newTime, 10, accuracy: 0.1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testPlayerViewModel_SliderChanged() {
        waitUntilCurrentTimeIsValid()
        let expectation = self.expectation(description: "Slider change completes")
        viewModel.currentTime = 15.0
        viewModel.sliderChanged(editing: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newTime = self.viewModel.player.currentTime().seconds
            XCTAssertEqual(newTime, 15.0, accuracy: 0.1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testPlayerViewModel_FormatTime() {
        XCTAssertEqual(viewModel.formatTime(125), "02:05")
        XCTAssertEqual(viewModel.formatTime(59), "00:59")
        XCTAssertEqual(viewModel.formatTime(3600), "60:00")
    }
}
