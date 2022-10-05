//
//  SelectMapTypeVC.swift
//  Invitation
//
//  Created by cuongdd on 05/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import UIKit

class SelectMapTypeVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectMapType: ((_ mapType: MapType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(MapTypeTableViewCell.self)
    }

}

// MARK: - Configure TableView
extension SelectMapTypeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapType.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: MapTypeTableViewCell.self, forIndexPath: indexPath)
        cell.mapTypeLabel.text = MapType.all[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMapType?(MapType.all[indexPath.row])
        dismiss(animated: true)
    }
    
}
