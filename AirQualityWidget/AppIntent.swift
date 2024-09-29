//
//  AppIntent.swift
//  AirQualityWidget
//
//  Created by Adam Makowski on 24/09/2024.
//

import WidgetKit
import AppIntents
import SwiftUI

struct SelectCharacterIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Character"
    static var description = IntentDescription("Selects the character to display information for.")


    @Parameter(title: "Character")
    var character: CharacterDetail?


    init(character: CharacterDetail) {
        self.character = character
    }


    init() {
    }

}

struct CharacterDetail: AppEntity, Codable {
    let id: Int
    let stationName: String
    let gegrLat: String
    let gegrLon: String
    let city: City
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Character"
    static var defaultQuery = CharacterQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(stationName) \(id)")
    }
}

struct CharacterQuery: EntityQuery {
    func entities(for identifiers: [CharacterDetail.ID]) async throws -> [CharacterDetail] {
        let data = await getStations()
        if let data{
            return data.filter { identifiers.contains($0.id) }
        }
        return []

    }
    
    func suggestedEntities() async throws -> [CharacterDetail] {
        let data = await getStations()
        if let data{
            return data
        }
        return []
    }
    
    func defaultResult() async -> CharacterDetail? {
        try? await suggestedEntities().first
    }
    
    func getStations() async -> [CharacterDetail]? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode([CharacterDetail].self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

