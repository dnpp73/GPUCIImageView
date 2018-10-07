import UIKit
import CoreImage
import MetalKit
import GLKit

// Metal 自体は iOS 8 からだが iOS 8 では MetalKit が使えないし、
// iPhone 4s と iPhone 5 と iPad 4th と iPad mini 1st ではそもそも Metal を使えない。
// https://developer.apple.com/library/content/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/HardwareGPUInformation/HardwareGPUInformation.html

// A7 以降は Metal & OpenGL ES 3.0 compatible
// A7 以降の iPod Touch (6th) 以外は OpenGL ES 2.0 も compatible
// A6 以前は OpenGL ES 2.0 compatible
// http://qiita.com/shu223/items/8027201e50c68288f0be

// MTKView に雑な感じで CIImage を放り込んで contentMode もそれっぽくするには
// 自前で transform 計算しないとダメっぽそう
// Advanced Image Processing with Core Image
// Simon Gladman on Jun 9 2016
// https://realm.io/news/tryswift-gladman-simon-advanced-core-image/

// Metal のことにサラっと触れてる
// What's New in Core Image (WWDC 2015 - Session 510)
// https://developer.apple.com/videos/play/wwdc2015/510/

public final class GPUCIImageView: UIView, CIImageShowable {

    public var image: CIImage? {
        didSet {
            if Thread.isMainThread {
                setNeedsLayout()
            } else {
                DispatchQueue.main.sync {
                    setNeedsLayout()
                }
            }
        }
    }

    public private(set) var ciContext: CIContext?

    private var gpuView: UIView?
    private var gpuViewDelegate: NSObject? // swiftlint:disable:this weak_delegate

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        if isMetalAvailable {
            guard #available(iOS 9.0, *) else {
                return
            }
            guard let m = prepareMetal() else {
                return
            }
            addSubview(m.mtkView)
            ciContext = m.ciContext
            gpuView = m.mtkView
            gpuViewDelegate = m.mtkViewDelegate
        } else {
            guard let g = prepareOpenGL() else {
                return
            }
            addSubview(g.glkView)
            ciContext = g.ciContext
            gpuView = g.glkView
            gpuViewDelegate = g.glkViewDelegate
        }
    }

    public override var contentMode: UIView.ContentMode {
        didSet {
            setNeedsLayout()
        }
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if let _ = window {
            setNeedsLayout()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = gpuView {
            imageView.bounds = CGRect(origin: .zero, size: imageViewSize)
            imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
            imageView.setNeedsDisplay()
        }
    }

}
