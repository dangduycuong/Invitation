//
//  RealtimeWeather.swift
//  RealmTasks
//
//  Created by cuongdd on 23/04/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let realtimeWeather = try? newJSONDecoder().decode(RealtimeWeather.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let realtimeWeather = try? newJSONDecoder().decode(RealtimeWeather.self, from: jsonData)

import Foundation

// MARK: - RealtimeWeather
struct RealtimeWeather: Codable {
    let current: Current?
    let location: Location?
}

// MARK: - Current
struct Current: Codable {
    let gustMph, gustKph, precipIn, precipMm: Double?
    let cloud, lastUpdatedEpoch: Int?
    let feelslikeF, feelslikeC: Double?
    let isDay, visMiles: Int?
    let pressureIn: Double?
    let visKM: Int?
    let windDir: String?
    let windDegree: Int?
    let tempF: Double?
    let humidity: Int?
    let windMph: Double?
    let condition: Condition?
    let pressureMB: Int?
    let windKph, tempC: Double?
    let lastUpdated: String?
    let uv: Int?
    
    enum CodingKeys: String, CodingKey {
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case precipIn = "precip_in"
        case precipMm = "precip_mm"
        case cloud
        case lastUpdatedEpoch = "last_updated_epoch"
        case feelslikeF = "feelslike_f"
        case feelslikeC = "feelslike_c"
        case isDay = "is_day"
        case visMiles = "vis_miles"
        case pressureIn = "pressure_in"
        case visKM = "vis_km"
        case windDir = "wind_dir"
        case windDegree = "wind_degree"
        case tempF = "temp_f"
        case humidity
        case windMph = "wind_mph"
        case condition
        case pressureMB = "pressure_mb"
        case windKph = "wind_kph"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case uv
    }
}

// MARK: - Condition
struct Condition: Codable {
    let code: Int?
    let text, icon: String?
}

// MARK: - Location
struct Location: Codable {
    let region, country, localtime: String?
    let lon, lat: Double?
    let tzID, name: String?
    let localtimeEpoch: Int?
    
    enum CodingKeys: String, CodingKey {
        case region, country, localtime, lon, lat
        case tzID = "tz_id"
        case name
        case localtimeEpoch = "localtime_epoch"
    }
}
