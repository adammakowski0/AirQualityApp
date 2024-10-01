//
//  SensorEntry.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 01/10/2024.
//

import Foundation
import WidgetKit
import AppIntents

struct SensorDetail: AppEntity, Codable {
    let id: Int
    let stationId: Int
    let param: Param
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Sensor"
    static var defaultQuery = SensorQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(param.paramName.capitalized)")
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
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/sensors/\(station?.station.id ?? 0)") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode([SensorDetail].self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
