//
//  AirQualityIndexModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


struct AirQualityIndexResponse: Codable {
    let AirQualityIndex: AirQualityIndex
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case AirQualityIndex = "AqIndex"
        case totalPages
    }
}

struct AirQualityIndex : Identifiable, Codable {
    let id: UUID = UUID()
    let stationId: Int
    let stCalcDate: String
    let indexLevelName: String
    
    enum CodingKeys: String, CodingKey {
        case stationId = "Identyfikator stacji pomiarowej"
        case stCalcDate = "Data wykonania obliczeń indeksu"
        case indexLevelName = "Nazwa kategorii indeksu"
    }
    
}

struct IndexLevel : Codable {
    let id: Int
    let indexLevelName: String
}
