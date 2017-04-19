import UIKit
import GLKit
import MetalKit

internal extension CIImageShowable where Self: UIView {
    
    internal var imageViewSize: CGSize {
        guard let imageSize = image?.extent.size else {
            return bounds.size
        }
        let originalSize = bounds.size
        let ratio = imageSize.height / imageSize.width
        let aspectSize1 = CGSize(width: originalSize.width, height: originalSize.width * ratio)
        let aspectSize2 = CGSize(width: originalSize.height / ratio, height: originalSize.height)
        let minSize: CGSize
        let maxSize: CGSize
        let s1 = aspectSize1.width * aspectSize1.height
        let s2 = aspectSize2.width * aspectSize2.height
        if s1 < s2 {
            minSize = aspectSize1
            maxSize = aspectSize2
        } else {
            minSize = aspectSize2
            maxSize = aspectSize1
        }
        switch contentMode {
        case .scaleAspectFit:
            return minSize
        case .scaleAspectFill:
            return maxSize
        default:
            return originalSize
        }
    }
    
    internal func prepareOpenGL() -> (ciContext: CIContext, glkView: GLKView, glkViewDelegate: GLCIImageViewDelegate)? {
        let glContext: EAGLContext
        if let glContext3 = EAGLContext(api: .openGLES3) {
            glContext = glContext3
        } else if let glContext2 = EAGLContext(api: .openGLES2) {
            glContext = glContext2
        } else {
            print("[CIImageShowable.prepareOpenGL()] Can't create EAGLContext")
            return nil
        }
        glContext.isMultiThreaded = true
        let ciContext = CIContext(eaglContext: glContext, options: [kCIContextUseSoftwareRenderer : false])
        let glkView = GLKView(frame: bounds, context: glContext)
        let glkViewDelegate = GLCIImageViewDelegate()
        glkViewDelegate.parent = self
        glkView.delegate = glkViewDelegate
        glkView.clipsToBounds = true
        glkView.isUserInteractionEnabled = false
        return (ciContext: ciContext, glkView: glkView, glkViewDelegate: glkViewDelegate)
    }
    
    @available(iOS 9, *)
    internal func prepareMetal() -> (ciContext: CIContext, mtkView: MTKView, mtkViewDelegate: MTCIImageViewDelegate)? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("[CIImageShowable.prepareMetal()] MTLCreateSystemDefaultDevice failed")
            return nil
        }
        let ciContext = CIContext(mtlDevice: device)
        let mtkView = MTKView(frame: bounds, device: device)
        let mtkViewDelegate = MTCIImageViewDelegate()
        mtkViewDelegate.parent = self
        mtkViewDelegate.commandQueue = device.makeCommandQueue()
        mtkView.delegate = mtkViewDelegate
        mtkView.clipsToBounds = true
        mtkView.isUserInteractionEnabled = false
        mtkView.framebufferOnly = false
        mtkView.enableSetNeedsDisplay = true // default false UIImageView 的な感じで雑に CIimage を放り込む用途ならこれを true にしないと mtkView.isPaused を頑張って弄らないと draw が呼ばれまくってパフォーマンス出なくなる
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        return (ciContext: ciContext, mtkView: mtkView, mtkViewDelegate: mtkViewDelegate)
    }
    
}
