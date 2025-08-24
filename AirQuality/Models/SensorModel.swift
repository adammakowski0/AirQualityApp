//
//  SensorModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


struct SensorsResponse: Codable {
    let sensors: [Sensor]
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case sensors = "Lista stanowisk pomiarowych dla podanej stacji"
        case totalPages = "totalPages"
    }
}

struct Sensor: Identifiable, Codable {
    let id: Int
    let stationId: Int
    let paramName: String
    let paramFormula: String
    let paramCode: String
    let idParam: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "Identyfikator stanowiska"
        case stationId = "Identyfikator stacji"
        case paramName =  "Wskaźnik"
        case paramFormula = "Wskaźnik - wzór"
        case paramCode = "Wskaźnik - kod"
        case idParam = "Id wskaźnika"
    }
}
struct Param : Codable {
    let paramName: String
    let paramFormula: String
    let paramCode: String
    let idParam: Int
}
