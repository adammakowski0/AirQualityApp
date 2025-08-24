//
//  StationModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


//struct Station: Identifiable, Codable, Equatable{
//    let id: Int
//    let stationName: String
//    let gegrLat: String
//    let gegrLon: String
////    let city: City
//    let cityId: Int
//    var isFavourite: Bool? = false
//    
//    static func == (lhs: Station, rhs: Station) -> Bool {
//        if lhs.id != rhs.id { return false }
//        return true
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case id = "Identyfikator stacji"
//        case stationName = "Nazwa stacji"
//        case gegrLat = "WGS84 φ N"
//        case gegrLon = "WGS84 λ E"
//        case cityId = "Identyfikator miasta"
//    }
//}
//
//struct StationsResponse: Codable {
//    let stations: [Station]
//
//    enum CodingKeys: String, CodingKey {
//        case stations = "Lista stacji pomiarowych"
//    }
//}

struct StationsResponse: Codable {
    let stations: [Station]
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case stations = "Lista stacji pomiarowych"
        case totalPages
    }
}

struct Station: Identifiable, Codable, Equatable {
    let id: Int
    let code: String
    let stationName: String
    let gegrLat: String
    let gegrLon: String
    let cityId: Int?
    let cityName: String
    let commune: String?
    let district: String?
    let voivodeship: String
    let street: String?
    var isFavourite: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id = "Identyfikator stacji"
        case code = "Kod stacji"
        case stationName = "Nazwa stacji"
        case gegrLat = "WGS84 φ N"
        case gegrLon = "WGS84 λ E"
        case cityId = "Identyfikator miasta"
        case cityName = "Nazwa miasta"
        case commune = "Gmina"
        case district = "Powiat"
        case voivodeship = "Województwo"
        case street = "Ulica"
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
