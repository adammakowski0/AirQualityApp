//
//  SensorDataModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation

struct SensorDataResponse: Codable {
    let sensorData: [SensorData]
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case sensorData = "Lista danych pomiarowych"
        case totalPages
    }
}


struct SensorData : Codable, Identifiable {
    let key: String
    let date: String
    var value: Double? = nil
    var id: UUID? = UUID()
    
    enum CodingKeys: String, CodingKey {
        case key = "Kod stanowiska"
        case date = "Data"
        case value = "Wartość"
    }
}


struct SensorDataValues : Codable, Identifiable {
    let date: String
    var value: Double? = nil
    var id: UUID? = UUID()
}
