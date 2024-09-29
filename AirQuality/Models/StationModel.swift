//
//  StationModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


struct Station: Identifiable, Codable, Equatable{
    let id: Int
    let stationName: String
    let gegrLat: String
    let gegrLon: String
    let city: City
    var isFavourite: Bool? = false
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        if lhs.id != rhs.id { return false }
        return true
    }
}

struct City: Codable, Identifiable {
    let id: Int
    let name: String
    let commune: Commune
    
}
struct Commune: Codable {
    let communeName: String
    let districtName: String
    let provinceName: String
}
