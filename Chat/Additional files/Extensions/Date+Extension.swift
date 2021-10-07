//
//  Date+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 08.10.2021.
//

import Foundation

extension Date {
    
    /// Получение даты в текстовом формате, используемой в ячейке беседы.
    func conversationCellDate() -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.doesRelativeDateFormatting = true
        relativeDateFormatter.dateStyle = .short
        relativeDateFormatter.timeStyle = .none
        
        let absoluteDateFormatter = DateFormatter()
        absoluteDateFormatter.dateStyle = .short
        absoluteDateFormatter.timeStyle = .none
        
        let relativeDate = relativeDateFormatter.string(from: self)
        let absoluteDate = absoluteDateFormatter.string(from: self)
        
        if (relativeDate == absoluteDate) {
            absoluteDateFormatter.dateFormat = "d/MM/yyyy"
            return absoluteDateFormatter.string(from: self)
        } else {
            return relativeDate
        }
    }
    
    /// Получение даты в текстовом формате, используемой в ячейке сообщения.
    func messageCellDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
