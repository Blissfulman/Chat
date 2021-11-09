//
//  ChannelListModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import Foundation

enum ChannelListModel {
    
    enum FetchProfile {
        struct Request {}
    }
    
    enum FetchingChannelsError {
        struct Response {
            let error: Error
        }
        struct ViewModel {
            let title: String
            let message: String
        }
    }
    
    enum UpdateProfile {
        struct Request {
            let profile: Profile
        }
        struct Response {
            let avatarImageData: Data?
            let senderName: String?
        }
        struct ViewModel {
            let avatarImageData: Data
        }
    }
    
    enum ChannelList {
        struct Request {}
    }
    
    enum AddChannelAlert {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let title: String
        }
    }
    
    enum NewChannel {
        struct Request {
            let channelName: String
        }
    }
    
    enum UpdateTheme {
        struct Request {
            let theme: Theme
        }
    }
    
    enum OpenChannel {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let channel: Channel
            let senderName: String?
        }
        struct ViewModel {
            let route: Route.ChannelScreen
        }
    }
    
    enum DeleteChannel {
        struct Request {
            let indexPath: IndexPath
        }
    }
    
    // MARK: - Routing
    
    enum Route {
        struct SettingsScreen {
            let didChooseThemeHandler: ((Theme) -> Void)
        }
        
        struct ProfileScreen {
            let didChangeProfileHandler: ((Profile) -> Void)
        }
        
        struct ChannelScreen {
            let channel: Channel
            let senderName: String
        }
    }
}
