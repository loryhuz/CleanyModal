//
//  CleanyConfig.swift
//  CleanyModal
//
//  Created by Lory Huz on 21/03/2018.
//

import UIKit

public struct CleanyModalBasicData {
    
    public let title: String?
    public let message: String?
    public let icon: UIImage?
    
    public init(title: String?, message: String?, iconImgName: String? = nil) {
        self.title = title
        self.message = message
        
        if iconImgName != nil {
            self.icon = UIImage(named: iconImgName!)
        } else {
            self.icon = nil
        }
    }
}

public struct CleanyModalStyle {
    
    let tintColor: UIColor?
    let cornerRadius: CGFloat?
    
    let textColor: UIColor?
    let defaultActionColor: UIColor?
    let destructiveColor: UIColor?
    
    let actionCellHeight: CGFloat
    
    let titleFont: UIFont?
    let messageFont: UIFont?
    let actionsFont: UIFont?
    
    public init(tintColor: UIColor? = nil, cornerRadius: CGFloat? = nil, textColor: UIColor? = nil,
                defaultActionColor: UIColor? = nil, destructiveColor: UIColor? = nil, actionCellHeight: CGFloat = 60,
                titleFont: UIFont? = nil, messageFont: UIFont? = nil, actionsFont: UIFont? = nil) {
        
        self.tintColor = tintColor
        self.cornerRadius = cornerRadius ?? 15
        self.textColor = textColor ?? UIColor.black
        self.defaultActionColor = defaultActionColor ?? textColor ?? UIColor.black
        self.destructiveColor = destructiveColor ?? UIColor.red
        self.actionCellHeight = actionCellHeight
        self.titleFont = titleFont
        self.messageFont = messageFont
        self.actionsFont = actionsFont
    }
}
