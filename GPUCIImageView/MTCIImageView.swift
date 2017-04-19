import UIKit
import CoreImage
import MetalKit

@available(iOS 9, *)
public final class MTCIImageView: UIView, CIImageShowable {
    
    public var image: CIImage? {
        didSet {
            if Thread.isMainThread {
                setNeedsLayout()
            }  else {
                DispatchQueue.main.sync {
                    setNeedsLayout()
                }
            }
        }
    }
    
    public private(set) var ciContext: CIContext?
    
    private var mtkView: MTKView?
    private var mtkViewDelegate: MTCIImageViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let m = prepareMetal() else {
            return
        }
        addSubview(m.mtkView)
        ciContext = m.ciContext
        mtkView = m.mtkView
        mtkViewDelegate = m.mtkViewDelegate
    }
    
    public override var contentMode: UIViewContentMode {
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
        if let mtkView = mtkView {
            mtkView.bounds = CGRect(origin: .zero, size: imageViewSize)
            mtkView.center = CGPoint(x: bounds.midX, y: bounds.midY)
            mtkView.setNeedsDisplay()
        }
    }
    
}
