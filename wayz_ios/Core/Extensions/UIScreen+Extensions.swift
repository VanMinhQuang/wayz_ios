//
//  UIScreen+Extensions.swift
//  wayz_ios
//

import SwiftUI

extension UIScreen {
    /// The current device screen width in points.
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }

    /// The current device screen height in points.
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }
}

extension CGFloat {
    /// Convenience for expressing a size as a fraction of the screen width.
    /// Usage: `0.8.screenWidth` → 80% of the screen width.
    var screenWidth: CGFloat {
        UIScreen.width * self
    }

    /// Convenience for expressing a size as a fraction of the screen height.
    /// Usage: `0.5.screenHeight` → 50% of the screen height.
    var screenHeight: CGFloat {
        UIScreen.height * self
    }
}
