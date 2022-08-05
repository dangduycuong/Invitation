//
//  BaseTableViewCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    weak var delegate: AnyObject?
    var indexPath: IndexPath?
    
    var isEnableLongPressGestureRecognizer: Bool = false
    lazy var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isEnableLongPressGestureRecognizer {
            addGestureRecognizer(longPressGestureRecognizer)
        }
        
        self.selectionStyle = .none
    }
    
    func setIndexPath(_ indexPath: IndexPath?, delegate: AnyObject?) {
        self.indexPath = indexPath
        self.delegate = delegate
    }
}

extension BaseTableViewCell {

    @objc class func identifier() -> String {
        return self.nibName()
    }
    
    @objc func setData(_ data: Any?) {
        
    }
}

extension BaseTableViewCell {

    // MARK: - Actions
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
    }
}

