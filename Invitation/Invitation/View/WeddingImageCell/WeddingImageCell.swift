//
//  WeddingImageCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/4/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class WeddingImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var sizeOfItem = CGSize(width: 90, height: 90)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func identifier() -> String {
        return "WeddingImageCell"
    }
    
    func setDisplay() {
        widthConstraint.constant = sizeOfItem.width
    }

}
