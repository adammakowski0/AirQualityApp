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
        
        let airQuality = AirQualityIndex(id: 123, stCalcDate: "2024-01-01 12:00:00", stIndexLevel: IndexLevel(id: 1, indexLevelName: "Dobry"), stSourceDataDate: "2024-01-01 12:00:00")
        let config = SelectStationIntent(station: StationDetail(id: 1, stationName: "Nazwa stacji pomiarowej", gegrLat: "50.0", gegrLon: "15.00", city: City(id: 1, name: "Miasto", commune: Commune(communeName: "", districtName: "", provinceName: ""))), sensor: SensorDetail(id: 1, stationId: 1, param: Param(paramName: "", paramFormula: "", paramCode: "", idParam: 1)))
        
        return AirQualityEntry(date: Date(), configuration: config, airQuality: airQuality, sensorData: nil)
    }
    
    func snapshot(for configuration: SelectStationIntent, in context: Context) async -> AirQualityEntry {
        
        let airQuality = AirQualityIndex(id: 123, stCalcDate: "2024-01-01 12:00:00", stIndexLevel: IndexLevel(id: 1, indexLevelName: "Dobry"), stSourceDataDate: "2024-01-01 12:00:00")
        let config = SelectStationIntent(station: StationDetail(id: 1, stationName: "Nazwa stacji pomiarowej", gegrLat: "50.0", gegrLon: "15.00", city: City(id: 1, name: "Miasto", commune: Commune(communeName: "", districtName: "", provinceName: ""))), sensor: SensorDetail(id: 1, stationId: 1, param: Param(paramName: "", paramFormula: "", paramCode: "", idParam: 1)))
        
        return AirQualityEntry(date: Date(), configuration: config, airQuality: airQuality, sensorData: nil)
    }
    
    func timeline(for configuration: SelectStationIntent, in context: Context) async -> Timeline<AirQualityEntry> {

        await createTimeline(for: configuration, in: context)
    }

    func createTimeLineEntry(for configuration: SelectStationIntent, in context: Context) async -> AirQualityEntry {

        let airQualityData = await getAirQualityData(for: configuration, in: context)
        let sensorData = await getSensorData(for: configuration, in: context)
        
        return AirQualityEntry(date: Date(), configuration: configuration, airQuality: airQualityData, sensorData: sensorData)
        
    }
    
    func createTimeline(for configuration: SelectStationIntent, in context: Context) async -> Timeline<AirQualityEntry> {

        let airQualityData = await getAirQualityData(for: configuration, in: context)
        let sensorData = await getSensorData(for: configuration, in: context)
        
        let entry = AirQualityEntry(date: Date(), configuration: configuration, airQuality: airQualityData, sensorData: sensorData)
        return Timeline(entries: [entry], policy: .atEnd)
        
    }
    
    func getAirQualityData(for configuration: SelectStationIntent, in context: Context) async -> AirQualityIndex? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/\(configuration.station?.id ?? 0)") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode(AirQualityIndex.self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getSensorData(for configuration: SelectStationIntent, in context: Context) async -> SensorData? {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/data/getData/\(configuration.sensor?.id ?? 0)") else {return nil}
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
            return try JSONDecoder().decode(SensorData.self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
