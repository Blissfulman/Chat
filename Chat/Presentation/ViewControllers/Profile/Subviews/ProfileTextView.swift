//
//  ProfileTextView.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 19.10.2021.
//

final class ProfileTextView: UITextView {
    
    // MARK: - Override properties
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            layer.borderColor = isUserInteractionEnabled ? Palette.textViewBorderGray?.cgColor : UIColor.clear.cgColor
        }
    }
    
    // MARK: - Private properties
    
    private var placeholder: String?
    private var isShownPlaceholder = false
    
    // MARK: - Initialization
    
    convenience init(frame: CGRect = .zero, withPlaceholder placeholder: String?) {
        self.init(frame: frame, textContainer: nil)
        self.placeholder = placeholder
        if placeholder != nil {
            showPlaceholder()
            delegate = self
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        prepareForAutoLayout()
        font = Fonts.body
        isScrollEnabled = false
        textAlignment = .center
        setCornerRadius(5)
        layer.borderWidth = 0.5
    }
    
    private func showPlaceholder() {
        text = placeholder
        textColor = Palette.placeholderTextColor
        isShownPlaceholder = true
    }
    
    private func hidePlaceholder() {
        text = ""
        textColor = .black
        isShownPlaceholder = false
    }
}

// MARK: - UITextViewDelegate

extension ProfileTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isShownPlaceholder {
            hidePlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            showPlaceholder()
        }
    }
}
