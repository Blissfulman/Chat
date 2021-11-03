//
//  Data+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

extension Data {
    
    func resizeImageFromImageData(to size: CGSize?) -> Data {
        guard
            let size = size,
            let image = UIImage(data: self)
        else {
            return Data()
        }
        return UIGraphicsImageRenderer(size: size).jpegData(withCompressionQuality: 0.5) { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
