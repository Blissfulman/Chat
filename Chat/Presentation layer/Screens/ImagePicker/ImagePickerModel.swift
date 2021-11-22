//
//  ImagePickerModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

enum ImagePickerModel {
    
    struct PickImage {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let imageData: Data?
        }
        struct ViewModel {}
    }
}
