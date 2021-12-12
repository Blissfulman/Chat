//
//  AsyncHandlerMock.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 09.12.2021.
//

@testable import Chat
import Foundation

final class AsyncHandlerMock: AsyncHandler {
    
    // Т.к. это mock, то тут можно сделать синхронную обработку задачи
    func handle(task: @escaping () -> Void) {
        task()
    }
}
