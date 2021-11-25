//
//  String+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 25.11.2021.
//

import Foundation

extension String {
    
    /// Преобразует символы кириллицы для корректного создания URL запросов.
    func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}
