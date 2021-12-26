//
//  ImagePickerModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

enum ImagePickerModel {
    
    enum SetupTheme {
        struct Request {}
        struct Response {
            let theme: Theme
        }
        struct ViewModel {
            let theme: Theme
        }
    }
    
    struct FetchImages {
        struct Request {
            let query: String
        }
        struct Response {}
        struct ViewModel {}
    }
    
    struct FetchMoreImages {
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
