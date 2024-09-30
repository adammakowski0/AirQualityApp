//
//  AirQualityIndexModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


struct AirQualityIndex : Identifiable, Codable {
    let id: Int
    let stCalcDate: String
    let stIndexLevel: IndexLevel
    let stSourceDataDate: String
    
}

struct IndexLevel : Codable {
    let id: Int
    let indexLevelName: String
}
