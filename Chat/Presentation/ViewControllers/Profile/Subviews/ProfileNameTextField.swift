//
//  ProfileNameTextField.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

final class ProfileNameTextField: UITextField {
    
    // MARK: - Override properties
    
    override var isEnabled: Bool {
        didSet {
            layer.borderColor = isEnabled ? Palette.textViewBorderGray?.cgColor : UIColor.clear.cgColor
        }
    }
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        prepareForAutoLayout()
        font = Fonts.subTitle
        textAlignment = .center
        setCornerRadius(5)
        layer.borderWidth = 0.5
    }
}
