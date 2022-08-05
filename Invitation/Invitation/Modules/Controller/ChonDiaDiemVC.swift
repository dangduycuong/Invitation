//
//  ChonDiaDiemVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import GoogleMaps

enum MapType {
    case hybrid
    case none
    case normal
    case satellite
    case terrain
    
    static let all = [hybrid, none, normal, satellite, terrain]
    
    var text: String {
        get {
            switch self {
            case .hybrid:
                return "Hỗn hợp"
            case .none:
                return "None"
            case .normal:
                return "Bình thường"
            case .satellite:
                return "Vệ tinh"
            case .terrain:
                return "Địa hình"
            }
        }
    }
}

class ChonDiaDiemVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    let locationManager = CLLocationManager()
    //20.02227950341591, 106.04031572399296
    var currentLocation: CLLocation = CLLocation.init(latitude: CLLocationDegrees(20.02227950341591), longitude: CLLocationDegrees(106.04031572399296))
    var infoKM = ThongTinKhachMoiModel()
    var passCoordinate: ((ThongTinKhachMoiModel) -> ())?
    var titleString: String?
    let dropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMap()
        settingMap()
        mapTypeButton.setTitle(MapType.normal.text, for: .normal)
        mapTypeButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let titleString = titleString {
            title = titleString
        }
    }
    
    func settingMap(){
        // GOOGLE MAPS SDK: BORDER
        //        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        //        self.viewMap?.padding = mapInsets
        
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func loadMap() {
        guard let mapView = mapView else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude, zoom: 15.0)
        
        //        mapView = GMSMapView.map(withFrame: self.viewWrapperMap.bounds, camera: camera)
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.mapType = .terrain
        
        
        mapView.animate(to: camera)
        
        self.view.layoutIfNeeded()
    }
    
    func showMap(latitude: Double, longitude: Double, address: String) {
        guard let mapView = mapView else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.5)
        
        mapView.animate(to: camera)
        
        let projection = mapView.projection.visibleRegion()
        
        let topLeftCorner: CLLocationCoordinate2D = projection.farLeft
        //            let topRightCorner: CLLocationCoordinate2D = projection.farRight
        //            let bottomLeftCorner: CLLocationCoordinate2D = projection.nearLeft
        let bottomRightCorner: CLLocationCoordinate2D = projection.nearRight
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
    }
    
    func showChooseMaptype() {
        dropdown.dataSource = MapType.all.map { $0.text }
        
        dropdown.anchorView = mapTypeButton
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: mapTypeButton.bounds.size.height)
        dropdown.dismissMode = .onTap
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.mapTypeButton.setTitle(item, for: .normal)
            switch MapType.all[index] {
            case .hybrid:
                self.mapView.mapType = .hybrid
            case .none:
                self.mapView.mapType = .none
            case .normal:
                self.mapView.mapType = .normal
            case .satellite:
                self.mapView.mapType = .satellite
            case .terrain:
                self.mapView.mapType = .terrain
            }
            print("Selected map type", self.mapView.mapType.self)
        }
        
        dropdown.show()
    }
    
    // MARK: - Action
    
    @IBAction func tapChangeMapType(_ sender: Any) {
        showChooseMaptype()
    }
    
    @IBAction func tapDoneSelect(_ sender: Any) {
        passCoordinate?(infoKM)
        navigationController?.popViewController(animated: true)
    }
}

extension ChonDiaDiemVC: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    //MARK: Action
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("draging...")
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
    }
    
    // start scroll google map
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("start scroll google map")
    }
    
    // stoped scroll google map
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("Stop scroll map...")
        //        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        displayWhenZoomMap()
    }
    
    @objc func timerAction() {
        callAPIWhenStopScrollMap()
    }
    
    func callAPIWhenStopScrollMap() {
        
    }
    
    //Coordinate in 4 corner map screen
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("position", position.target)
        //        zoomMap = position.zoom
        //        let projection = mapView.projection.visibleRegion()
        //        let topLeftCorner: CLLocationCoordinate2D = projection.farLeft
        //        let bottomRightCorner: CLLocationCoordinate2D = projection.nearRight
        //
        //        x1 = topLeftCorner.latitude
        //        y1 = topLeftCorner.longitude
        //        x2 = bottomRightCorner.latitude
        //        y2 = bottomRightCorner.longitude
        //
        let latitude = mapView.camera.target.latitude
        let longtitude = mapView.camera.target.longitude
        
        infoKM.latitude = latitude
        infoKM.longitude = longtitude
        //
        //        markerImageView.isHidden = false
        //        timer.invalidate()
    }
    
    func displayWhenZoomMap() {
        // zoomMap default = 17 All
        // [15 - 17): Display tuyến, đoạn, nhà trạm
        // 14 - 15 only station
        
        
    }
    
    //Tapped in marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    // tapped in map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("didTapAt coordinate: ", coordinate)
    }
    
    @IBAction func tapDirect(_ sender: UIButton!) {
        let latitude = infoKM.latitude
        let longtitude = infoKM.longitude
        let vc = Storyboard.Main.directVC()
        vc.latitude = latitude.toString()
        vc.longitude = longtitude.toString()
        title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
