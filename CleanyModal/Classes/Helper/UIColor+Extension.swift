//
//  UIColor+Extension.swift
//  CleanyModal
//
//  Created by Lory Huz on 06/01/2021.
//

import UIKit

extension UIColor {
    @nonobjc class var systemBackgroundElevated: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    // simulate elevated systemBackground color
                    // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode
                    return UIColor(red: 28/255, green: 28/255, blue: 31/255, alpha: 1)
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }
}
