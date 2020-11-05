import UIKit
import CoreImage
import GLKit

public final class GLCIImageView: UIView, CIImageShowable {

    public var image: CIImage? {
        didSet {
            onMainThreadAsync {
                self.setNeedsLayout()
            }
        }
    }

    public private(set) var ciContext: CIContext?

    private var glkView: GLKView?
    private var glkViewDelegate: GLCIImageViewDelegate? // swiftlint:disable:this weak_delegate

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        guard let g = prepareOpenGL() else {
            return
        }
        addSubview(g.glkView)
        ciContext = g.ciContext
        glkView = g.glkView
        glkViewDelegate = g.glkViewDelegate
    }

    public override var isOpaque: Bool {
        didSet {
            glkView?.isOpaque = isOpaque
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
        if let glkView = glkView {
            glkView.bounds = CGRect(origin: .zero, size: imageViewSize)
            glkView.center = CGPoint(x: bounds.midX, y: bounds.midY)
            glkView.setNeedsDisplay()
        }
    }

}
