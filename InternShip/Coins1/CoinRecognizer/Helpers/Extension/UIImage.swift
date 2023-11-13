

import UIKit

extension UIImage {
    func resizedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / size.height
        let newWidth = size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func cropToCenter() -> UIImage? {
        let resizeImg = self.cropImageToSquare()
        guard let cgImage = resizeImg.cgImage else { return nil }
        
        let width = CGFloat(220)
        let height = CGFloat(220)
        let xOffset = (resizeImg.size.width - width) / 2.0
        let yOffset = (resizeImg.size.height - height) / 2.0 - 20
        let cropRect = CGRect(x: xOffset, y: yOffset, width: width , height: height)
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        
        let croppedImage = UIImage(
            cgImage: croppedCGImage,
            scale: resizeImg.scale,
            orientation: resizeImg.imageOrientation
        )
        return croppedImage
    }
    
    func cropImageToSquare() -> UIImage {
        var imageHeight = self.size.height
        var imageWidth = self.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let refWidth = CGFloat(self.cgImage!.width)
        let refHeight = CGFloat(self.cgImage!.height)

        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2

        let cropRect = CGRectMake(x, y, size.height, size.width)
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            let image = UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
            return image.resizedToHeight(500)
        }
       return UIImage()
    }
    
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
