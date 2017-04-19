import Foundation
import GLKit

internal final class GLCIImageViewDelegate: NSObject, GLKViewDelegate {
    
    internal weak var parent: CIImageShowable?
    
    internal func glkView(_ view: GLKView, drawIn rect: CGRect) {
        if let image = parent?.image, let scale = view.window?.screen.nativeScale {
            view.isHidden = false
            let rect = view.bounds.applying(CGAffineTransform(scaleX: scale, y: scale)) // ここの scale は nativeScale で取らないとダメっぽい。
            parent?.ciContext?.draw(image, in: rect, from: image.extent)
        } else {
            view.isHidden = true
        }
    }
    
}
