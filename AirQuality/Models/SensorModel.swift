//
//  SensorModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation


struct Sensor: Identifiable, Codable {
    let id: Int
    let stationId: Int
    let param: Param
    
}
struct Param : Codable {
    let paramName: String
    let paramFormula: String
    let paramCode: String
    let idParam: Int
}
