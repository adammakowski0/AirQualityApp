//
//  AirQualityWidget.swift
//  AirQualityWidget
//
//  Created by Adam Makowski on 24/09/2024.
//

import WidgetKit
import SwiftUI

struct AirQualityWidget: Widget {
    let kind: String = "AirQualityWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectStationIntent.self, provider: Provider()) { entry in
            AirQualityWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Wskaźnik jakości powietrza")
        .description("Wyświetla wskaźnik jakości powietrza z wybranej stacji pomiarowej.")
    }
}

#Preview(as: .systemSmall) {
    AirQualityWidget()
} timeline: {
    AirQualityEntry(date: .now, configuration: SelectStationIntent(), airQuality: nil, sensorData: nil)
}
