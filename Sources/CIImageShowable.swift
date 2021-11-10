import Foundation
import CoreImage

public protocol CIImageShowable: AnyObject {
    var image: CIImage? { get set }
    var ciContext: CIContext? { get }
    var waitUntilCompleted: Bool { get set }
}
