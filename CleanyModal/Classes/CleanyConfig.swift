//
//  CleanyConfig.swift
//  CleanyModal
//
//  Created by Lory Huz on 21/03/2018.
//

import UIKit

public struct CleanyAlertConfig {
    
    public let title: String?
    public let message: String?
    public let icon: UIImage?
    
    public var styleSettings = StyleSettings()
    
    public init(
        title: String?,
        message: String?,
        iconImgName: String? = nil) {
        
        self.title = title
        self.message = message
        
        if iconImgName != nil {
            self.icon = UIImage(named: iconImgName!)
        } else {
            self.icon = nil
        }
        
        applyDefaultStyleSettings()
    }
    
    private func applyDefaultStyleSettings() {
        styleSettings.set(key: .cornerRadius, value: 15)
        styleSettings.set(key: .actionCellHeight, value: 60)
        styleSettings.set(key: .textColor, value: .black)
        styleSettings.set(key: .destructiveColor, value: .red)
    }
}

public extension CleanyAlertConfig {
    
    public class StyleSettings {
        
        fileprivate var values = [String: Any]()
        
        public subscript<T>(_ key: CleanyAlertConfig.StyleKey<T>) -> T? {
            get {
                return get(key: key)
            }
            set {
                set(key: key, value: newValue)
            }
        }
        
        fileprivate func get<T>(key: CleanyAlertConfig.StyleKey<T>) -> T? {
            return values[key.key] as? T
        }
        
        fileprivate func set<T>(key: CleanyAlertConfig.StyleKey<T>, value: T?) {
            values[key.key] = value
        }
    }
    
    public class StyleKeys: Hashable {
        let key: String
        public init(_ key: String) { self.key = key }
        public static func == (lhs: StyleKeys, rhs: StyleKeys) -> Bool { return lhs.key == rhs.key }
        public var hashValue: Int { return key.hashValue }
    }
    
    public class StyleKey<ValueType>: CleanyAlertConfig.StyleKeys { }
    
}

public extension CleanyAlertConfig.StyleKeys {
    
    public static let tintColor = CleanyAlertConfig.StyleKey<UIColor>("tintColor")
    public static let cornerRadius = CleanyAlertConfig.StyleKey<CGFloat>("cornerRadius")
    
    public static let textColor = CleanyAlertConfig.StyleKey<UIColor>("textColor")
    public static let defaultActionColor = CleanyAlertConfig.StyleKey<UIColor>("defaultActionColor")
    public static let destructiveColor = CleanyAlertConfig.StyleKey<UIColor>("destructiveColor")
    
    public static let actionCellHeight = CleanyAlertConfig.StyleKey<CGFloat>("actionCellHeight")
    
    public static let titleFont = CleanyAlertConfig.StyleKey<UIFont>("titleFont")
    public static let messageFont = CleanyAlertConfig.StyleKey<UIFont>("messageFont")
    public static let actionsFont = CleanyAlertConfig.StyleKey<UIFont>("actionsFont")
    
}
