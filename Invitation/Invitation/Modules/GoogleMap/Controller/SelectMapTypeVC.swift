//
//  SelectMapTypeVC.swift
//  Invitation
//
//  Created by cuongdd on 05/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import UIKit
import GoogleMaps

class SelectMapTypeVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectMapType: ((_ mapType: GMSMapViewType) -> Void)?
    
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
        var mapType = GMSMapViewType.normal
        switch MapType.all[indexPath.row] {
        case .normal:
            mapType = .normal
        case .satellite:
            mapType = .satellite
        case .terrain:
            mapType = .terrain
        case .hybrid:
            mapType = .hybrid
        case .none:
            mapType = .none
        }
        selectMapType?(mapType)
        dismiss(animated: true)
    }
    
}
