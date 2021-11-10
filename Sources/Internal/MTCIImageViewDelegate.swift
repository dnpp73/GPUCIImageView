import Foundation
import MetalKit

internal final class MTCIImageViewDelegate: NSObject, MTKViewDelegate {

    internal weak var parent: CIImageShowable?
    internal var commandQueue: MTLCommandQueue?

    private var drawableSize = CGSize.zero

    private let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()

    internal func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        drawableSize = size
    }

    internal func draw(in view: MTKView) {
        guard let ciContext = parent?.ciContext else {
            view.isHidden = true
            return
        }
        if let image = parent?.image /* , let scale = view.window?.screen.scale */ {
            guard let currentDrawable: CAMetalDrawable = view.currentDrawable else {
                print("[MTCIImageViewDelegate.draw(in view: MTKView)] view.currentDrawable is nil")
                view.isHidden = true
                return
            }
            /*
            guard let commandBuffer: MTLCommandBuffer = commandQueue?.makeCommandBufferWithUnretainedReferences() else {
                print("[MTCIImageViewDelegate.draw(in view: MTKView)] commandQueue?.makeCommandBufferWithUnretainedReferences() is nil")
                view.isHidden = true
                return
            }
             */
            guard let commandBuffer: MTLCommandBuffer = commandQueue?.makeCommandBuffer() else {
                print("[MTCIImageViewDelegate.draw(in view: MTKView)] commandQueue?.makeCommandBuffer() is nil")
                view.isHidden = true
                return
            }

            view.isHidden = false

            let colorSpace: CGColorSpace = image.colorSpace ?? self.colorSpace

            // drawableSizeWillChange で、きちんと拾えば同じ値になる。
            // let rect = view.bounds.applying(CGAffineTransform(scaleX: scale, y: scale)) // ここの scale は nativeScale じゃなくて良いっぽい。
            // let rect = CGRect(origin: .zero, size: drawableSize)
            // どうやら contentMode 的なのをキチンと表示するには自前で揃えてあげないといけない模様。
            let originX = -image.extent.origin.x
            let originY = -image.extent.origin.y
            let scaleX = drawableSize.width / image.extent.width
            let scaleY = drawableSize.height / image.extent.height
            let transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY).translatedBy(x: originX, y: originY)
            #if targetEnvironment(simulator)
            // シミュレータでのみ上下が反転してしまうのでしょうがない
            let transformedImage = image.transformed(by: transform)
            let scaledImage = transformedImage.transformed(by: CGAffineTransform(scaleX: 1.0, y: -1.0)).transformed(by: CGAffineTransform(translationX: 0.0, y: transformedImage.extent.height))
            #else
            let scaledImage = image.transformed(by: transform)
            #endif
            let rect = CGRect(origin: .zero, size: drawableSize)
            ciContext.render(scaledImage, to: currentDrawable.texture, commandBuffer: commandBuffer, bounds: rect, colorSpace: colorSpace)

            commandBuffer.present(currentDrawable)
            commandBuffer.commit()
            if parent?.waitUntilCompleted ?? true {
                commandBuffer.waitUntilCompleted()
            }
        } else {
            view.isHidden = true
        }
    }

}
