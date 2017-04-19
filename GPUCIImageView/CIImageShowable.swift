import UIKit
import CoreImage

public protocol CIImageShowable: class {
    var image: CIImage? { get set }
    var ciContext: CIContext? { get }
}
