//
//  StationDetailEntity.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 01/10/2024.
//

import Foundation
import WidgetKit
import AppIntents


struct StationDetailResponse: Codable {
    let stationDetails: [StationDetail]
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case stationDetails = "Lista stacji pomiarowych"
        case totalPages
    }
}

struct StationDetail: AppEntity, Codable {
    let id: Int
    let code: String
    let stationName: String
    let gegrLat: String
    let gegrLon: String
    let cityId: Int?
    let cityName: String
    let commune: String?
    let district: String?
    let voivodeship: String
    let street: String?
    var isFavourite: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id = "Identyfikator stacji"
        case code = "Kod stacji"
        case stationName = "Nazwa stacji"
        case gegrLat = "WGS84 φ N"
        case gegrLon = "WGS84 λ E"
        case cityId = "Identyfikator miasta"
        case cityName = "Nazwa miasta"
        case commune = "Gmina"
        case district = "Powiat"
        case voivodeship = "Województwo"
        case street = "Ulica"
    }
    
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
            return data.sorted { $0.stationName.lowercased() < $1.stationName.lowercased()}
        }
        return []
    }
    
    func defaultResult() async -> StationDetail? {
        try? await suggestedEntities().first
    }
    
    func getStations() async -> [StationDetail]? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/station/findAll?size=500") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            let stationDetailResponse = try JSONDecoder().decode(StationDetailResponse.self, from: data)
            return stationDetailResponse.stationDetails
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
