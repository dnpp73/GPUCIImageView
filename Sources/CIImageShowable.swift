import UIKit
import CoreImage

public protocol CIImageShowable: AnyObject {
    var image: CIImage? { get set }
    var ciContext: CIContext? { get }
}
