#if canImport(UIKit)

import UIKit
import CoreImage

public final class CPUCIImageView: UIView, CIImageShowable {

    public var image: CIImage? {
        didSet {
            if let image = image {
                DispatchQueue.global(qos: .userInteractive).async {
                    let uiImage = UIImage(ciImage: image)
                    DispatchQueue.main.async {
                        self.imageView?.image = uiImage
                        self.setNeedsLayout()
                    }
                }
            } else {
                onMainThreadSync {
                    imageView?.image = nil
                    setNeedsLayout()
                }
            }
        }
    }

    public private(set) var ciContext: CIContext?

    public var waitUntilCompleted = true

    private var imageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let imageView = prepareCPU()
        addSubview(imageView)
        ciContext = nil
        self.imageView = imageView
    }

    override public var isOpaque: Bool {
        didSet {
            imageView?.isOpaque = isOpaque
        }
    }

    override public var contentMode: UIView.ContentMode {
        didSet {
            setNeedsLayout()
        }
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        if let _ = window {
            setNeedsLayout()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            imageView.bounds = CGRect(origin: .zero, size: imageViewSize)
            imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
            imageView.setNeedsDisplay()
        }
    }

}

#endif
