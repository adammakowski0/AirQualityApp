//
//  AirQualityWidgetSmallView.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import SwiftUI
import WidgetKit

struct AirQualityWidgetSmallView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry
    
    var widgetVM = WidgetViewModel()
    
    var body: some View {
        
        switch widgetFamily {
        case .systemSmall:
            VStack {
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                    
                    Text("\(entry.configuration.character?.stationName ?? "")")
                        .fontDesign(.rounded)
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 10)
                Spacer()
                Text("Wskaźnik jakości powietrza:")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
                let airIndex = entry.airQuality?.stIndexLevel.indexLevelName ?? "Brak danych"
                    Text(airIndex)
                        .foregroundStyle(widgetVM.getColor(forAirQuality: airIndex))
                        .font(.title)
                        .fontWeight(.heavy)
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2).gradient)
        case .systemMedium:
            VStack{
                HStack {
                    Image(systemName: "location.fill")
                    
                    Text("\(entry.configuration.character?.stationName ?? "")")
                        .fontDesign(.rounded)
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 10)
                HStack{
                    VStack {
                        
                        Text("Wskaźnik jakości powietrza:")
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
                    Spacer()
                }
            }.background(.gray.opacity(0.2).gradient)
        default:
            Text("Brak danych")
                .foregroundStyle(.gray)
                .font(.title2)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
        }
        
        

    }
}

#Preview(as: .systemSmall) {
    AirQualityWidgetSmall()
} timeline: {
    SimpleEntry(date: .now, configuration: SelectCharacterIntent(), airQuality: nil)
}
