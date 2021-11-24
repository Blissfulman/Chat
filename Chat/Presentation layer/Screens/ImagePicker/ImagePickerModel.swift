//
//  ImagePickerModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

enum ImagePickerModel {
    
    struct FetchImages {
        struct Request {
            let indexPath: IndexPath
        }
    }
    
    struct PickImage {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
