//
//  Bundle+Extension.swift
//  CleanyModal
//
//  Created by Afnan Mirza on 5/14/22.
//

import Foundation

extension Bundle {
    static var current: Bundle? {
        #if SWIFT_PACKAGE
        return .module
        #else
        Bundle(for: CleanyAlertViewController.self)
        #endif
    }
}
