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
    case dismissError
    case gotError(title: String)
}

protocol BaseViewModelEventSource: AnyObject {
    var loadingState: CurrentValueSubject<ViewModelStatus, Never> { get }
}

protocol ViewModelService: AnyObject {
    func call<ReturnType>(callWithIndicator: Bool,
                          argument: AnyPublisher<ReturnType?,
                          NetworkError>,
                          callback: @escaping (_ data: ReturnType?) -> Void)
}

typealias BaseViewModel = BaseViewModelEventSource & ViewModelService

open class DefaultViewModel: BaseViewModel, ObservableObject {
    
    var loadingState = CurrentValueSubject<ViewModelStatus, Never>(.dismissError)
    var cancellables = Set<AnyCancellable>()
    
    func call<ReturnType>(
        callWithIndicator: Bool = true,
        argument: AnyPublisher<ReturnType, NetworkError>,
        callback: @escaping (_ data: ReturnType) -> Void
    ) {
        if callWithIndicator {
            self.loadingState.send(.loading)
        }
        
        argument
            .subscribe(on: WorkScheduler.backgroundWorkScheduler)
            .receive(on: WorkScheduler.mainScheduler)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.loadingState.send(.dismissError)
                        self?.loadingState.send(.gotError(title: error.localizedDescription))
                    case .finished:
                        self?.loadingState.send(.dismissError)
                    }
                },
                receiveValue: { data in
                    callback(data)
                }
            )
            .store(in: &cancellables)
    }
}
