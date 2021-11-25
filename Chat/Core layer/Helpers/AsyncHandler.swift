//
//  AsyncHandler.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

/// Асинхронный обработчик.
protocol AsyncHandler {
    func handle(task: @escaping () -> Void)
}

/// Асинхронный обработчик на основе GCD.
final class GCDAsyncHandler: AsyncHandler {
    
    // MARK: - Private propertios
    
    private let queue: DispatchQueue
    
    // MARK: - Initialization
    
    init(qos: DispatchQoS) {
        queue = DispatchQueue(label: "GCDBackgroundQueue", qos: qos)
    }
    
    // MARK: - Public methods
    
    func handle(task: @escaping () -> Void) {
        queue.async {
            task()
        }
    }
}

/// Асинхронный обработчик на основе Operations.
final class OperationsAsyncHandler: AsyncHandler {
    
    // MARK: - Nested types
    
    class AsyncOperation: Operation {
        
        private let task: () -> Void
        
        init(task: @escaping () -> Void, qos: QualityOfService) {
            self.task = task
            super.init()
            qualityOfService = qos
        }
        
        override func main() {
            task()
        }
    }
    
    // MARK: - Private propertios
    
    private let queue = OperationQueue()
    private let qos: QualityOfService
    
    // MARK: - Initialization
    
    init(qos: QualityOfService) {
        self.qos = qos
        queue.maxConcurrentOperationCount = 1
    }
    
    // MARK: - Public methods
    
    func handle(task: @escaping () -> Void) {
        let asyncOperation = AsyncOperation(task: task, qos: qos)
        queue.addOperation(asyncOperation)
    }
}
