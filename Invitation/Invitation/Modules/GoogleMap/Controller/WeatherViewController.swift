//
//  WeatherViewController.swift
//  RealmTasks
//
//  Created by cuongdd on 21/04/2022.
//

import UIKit
import GoogleMaps

//enum MapType {
//    case normal
//    case satellite
//    case terrain
//    case hybrid
//    case noneNormal
//
//    static let all = [normal, satellite, terrain, hybrid, noneNormal]
//
//    var text: String {
//        get {
//            switch self {
//            case .normal:
//                return "Normal"
//            case .satellite:
//                return "Satellite"
//            case .terrain:
//                return "Terrain"
//            case .hybrid:
//                return "Hybrid"
//            case .noneNormal:
//                return "None"
//            }
//        }
//    }
//}

class WeatherViewController: BaseViewController {
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var weatherInfoView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeConditionLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var tempCLabel: UILabel!
    @IBOutlet weak var feelslikeCLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windkphLabel: UILabel!
    @IBOutlet weak var conditionTextLabel: UILabel!
    
    lazy private var markerInfoView: UIView = {
        let view = MarkerInfoView.loadFromNib()
        return view
    }()
    
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    
    var viewModel = WeatherViewModel()
    var timer = Timer()
    
    deinit {
//        NotificationCenter.default.removeObserver(self, name: .changeMapType, object: nil)
    }
}

// MARK: - Lifecycle
extension WeatherViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(changeMapType), name: .changeMapType, object: nil)
        setupUI()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        viewModel.delegate = self
        mapView.delegate = self
        mapView.mapType = .satellite
        mapView.animate(toZoom: 17)
    }
    
    @objc func timerAction() {
        viewModel.realtimeWeather()
    }
    
    private func setupUI() {
        weatherInfoView.layer.shadowColor = UIColor.white.cgColor
        weatherInfoView.layer.shadowOpacity = 0.35
        weatherInfoView.layer.shadowOffset = .zero
        weatherInfoView.layer.shadowRadius = 2
        weatherInfoView.layer.cornerRadius = 10
        weatherInfoView.isHidden = true
        
        navigationBarButtonItems([(ItemType.back, ItemPosition.left), (ItemType.rightMenu, ItemPosition.right)])
    }
    
    override func openRightMenu() {
        
    }
    
    @objc private func changeMapType(notification: Notification) {
//        let dropDown = DropDown()
//
//        DropDown.appearance().textColor = UIColor.white
//        DropDown.appearance().selectedTextColor = UIColor.red
//        if let font = PlayfairDisplayFont.semiBold(with: 20) {
//            DropDown.appearance().textFont = font
//        }
//        DropDown.appearance().backgroundColor = UIColor.black
//        DropDown.appearance().selectionBackgroundColor = UIColor.black
//        DropDown.appearance().cellHeight = 60
//
//        DropDown.startListeningToKeyboard()
//
//        // The view to which the drop down will appear on
//        dropDown.anchorView = view // UIView or UIBarButtonItem
//
//        dropDown.direction = .bottom
//        dropDown.bottomOffset = CGPoint(x: UIScreen.main.bounds.width - 118, y: 8)
//        dropDown.width = 110
//
//        // The list of items to display. Can be changed dynamically
//        dropDown.dataSource = MapType.all.map { $0.text }
//
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            var mapType = GMSMapViewType.normal
//            switch MapType.all[index] {
//            case .normal:
//                mapType = .normal
//            case .satellite:
//                mapType = .satellite
//            case .terrain:
//                mapType = .terrain
//            case .hybrid:
//                mapType = .hybrid
//            case .noneNormal:
//                mapType = .none
//            }
//            mapView.mapType = mapType
//            mapView.animate(toZoom: 17)
//        }
//
//        dropDown.show()
    }
    
    //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    guard
    //      let navigationController = segue.destination as? UINavigationController,
    //      let controller = navigationController.topViewController as? TypesTableViewController
    //      else {
    //        return
    //    }
    //    controller.selectedTypes = searchedTypes
    //    controller.delegate = self
    //  }
    
    
}

// MARK: - Actions
extension WeatherViewController {
    @IBAction func refreshPlaces(_ sender: Any) {
        fetchPlaces(near: mapView.camera.target)
    }
    
    func fetchPlaces(near coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        dataProvider.fetchPlaces(
            near: coordinate,
            radius: searchRadius,
            types: searchedTypes
        ) { places in
            places.forEach { place in
                let marker = PlaceMarker(place: place, availableTypes: self.searchedTypes)
                marker.map = self.mapView
            }
        }
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            self.addressLabel.unlock()
            
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
            }
            
            self.addressLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            let topInset = self.view.safeAreaInsets.top
            self.mapView.padding = UIEdgeInsets(
                top: topInset,
                left: 0,
                bottom: labelHeight,
                right: 0)
            
            UIView.animate(withDuration: 0.25) {
                self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - TypesTableViewControllerDelegate
//extension WeatherViewController: TypesTableViewControllerDelegate {
//  func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
//    searchedTypes = controller.selectedTypes.sorted()
//    dismiss(animated: true)
//    fetchPlaces(near: mapView.camera.target)
//  }
//}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 17,
            bearing: 0,
            viewingAngle: 0)
        fetchPlaces(near: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - GMSMapViewDelegate
extension WeatherViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
        viewModel.cocationCoordinate = position.target
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        timer.invalidate()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
        
        if gesture {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        guard let infoView = markerInfoView as? MarkerInfoView else {
            return nil
        }
        
        infoView.nameLabel.text = placeMarker.place.name
        infoView.addressLabel.text = placeMarker.place.address
        
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        mapView.animate(toZoom: 17)
        viewModel.realtimeWeather()
        return false
    }
}


extension WeatherViewController: WeatherViewModelDelegate {
    func updateData(weather: RealtimeWeather) {
        DispatchQueue.main.async {
            self.fillData(weather: weather)
        }
    }
    
    private func fillData(weather: RealtimeWeather) {
        weatherInfoView.isHidden = false
        locationLabel.text = weather.location?.name
        timeConditionLabel.text = weather.current?.lastUpdated
        if let tempC = weather.current?.tempC?.toString() {
            tempCLabel.text = "\(tempC)"
        }
        
        if let feelslikeC = weather.current?.feelslikeC?.toString() {
            feelslikeCLabel.text = "Feels Like \(feelslikeC) °C"
        }
        
        if let humidity = weather.current?.humidity?.toString() {
            humidityLabel.text = "Humidity \(humidity) %"
        }
        
        if let windKph = weather.current?.windKph?.toString() {
            windkphLabel.text = "Wind \(windKph) Kph"
        }
        
        if let text = weather.current?.condition?.text {
            conditionTextLabel.text = text
        }
    }
}
