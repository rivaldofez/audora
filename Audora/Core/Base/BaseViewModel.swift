//
//  BaseViewModel.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import Foundation
import Combine
import SwiftUI

enum ViewModelStatus: Equatable {
    case loading
    case finish
    case success
    case error(title: String)
}

protocol BaseViewModelEventSource: AnyObject {
    var viewState: CurrentValueSubject<ViewModelStatus, Never> { get }
}

protocol ViewModelService: AnyObject {
    func call<ReturnType>(callWithIndicator: Bool,
                          argument: AnyPublisher<ReturnType?,
                          NetworkError>,
                          callback: @escaping (_ data: ReturnType?) -> Void)
}

typealias BaseViewModel = BaseViewModelEventSource & ViewModelService

open class DefaultViewModel: BaseViewModel, ObservableObject {
    
    var viewState = CurrentValueSubject<ViewModelStatus, Never>(.finish)
    var cancellables = Set<AnyCancellable>()
    
    func call<ReturnType>(
        callWithIndicator: Bool = true,
        argument: AnyPublisher<ReturnType, NetworkError>,
        callback: @escaping (_ data: ReturnType) -> Void
    ) {
        if callWithIndicator {
            self.viewState.send(.loading)
        }
        
        argument
            .subscribe(on: WorkScheduler.backgroundWorkScheduler)
            .receive(on: WorkScheduler.mainScheduler)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.viewState.send(.error(title: error.localizedDescription))
                        break
                    case .finished:
                        break
                    }
                },
                receiveValue: { data in
                    callback(data)
                    self.viewState.send(.success)
                }
            )
            .store(in: &cancellables)
    }
}
