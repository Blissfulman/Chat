//
//  BackgroundHandler.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

protocol BackgroundHandler {
    func handle(task: @escaping () -> Void) -> Void
}

final class GCDBackgroundHandler: BackgroundHandler {
    
    // MARK: - Public methods
    
    func handle(task: @escaping () -> Void) {
        let queue = DispatchQueue.global()
        queue.async {
            task()
        }
    }
}

final class OperationsBackgroundHandler: BackgroundHandler {
    
    // MARK: - Nested types
    
    class BackgroundOperation: Operation {
        
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
    
    // MARK: - Public methods
    
    func handle(task: @escaping () -> Void) {
        let queue = OperationQueue()
        let backgroundOperation = BackgroundOperation(task: task, qos: .background)
        queue.addOperation(backgroundOperation)
    }
}
