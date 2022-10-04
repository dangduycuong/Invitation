//
//  WeatherViewModel.swift
//  RealmTasks
//
//  Created by cuongdd on 23/04/2022.
//

import Foundation
import GoogleMaps

protocol WeatherViewModelDelegate: AnyObject {
    func updateData(weather: RealtimeWeather)
}

class WeatherViewModel {
    
    var cocationCoordinate = CLLocationCoordinate2D()
    var weather: RealtimeWeather?
    weak var delegate: WeatherViewModelDelegate?
    
    func realtimeWeather() {
        let latitude = cocationCoordinate.latitude
        let longitude = cocationCoordinate.longitude
        let double = latitude
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let number =  numberFormatter.string(from: NSNumber(value: double)) else { fatalError("Can not get number") }
        print("\(number)")
        
        let urlQueryItem: [URLQueryItem] = [
            URLQueryItem(name: "q", value: "\(latitude),\(longitude)")
        ]
        var urlComponents = URLComponents(string: "https://weatherapi-com.p.rapidapi.com")
        urlComponents?.path = "/current.json"
        urlComponents?.queryItems = urlQueryItem
        guard let url = urlComponents?.url else { return }
        let headers = [
            "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com",
            "X-RapidAPI-Key": "fb71aa7f62msh153e4924e940392p16bbc4jsn166248f8bdaa"
        ]
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            print("params", urlQueryItem)
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                }
                print(httpResponse as Any)
            }
            do {
                if let data = data {
//                    data.printFormatedJSON()
                    let json = try JSONDecoder().decode(RealtimeWeather.self, from: data)
                    self.weather = json
                    self.delegate?.updateData(weather: json)
                }
            } catch let error {
                print(error)
            }
        })
        dataTask.resume()
    }
}

