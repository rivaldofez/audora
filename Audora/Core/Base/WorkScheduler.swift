//
//  Scheduler.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import Foundation

final class WorkScheduler {

    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main
    static let mainThread = DispatchQueue.main
}
