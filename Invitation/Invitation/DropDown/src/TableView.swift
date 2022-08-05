//
//  TableView.swift
//  CustomDropdown
//
//  Created by Dang Duy Cuong on 9/28/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func enableFullSeperatorTableView() {
        self.tableFooterView = UIView.init(frame: CGRect.zero)
        self.separatorInset = .zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
    }
}
