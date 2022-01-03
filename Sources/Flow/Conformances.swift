extension Array: Flowable {}
extension Dictionary: Flowable {}
extension Set: Flowable {}
extension String: Flowable {}
extension Int: Flowable {}
extension Double: Flowable {}
extension Float: Flowable {}

// MARK: Foundation

import Foundation

extension NSObject: Flowable {}
extension Date: Flowable {}
#if !os(Linux)
    extension CGPoint: Flowable {}
    extension CGRect: Flowable {}
    extension CGSize: Flowable {}
    extension CGVector: Flowable {}
#endif

// MARK: UIKit

#if os(iOS) || os(tvOS)
    import UIKit.UIGeometry
    extension UIEdgeInsets: Flowable {}
    extension UIOffset: Flowable {}
    extension UIRectEdge: Flowable {}
#endif
