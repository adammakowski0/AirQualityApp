//
//  SensorEntry.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 01/10/2024.
//

import Foundation
import WidgetKit
import AppIntents

struct SensorDetailResponse: Codable {
    let sensorDetails: [SensorDetail]
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case sensorDetails = "Lista stanowisk pomiarowych dla podanej stacji"
        case totalPages = "totalPages"
    }
}


struct SensorDetail: AppEntity, Codable {
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
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Sensor"
    static var defaultQuery = SensorQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(paramName.capitalized)")
    }
}

struct SensorQuery: EntityQuery {
    
    @IntentParameterDependency<SelectStationIntent>(\.$station) var station
    
    
    func entities(for identifiers: [SensorDetail.ID]) async throws -> [SensorDetail] {
        let data = await getSensors()
        if let data{
            return data.filter { identifiers.contains($0.id) }
        }
        return []
    }
    
    func suggestedEntities() async throws -> [SensorDetail] {
        let data = await getSensors()
        if let data{
            return data
        }
        return []
    }
    
    func defaultResult() async -> SensorDetail? {
        try? await suggestedEntities().first
    }
    
    func getSensors() async -> [SensorDetail]? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/station/sensors/\(station?.station.id ?? 0)?size=500") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            let sensorDataResponse = try JSONDecoder().decode(SensorDetailResponse.self, from: data)
            return sensorDataResponse.sensorDetails
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
