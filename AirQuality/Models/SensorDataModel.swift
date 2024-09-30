//
//  SensorDataModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


struct SensorData : Codable {
    let key: String
    var values: [SensorDataValues]
}

struct SensorDataValues : Codable, Identifiable {
    let date: String
    var value: Double? = nil
    var id: UUID? = UUID()
}
