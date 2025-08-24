//
//  TimelineProvider.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> AirQualityEntry {
        
        let airQuality = AirQualityIndex(stationId: 1, stCalcDate: "2024-01-01 12:00:00", indexLevelName: "Dobry")
        let airQualityResponse = AirQualityIndexResponse(AirQualityIndex: airQuality, totalPages: nil)
        let config = SelectStationIntent(station: StationDetail(id: 1, code: "XYZ", stationName: "Nazwa stacji pomiarowej", gegrLat: "50.0", gegrLon: "15.00", cityId: 1, cityName: "Miasto", commune: "", district: "", voivodeship: "", street: ""), sensor: SensorDetail(id: 1, stationId: 1, paramName: "", paramFormula: "", paramCode: "", idParam: 1))
        
        return AirQualityEntry(date: Date(), configuration: config, airQualityResponse: airQualityResponse, sensorDataResponse: nil)
    }
    
    func snapshot(for configuration: SelectStationIntent, in context: Context) async -> AirQualityEntry {
        
        let airQuality = AirQualityIndex(stationId: 1, stCalcDate: "2024-01-01 12:00:00", indexLevelName: "Dobry")
        let airQualityResponse = AirQualityIndexResponse(AirQualityIndex: airQuality, totalPages: nil)
        let config = SelectStationIntent(station: StationDetail(id: 1, code: "XYZ", stationName: "Nazwa stacji pomiarowej", gegrLat: "50.0", gegrLon: "15.00", cityId: 1, cityName: "Miasto", commune: "", district: "", voivodeship: "", street: ""), sensor: SensorDetail(id: 1, stationId: 1, paramName: "", paramFormula: "", paramCode: "", idParam: 1))
        
        return AirQualityEntry(date: Date(), configuration: config, airQualityResponse: airQualityResponse, sensorDataResponse: nil)
    }
    
    func timeline(for configuration: SelectStationIntent, in context: Context) async -> Timeline<AirQualityEntry> {

        await createTimeline(for: configuration, in: context)
    }

    func createTimeLineEntry(for configuration: SelectStationIntent, in context: Context) async -> AirQualityEntry {

        let airQualityDataResponse = await getAirQualityData(for: configuration, in: context)
        let sensorDataResponse = await getSensorData(for: configuration, in: context)
        
        return AirQualityEntry(date: .now, configuration: configuration, airQualityResponse: airQualityDataResponse, sensorDataResponse: sensorDataResponse)
        
    }
    
    func createTimeline(for configuration: SelectStationIntent, in context: Context) async -> Timeline<AirQualityEntry> {

        let airQualityDataResponse = await getAirQualityData(for: configuration, in: context)
        let sensorDataResponse = await getSensorData(for: configuration, in: context)
        
        let entry = AirQualityEntry(date: .now, configuration: configuration, airQualityResponse: airQualityDataResponse, sensorDataResponse: sensorDataResponse)
        return Timeline(entries: [entry], policy: .atEnd)
        
    }
    
    func getAirQualityData(for configuration: SelectStationIntent, in context: Context) async -> AirQualityIndexResponse? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/aqindex/getIndex/\(configuration.station?.id ?? 0)?size=500") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode(AirQualityIndexResponse.self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func getSensorData(for configuration: SelectStationIntent, in context: Context) async -> SensorDataResponse? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/data/getData/\(configuration.sensor?.id ?? 0)?size=500") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode(SensorDataResponse.self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
