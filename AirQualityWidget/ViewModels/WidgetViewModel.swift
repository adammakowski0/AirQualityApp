//
//  WidgetViewModel.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import SwiftUI
import WidgetKit

class WidgetViewModel {
    
    
//    func getStations() async -> [Station]? {
//        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else {return nil}
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
//            return try JSONDecoder().decode([Station].self, from: data)
//        }
//        catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    
//    func getSensors(for configuration: ConfigurationAppIntent) async -> Sensor? {
//        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/sensors/\(configuration.station?.station.id ?? 114)") else {return nil}
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
//            return try JSONDecoder().decode(Sensor.self, from: data)
//        }
//        catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    
//    func getSensorData(for configuration: ConfigurationAppIntent) async -> SensorData? {
//        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/data/getData/\(configuration.station.station.id)") else {return nil}
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
//            return try JSONDecoder().decode(SensorData.self, from: data)
//        }
//        catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    
//    func getAirQualityData(for configuration: SelectCharacterIntent) async -> AirQualityIndex? {
//        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/\(configuration.character?.id ?? 114)") else {return nil}
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
//            return try JSONDecoder().decode(AirQualityIndex.self, from: data)
//        }
//        catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    
    
    func getColor(forAirQuality quality: String) -> Color {
        switch quality {
        case "Bardzo dobry":
            return Color(red: 0.1, green: 0.9, blue: 0.0)
        case "Dobry":
            return Color(red: 0.2, green: 0.8, blue: 0.0)
        case "Umiarkowany":
            return Color(red: 0.5, green: 0.5, blue: 0.0)
        case "Zły":
            return Color(red: 0.8, green: 0.2, blue: 0.0)
        case "Bardzo zły":
            return Color(red: 1.0, green: 0.0, blue: 0.0)
        default:
            return .gray
        }
    }
}
