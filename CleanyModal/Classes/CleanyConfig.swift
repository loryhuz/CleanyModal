//
//  CleanyConfig.swift
//  CleanyModal
//
//  Created by Lory Huz on 21/03/2018.
//

import UIKit

public struct CleanyAlertConfig { }

public extension CleanyAlertConfig {
    
    static func getDefaultStyleSettings() -> StyleSettings {
        let styleSettings = StyleSettings()
        
        styleSettings.set(key: .cornerRadius, value: 15)
        styleSettings.set(key: .actionCellHeight, value: 60)
        
        styleSettings.set(key: .tintColor, value: .blue)
        styleSettings.set(key: .textColor, value: .black)
        styleSettings.set(key: .destructiveColor, value: .red)
        styleSettings.set(key: .separatorColor, value: UIColor.black.withAlphaComponent(0.08))
        styleSettings.set(key: .backgroundColor, value: UIColor.white)
        
        if #available(iOS 13.0, *) {
            #if swift(>=5.0)
            styleSettings.set(key: .textColor, value: .label)
            styleSettings.set(key: .defaultActionColor, value: .label)
            styleSettings.set(key: .destructiveColor, value: .systemRed)
            styleSettings.set(key: .tintColor, value: .systemBlue)
            styleSettings.set(key: .separatorColor, value: UIColor.label.withAlphaComponent(0.08))
            styleSettings.set(key: .backgroundColor, value: UIColor.systemBackgroundElevated)
            #endif
        }
        
        return styleSettings
    }
    
    class StyleSettings {
        
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
    
    class StyleKeys: Hashable {
        let key: String
        public init(_ key: String) { self.key = key }
        public static func == (lhs: StyleKeys, rhs: StyleKeys) -> Bool { return lhs.key == rhs.key }
        public func hash(into hasher: inout Hasher) { hasher.combine(key) }
    }
    
    class StyleKey<ValueType>: CleanyAlertConfig.StyleKeys { }
    
}

public extension CleanyAlertConfig.StyleKeys {
    
    static let tintColor = CleanyAlertConfig.StyleKey<UIColor>("tintColor")
    static let cornerRadius = CleanyAlertConfig.StyleKey<CGFloat>("cornerRadius")
    
    static let textColor = CleanyAlertConfig.StyleKey<UIColor>("textColor")
    static let defaultActionColor = CleanyAlertConfig.StyleKey<UIColor>("defaultActionColor")
    static let destructiveColor = CleanyAlertConfig.StyleKey<UIColor>("destructiveColor")
    
    static let actionCellHeight = CleanyAlertConfig.StyleKey<CGFloat>("actionCellHeight")
    
    static let titleFont = CleanyAlertConfig.StyleKey<UIFont>("titleFont")
    static let messageFont = CleanyAlertConfig.StyleKey<UIFont>("messageFont")
    static let actionsFont = CleanyAlertConfig.StyleKey<UIFont>("actionsFont")
    
    static let backgroundColor = CleanyAlertConfig.StyleKey<UIColor>("backgroundColor")
    static let separatorColor = CleanyAlertConfig.StyleKey<UIColor>("separatorColor")
}
