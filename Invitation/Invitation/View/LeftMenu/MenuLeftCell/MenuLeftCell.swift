//
//  MenuLeftCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/4/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class MenuLeftCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var titleMenuTextView: UITextView!
    @IBOutlet weak var lineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleMenuTextView.setDefaultTitleField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
