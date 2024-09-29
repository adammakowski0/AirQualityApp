//
//  TimelineProvider.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: SelectCharacterIntent(), airQuality: nil)
    }
    
    func snapshot(for configuration: SelectCharacterIntent, in context: Context) async -> SimpleEntry {
        await createTimeLineEntry(for: configuration, in: context)
    }
    
    func timeline(for configuration: SelectCharacterIntent, in context: Context) async -> Timeline<SimpleEntry> {

        await createTimeline(for: configuration, in: context)
    }

    func createTimeLineEntry(for configuration: SelectCharacterIntent, in context: Context) async -> SimpleEntry {

        let airQualityData = await getAirQualityData(for: configuration, in: context)
        return SimpleEntry(date: Date(), configuration: configuration, airQuality: airQualityData)
        
    }
    
    func createTimeline(for configuration: SelectCharacterIntent, in context: Context) async -> Timeline<SimpleEntry> {

        let airQualityData = await getAirQualityData(for: configuration, in: context)
        let entry = SimpleEntry(date: Date(), configuration: configuration, airQuality: airQualityData)
        return Timeline(entries: [entry], policy: .atEnd)
        
    }
    
    func getAirQualityData(for configuration: SelectCharacterIntent, in context: Context) async -> AirQualityIndex? {
        print(configuration.character?.id ?? 0.0)
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/\(configuration.character?.id ?? 0)") else {return nil}
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
}
