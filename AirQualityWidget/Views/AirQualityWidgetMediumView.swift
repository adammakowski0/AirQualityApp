//
//  AirQualityWidgetMediumView.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import SwiftUI
import WidgetKit

struct AirQualityWidgetMediumView : View {
    var entry: Provider.Entry
    
    var widgetVM = WidgetViewModel()
    
    var body: some View {
        HStack{
            VStack {
                
                Text("Wskaźnik jakości powietrzaaaaaaa:")
                    .font(.caption)
                    .fontDesign(.rounded)
                let airIndex = entry.airQuality?.stIndexLevel.indexLevelName ?? "Brak danych"
                Text(airIndex)
                    .foregroundStyle(widgetVM.getColor(forAirQuality: airIndex))
                    .font(.title2)
                    .fontWeight(.heavy)
                    .fontDesign(.rounded)
            }
            Divider()
        }
    }
}

//#Preview(as: .systemMedium) {
//    AirQualityWidgetMedium()
//} timeline: {
//    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), airQuality: nil)
//}
