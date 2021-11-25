//
//  ProfileModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

enum ProfileModel {
    
    enum FetchTheme {
        struct Request {}
        struct Response {
            let theme: Theme
        }
        struct ViewModel {
            let theme: Theme
        }
    }
    
    enum FetchProfile {
        struct Request {}
        struct Response {
            let fullName: String?
            let description: String?
            let avatarImageData: Data?
        }
        struct ViewModel {
            let fullName: String?
            let description: String?
            let avatarImageData: Data
        }
    }
    
    enum EditProfileButtonTapped {
        struct Request {
            let fullName: String?
            let description: String?
            let avatarImageData: Data?
        }
    }
    
    enum EditingAvatarAlert {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let title: String
        }
    }
    
    enum SavingProfileAlert {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    
    enum DidSelectNewAvatar {
        struct Request {}
    }
    
    enum TextFieldsEditingChanged {
        struct Request {
            let fullName: String?
            let description: String?
        }
    }
    
    enum RollbackCurrentViewData {
        struct Request {}
    }
    
    enum EditingState {
        struct Response {}
        struct ViewModel {}
    }
    
    enum SavedState {
        struct Response {}
        struct ViewModel {}
    }
    
    enum UpdateSaveButtonState {
        struct Response {
            let isEnabledButton: Bool
        }
        struct ViewModel {
            let isEnabledButton: Bool
        }
    }
    
    enum SaveProfile {
        struct Request {
            let fullName: String?
            let description: String?
            let avatarImageData: Data?
            let savingVariant: SavingVariant
        }
    }
    
    enum ShowProgressView {
        struct Response {}
        struct ViewModel {}
    }
    
    enum HideProgressView {
        struct Response {}
        struct ViewModel {}
    }
    
    enum ProfileSavedAlert {
        struct Response {}
        struct ViewModel {
            let title: String
        }
    }
    
    enum SavingProfileError {
        struct Response {
            let retryHandler: () -> Void
        }
        struct ViewModel {
            let title: String
            let message: String
            let retryHandler: () -> Void
        }
    }
    
    enum SavingVariant {
        case gcd
        case operations
    }
}
