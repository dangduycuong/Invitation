//
//  ChoseContactCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class ChoseContactCell: BaseTableViewCell {
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    
    var infoContact = FetchedContact()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDisplay()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplay() {
//        nameTextView.setDefaultFont()
//        phoneTextView.setDefaultTitleField()
    }
    
    func fillData() {
        if let icon = infoContact.iconContact {
            contactImageView.image = UIImage(data: icon)
        }
        nameTextView.text = infoContact.firstName
        phoneTextView.text = infoContact.telephone
    }
    
}
