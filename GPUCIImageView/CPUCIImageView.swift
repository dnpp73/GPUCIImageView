import UIKit
import CoreImage

public final class CPUCIImageView: UIView, CIImageShowable {

    public var image: CIImage? {
        didSet {
            onMainThreadSync {
                if let image = image {
                    imageView?.image = UIImage(ciImage: image)
                } else {
                    imageView?.image = nil
                }
                setNeedsLayout()
            }
        }
    }

    public private(set) var ciContext: CIContext?

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
        if let imageView = imageView {
            imageView.bounds = CGRect(origin: .zero, size: imageViewSize)
            imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
            imageView.setNeedsDisplay()
        }
    }

}
