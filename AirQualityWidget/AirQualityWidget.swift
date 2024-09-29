//
//  AirQualityWidget.swift
//  AirQualityWidget
//
//  Created by Adam Makowski on 24/09/2024.
//

import WidgetKit
import SwiftUI

struct AirQualityWidgetSmall: Widget {
    let kind: String = "AirQualityWidgetSmall"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectCharacterIntent.self, provider: Provider()) { entry in
            AirQualityWidgetSmallView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}

#Preview(as: .systemSmall) {
    AirQualityWidgetSmall()
} timeline: {
    SimpleEntry(date: .now, configuration: SelectCharacterIntent(), airQuality: nil)
}
//#Preview(as: .systemMedium) {
//    AirQualityWidgetMedium()
//} timeline: {
//    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), airQuality: nil)
//}
