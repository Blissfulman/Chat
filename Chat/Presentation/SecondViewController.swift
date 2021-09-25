//
//  SecondViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.09.2021.
//

import UIKit

final class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
}
