//
//  AppIntent.swift
//  AirQualityWidget
//
//  Created by Adam Makowski on 24/09/2024.
//

import WidgetKit
import AppIntents
import SwiftUI

struct SelectStationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Wybierz stację pomiarową"
    static var description = IntentDescription("Wyświetla dane o jakości powietrza z wybranej stacji pomiarowej.")

    @Parameter(title: "Stacja pomiarowa")
    var station: StationDetail?

    init(station: StationDetail) {
        self.station = station
    }
    
    init() {
    }
}

struct StationDetail: AppEntity, Codable {
    let id: Int
    let stationName: String
    let gegrLat: String
    let gegrLon: String
    let city: City
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stacja pomiarowa"
    static var defaultQuery = StationQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(stationName)")
    }
}

struct StationQuery: EntityQuery {
    func entities(for identifiers: [StationDetail.ID]) async throws -> [StationDetail] {
        let data = await getStations()
        if let data{
            return data.filter { identifiers.contains($0.id) }
        }
        return []
    }
    
    func suggestedEntities() async throws -> [StationDetail] {
        let data = await getStations()
        if let data{
            return data
        }
        return []
    }
    
    func defaultResult() async -> StationDetail? {
        try? await suggestedEntities().first
    }
    
    func getStations() async -> [StationDetail]? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode([StationDetail].self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

