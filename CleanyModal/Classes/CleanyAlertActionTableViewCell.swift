//
//  CleanyAlertActionTableViewCell.swift
//  Alamofire
//
//  Created by Lory Huz on 28/06/2018.
//

import UIKit

class CleanyAlertActionTableViewCell: UITableViewCell {

    @IBOutlet weak var textLB: UILabel!
    @IBOutlet weak private var iv: UIImageView!
    
    var title: String? {
        didSet {
            textLB.text = title
        }
    }

    var img: UIImage? {
        didSet {
            iv.image = img
        }
    }
}
